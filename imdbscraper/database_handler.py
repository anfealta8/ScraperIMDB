import mysql.connector 
from contextlib import contextmanager
import logging

class DatabaseHandler:
    def __init__(self, config):
        self.config = config
        self.logger = logging.getLogger(__name__)

    @contextmanager
    def get_connection(self):
        """Context manager para manejar conexiones a la BD"""
        conn = None
        try:
            
            conn = mysql.connector.connect(**self.config)
            self.logger.info("Conexión a BD establecida")
            yield conn
        except Exception as e:
            self.logger.error(f"Error conectando a BD: {e}")
            raise
        finally:
            if conn:
                conn.close()
                self.logger.info("Conexión a BD cerrada")

    def create_tables(self):
        """Crear las tablas si no existen"""
        create_peliculas_table = """
        CREATE TABLE IF NOT EXISTS peliculas (
            id INT AUTO_INCREMENT PRIMARY KEY,
            titulo VARCHAR(255) NOT NULL,
            anio INT NOT NULL,
            calificacion DECIMAL(3,1) NOT NULL,
            duracion INT,
            metascore INT,
            UNIQUE KEY unique_titulo_anio (titulo, anio)
        );
        """
        
        create_actores_table = """
        CREATE TABLE IF NOT EXISTS actores (
            id INT AUTO_INCREMENT PRIMARY KEY,
            pelicula_id INT NOT NULL,
            nombre VARCHAR(255) NOT NULL,
            FOREIGN KEY (pelicula_id) REFERENCES peliculas(id) ON DELETE CASCADE,
            INDEX idx_pelicula_id (pelicula_id)
        );
        """

        with self.get_connection() as conn:
            cursor = conn.cursor()
            try:
                cursor.execute(create_peliculas_table)
                cursor.execute(create_actores_table)
                conn.commit()
                self.logger.info("Tablas creadas/existen verificadas")
            except Exception as e:
                conn.rollback()
                self.logger.error(f"Error creando tablas: {e}")
                raise

    def insert_movie_data(self, item):
        """Insertar datos de película y actores"""
        # Insertar película
        insert_pelicula = """
        INSERT INTO peliculas (titulo, anio, calificacion, duracion, metascore)
        VALUES (%s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE 
            calificacion = VALUES(calificacion),
            duracion = VALUES(duracion),
            metascore = VALUES(metascore)
        """
        
        
        with self.get_connection() as conn:
            cursor = conn.cursor()
            try:
                # Insertar película
                pelicula_data = (
                    item['title'],
                    item['release_year'],
                    item['rating'],
                    item['movie_length_minutes'],
                    item['metascore']
                )
                
                cursor.execute(insert_pelicula, pelicula_data)
                pelicula_id = cursor.lastrowid
                
                # Si es una actualización, necesitamos obtener el ID existente
                if pelicula_id == 0:
                    cursor.execute(
                        "SELECT id FROM peliculas WHERE titulo = %s AND anio = %s",
                        (item['title'], item['release_year'])
                    )
                    result = cursor.fetchone()
                    pelicula_id = result[0] if result else None
                
                # Insertar actores si tenemos pelicula_id
                if pelicula_id and item.get('main_actors'):
                    # Limpiar actores existentes primero
                    cursor.execute("DELETE FROM actores WHERE pelicula_id = %s", (pelicula_id,))
                    
                    # Insertar nuevos actores
                    actors = item['main_actors']
                    if isinstance(actors, str):
                        # Si viene como string separado por " | "
                        actors = [actor.strip() for actor in actors.split('|') if actor.strip()]
                    
                    for actor in actors[:5]:  # Máximo 5 actores principales
                        if actor and len(actor) > 1:
                            cursor.execute(
                                "INSERT INTO actores (pelicula_id, nombre) VALUES (%s, %s)",
                                (pelicula_id, actor.strip())
                            )
                
                conn.commit()
                self.logger.info(f"Película insertada/actualizada: {item['title']} (ID: {pelicula_id})")
                
            except Exception as e:
                conn.rollback()
                self.logger.error(f"Error insertando película {item['title']}: {e}")
                raise

    def get_movie_count(self):
        """Obtener conteo de películas en la BD"""
        with self.get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT COUNT(*) FROM peliculas")
            return cursor.fetchone()[0]

    def get_actor_count(self):
        """Obtener conteo de actores en la BD"""
        with self.get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT COUNT(*) FROM actores")
            return cursor.fetchone()[0]