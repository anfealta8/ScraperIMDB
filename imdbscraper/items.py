import scrapy

class Info(scrapy.Item):
    title = scrapy.Field()
    movie_rank = scrapy.Field()
    release_year = scrapy.Field()
    rating = scrapy.Field()
    vote_count = scrapy.Field()
    description = scrapy.Field()
    movie_length_minutes = scrapy.Field()
    metascore = scrapy.Field()  # Nuevo campo
    main_actors = scrapy.Field()  # Nuevo campo


