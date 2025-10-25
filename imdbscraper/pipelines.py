from itemadapter import ItemAdapter
import datetime
import logging
from .database_handler import DatabaseHandler

class SecondsToReal:
    """Converts the 'movie_length' from total seconds (int) to H:MM:SS string format."""

    def process_item(self, item, spider):
        adaptor = ItemAdapter(item)

        # 1. CONVERSIÓN DE movie_length: De Segundos a Minutos (INT)
        seconds = adaptor.get('movie_length_minutes')
        if isinstance(seconds, (int, float)) and seconds > 0:
            # Duración en minutos = segundos / 60
            minutes = round(seconds / 60)
            adaptor['movie_length_minutes'] = minutes
        else:
            adaptor['movie_length_minutes'] = None
        
        
        # 2. CONVERSIÓN DE TIPOS NUMÉRICOS FINALES
        
        for field in ['rating', 'metascore']:
            value = adaptor.get(field)
            if value is not None:
                try:
                    adaptor[field] = float(value)
                except (TypeError, ValueError):
                    adaptor[field] = None 
        
        # 3. CONVERSIÓN DE ACTORES (Lista a String para CSV o limpieza)
        
        actors_list = adaptor.get('main_actors')
        if isinstance(actors_list, list):
            adaptor['main_actors'] = " | ".join(actors_list)
        else:
            adaptor['main_actors'] = ""
        
        return item
    
class ImdbscraperPipeline:
    def __init__(self):
        
        db_config = {
            'host': 'localhost',
            'database': 'imdb',
            'user': 'imdbuser', 
            'password': 'imdbuser',
            'port': 3307  # Para MySQL
        }
        self.db_handler = DatabaseHandler(db_config)

    def open_spider(self, spider):
        """Ejecutar cuando el spider se inicia"""
        spider.logger.info("Inicializando base de datos...")
        self.db_handler.create_tables()

    def close_spider(self, spider):
        """Ejecutar cuando el spider termina"""
        movie_count = self.db_handler.get_movie_count()
        actor_count = self.db_handler.get_actor_count()
        spider.logger.info(f"Scraping completado. Películas: {movie_count}, Actores: {actor_count}")

    def process_item(self, item, spider):
        """Procesar cada item y guardar en BD"""
        try:
            self.db_handler.insert_movie_data(item)
            spider.logger.info(f"✅ Guardado en BD: {item['title']}")
        except Exception as e:
            spider.logger.error(f"❌ Error guardando {item['title']} en BD: {e}")
        
        return item
