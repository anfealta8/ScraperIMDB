-- Crear base de datos (ejecutar primero)
CREATE DATABASE IF NOT EXISTS imdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Crear usuario (opcional)
CREATE USER IF NOT EXISTS 'imdbuser'@'localhost' IDENTIFIED BY 'imdbuser';
GRANT ALL PRIVILEGES ON imdb.* TO 'imdbuser'@'localhost';
FLUSH PRIVILEGES;

-- Usar la base de datos
USE imdb;


CREATE TABLE `peliculas` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `titulo` varchar(255) NOT NULL,
  `anio` int NOT NULL,
  `calificacion` decimal(3,1) NOT NULL,
  `duracion` int DEFAULT NULL,
  `metascore` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `idx_peliculas_anio_calificacion` (`anio`,`calificacion`),
  KEY `idx_peliculas_duracion` (`duracion`),
  KEY `idx_peliculas_titulo` (`titulo`)
);

CREATE TABLE `actores` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `pelicula_id` bigint unsigned NOT NULL,
  `nombre` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `idx_actores_pelicula_id` (`pelicula_id`),
  CONSTRAINT `FK_actores_peliculas` FOREIGN KEY (`pelicula_id`) REFERENCES `peliculas` (`id`)
);