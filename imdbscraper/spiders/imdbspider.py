import scrapy
import json
import re
from imdbscraper.items import Info
from imdbscraper.proxy_manager import proxy_manager
import random

class ImdbspiderSpider(scrapy.Spider):
    name = "imdbspider"
    allowed_domains = ["imdb.com"]
    start_urls = ["https://m.imdb.com/chart/top/"]
    
    custom_settings = {
        'DOWNLOAD_DELAY': 2,
        'RANDOMIZE_DOWNLOAD_DELAY': True,
        'CONCURRENT_REQUESTS_PER_DOMAIN': 1,
        'USER_AGENT': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
    }

    def __init__(self, *args, **kwargs):
        super(ImdbspiderSpider, self).__init__(*args, **kwargs)
        # ACTIVAR PROXIES CON ARGUMENTO (opcional)
        if kwargs.get('use_proxies') == 'true':
            proxy_manager.enabled = True
            proxy_manager.current_proxy = random.choice(proxy_manager.proxies)

    def parse(self, response):
        raw_data = response.css("script[id='__NEXT_DATA__']::text").get()
        json_data = json.loads(raw_data)
        needed_data = json_data['props']['pageProps']['pageData']['chartTitles']['edges']

        for movie in needed_data:
            information = Info()
            information['title'] = movie['node']['titleText']['text']
            information['movie_rank'] = movie['currentRank']
            information['release_year'] = movie['node']['releaseYear']['year']
            information['rating'] = movie['node']['ratingsSummary']['aggregateRating']
            information['vote_count'] = movie['node']['ratingsSummary']['voteCount']
            information['description'] = movie['node']['plot']['plotText']['plainText']
            information['movie_length_minutes'] = movie['node']['runtime']['seconds']
            
            tconst = movie['node']['id']
            detail_url = f"https://m.imdb.com/title/{tconst}/"
            
            self.logger.info(f"Scraping details for: {information['title']} - {detail_url}")

            yield response.follow(
                detail_url, 
                callback=self.parse_detail, 
                meta={'item': information}
            )

    def parse_detail(self, response):
        information = response.meta['item']
        
        # Extraer Metascore con estrategias específicas
        metascore = self.extract_metascore(response)
        information['metascore'] = metascore
        
        # Extraer Actores Principales
        actors = self.extract_actors(response)
        information['main_actors'] = actors
        
        self.logger.info(f"Extracted for {information['title']}: Metascore={metascore}, Actors={actors}")
        
        yield information

    def extract_metascore(self, response):
        """Extrae el Metascore basado en el patrón específico encontrado"""
        metascore = None
        
        # ESTRATEGIA 1: Buscar en la lista de revisiones donde está el Metascore
        # El patrón está en: <ul class="ipc-inline-list ..." data-testid="reviewContent-all-reviews">
        review_list_selectors = [
            '//ul[@data-testid="reviewContent-all-reviews"]//span[@class="sc-9fe7b0ef-0 hDuMnh metacritic-score-box"]/text()',
            '//ul[contains(@class, "ipc-inline-list") and @data-testid="reviewContent-all-reviews"]//span[contains(@class, "metacritic-score-box")]/text()',
            '//a[contains(@href, "criticreviews")]//span[contains(@class, "metacritic-score-box")]/text()',
        ]
        
        for selector in review_list_selectors:
            result = response.xpath(selector).get()
            if result:
                try:
                    cleaned = result.strip()
                    if cleaned and cleaned.isdigit() and 0 <= int(cleaned) <= 100:
                        metascore = int(cleaned)
                        self.logger.info(f"Metascore found with review list selector: {selector} -> {metascore}")
                        return metascore
                except (ValueError, TypeError, AttributeError):
                    continue
        
        # ESTRATEGIA 2: Buscar por el texto "Metascore" en las etiquetas cercanas
        metascore_label_selectors = [
            '//span[contains(text(), "Metascore")]/preceding-sibling::span//span[contains(@class, "metacritic-score-box")]/text()',
            '//span[@class="metacritic-score-label"][contains(text(), "Metascore")]/preceding-sibling::span//span[contains(@class, "metacritic-score-box")]/text()',
            '//span[contains(@class, "label") and contains(text(), "Metascore")]/preceding-sibling::span//span[contains(@class, "metacritic-score-box")]/text()',
        ]
        
        for selector in metascore_label_selectors:
            result = response.xpath(selector).get()
            if result:
                try:
                    cleaned = result.strip()
                    if cleaned and cleaned.isdigit() and 0 <= int(cleaned) <= 100:
                        metascore = int(cleaned)
                        self.logger.info(f"Metascore found with label selector: {selector} -> {metascore}")
                        return metascore
                except (ValueError, TypeError, AttributeError):
                    continue
        
        # ESTRATEGIA 3: Buscar cualquier elemento con la clase metacritic-score-box
        all_metacritic_spans = response.xpath('//span[contains(@class, "metacritic-score-box")]/text()').getall()
        for span_text in all_metacritic_spans:
            try:
                cleaned = span_text.strip()
                if cleaned and cleaned.isdigit() and 0 <= int(cleaned) <= 100:
                    metascore = int(cleaned)
                    self.logger.info(f"Metascore found in any metacritic span: {metascore}")
                    return metascore
            except (ValueError, TypeError, AttributeError):
                continue
        
        # ESTRATEGIA 4: Buscar por el estilo de fondo específico
        style_selectors = [
            '//span[contains(@style, "background-color:#54A72A")]/text()',
            '//span[contains(@style, "#54A72A")]/text()',
        ]
        
        for selector in style_selectors:
            result = response.xpath(selector).get()
            if result:
                try:
                    cleaned = result.strip()
                    if cleaned and cleaned.isdigit() and 0 <= int(cleaned) <= 100:
                        metascore = int(cleaned)
                        self.logger.info(f"Metascore found by style: {selector} -> {metascore}")
                        return metascore
                except (ValueError, TypeError, AttributeError):
                    continue
        
        # ESTRATEGIA 5: Buscar en toda la sección de revisiones
        review_section = response.xpath('//ul[@data-testid="reviewContent-all-reviews"]')
        if review_section:
            # Buscar todos los números en esta sección y encontrar el que está cerca de "Metascore"
            review_text = ' '.join(review_section.xpath('.//text()').getall())
            # Buscar números y verificar contexto
            numbers = re.findall(r'\b(\d{1,3})\b', review_text)
            for num in numbers:
                if 0 <= int(num) <= 100:
                    # Verificar si este número está cerca de "Metascore"
                    num_xpath = f'//ul[@data-testid="reviewContent-all-reviews"]//*[contains(text(), "{num}")]'
                    element_with_num = response.xpath(num_xpath)
                    if element_with_num:
                        surrounding_text = ' '.join(element_with_num.xpath('./ancestor::li[1]//text()').getall())
                        if 'metascore' in surrounding_text.lower():
                            metascore = int(num)
                            self.logger.info(f"Metascore found via text context: {metascore}")
                            return metascore
        
        self.logger.warning(f"Metascore not found for {response.url}")
        return None

    def extract_actors(self, response):
        """Extrae actores principales"""
        actors = []
        
        # ESTRATEGIA 1: Buscar en la sección "Stars" del elenco principal
        stars_selectors = [
            '//li[@data-testid="title-pc-principal-credit"]//a[contains(@class, "ipc-metadata-list-item__list-content-item") and contains(@href, "/name/")]/text()',
            '//li[.//span[contains(text(), "Stars")]]//a[contains(@href, "/name/")]/text()',
            '//a[@aria-label="See full cast and crew"]/preceding-sibling::div//a[contains(@href, "/name/")]/text()',
        ]
        
        for selector in stars_selectors:
            found_actors = response.xpath(selector).getall()
            if found_actors:
                cleaned_actors = []
                for actor in found_actors:
                    actor_clean = actor.strip()
                    if (actor_clean and 
                        len(actor_clean) > 1 and
                        not actor_clean.startswith('See') and
                        not 'full cast' in actor_clean.lower()):
                        cleaned_actors.append(actor_clean)
                
                if cleaned_actors:
                    actors = cleaned_actors[:5]  # Tomar primeros 5 actores
                    self.logger.info(f"Actors found with stars selector: {selector} -> {actors[:3]}")
                    break
        
        # ESTRATEGIA 2: Buscar en datos estructurados JSON-LD
        if not actors:
            json_ld_scripts = response.xpath('//script[@type="application/ld+json"]/text()').getall()
            for script in json_ld_scripts:
                try:
                    data = json.loads(script)
                    if isinstance(data, dict) and 'actor' in data:
                        actor_list = data['actor']
                        if isinstance(actor_list, list):
                            for actor in actor_list:
                                if isinstance(actor, dict) and 'name' in actor:
                                    actors.append(actor['name'].strip())
                            if actors:
                                self.logger.info(f"Actors found in JSON-LD: {actors[:3]}")
                                return actors[:5]
                except json.JSONDecodeError:
                    continue
        
        # ESTRATEGIA 3: Buscar en secciones de reparto modernas
        if not actors:
            cast_selectors = [
                '//section[@data-testid="title-cast"]//a[@data-testid="title-cast-item__actor"]/text()',
                '//div[@data-testid="title-cast-item"]//a[contains(@href, "/name/")]/text()',
            ]
            
            for selector in cast_selectors:
                found_actors = response.xpath(selector).getall()
                if found_actors:
                    cleaned_actors = []
                    for actor in found_actors:
                        actor_clean = actor.strip()
                        if actor_clean and len(actor_clean) > 1:
                            cleaned_actors.append(actor_clean)
                    
                    if cleaned_actors:
                        actors = cleaned_actors[:5]
                        self.logger.info(f"Actors found with cast selector: {selector} -> {actors[:3]}")
                        break
        
        return actors[:5]  # Retornar máximo 5 actores
