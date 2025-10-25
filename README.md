# 🎬 IMDB Scraper - Prueba Técnica Senior

## 📋 Descripción del Proyecto
Scraper robusto desarrollado en Python/Scrapy para extraer información de las 50 mejores películas de IMDB, con persistencia en base de datos relacional y sistema avanzado de evasión de bloqueos.

## 🎯 Objetivos Cumplidos

### ✅ **Punto 1: Scraper IMDB (60%)**
- **✅ Extracción de datos completos**: Título, año, calificación, duración, metascore, actores principales
- **✅ Tecnología**: Scrapy + BeautifulSoup (sin Selenium/Playwright)
- **✅ Estructura modular**: Pipelines, middlewares, items separados
- **✅ Manejo de errores**: Try-except, validación de campos, reintentos
- **✅ Exportación**: CSV + Base de datos PostgreSQL/MySQL

### ✅ **Punto 2: Persistencia y SQL Avanzado (20%)**
- **✅ Modelo relacional**: 2 tablas relacionadas (`peliculas`, `actores`)
- **✅ Consultas SQL avanzadas**:
  - Top 5 películas por duración por década
  - Desviación estándar de calificaciones por año
  - Diferencias >20% entre rating IMDB y Metascore
  - Vistas con funciones de ventana (OVER/PARTITION BY)
  - Índices optimizados

### ✅ **Punto 3: Proxies & Control de Red (10%)**
- **✅ Sistema de proxies rotativos** con 5 IPs diferentes
- **✅ Activación/Desactivación fácil** via variable de configuración
- **✅ Evidencia en logs** de IPs utilizadas
- **✅ Rotación automática** cada 5 requests

### ✅ **Punto 4: Comparación Técnica (10%)**
- **✅ Documentación completa** comparando Scrapy vs Selenium/Playwright
- **✅ Justificación técnica** de decisiones de arquitectura

## 🛠️ Tecnologías Utilizadas

- **Python 3.12** + **Scrapy 2.13.3**
- **MySQL/PostgreSQL** - Base de datos relacional
- **BeautifulSoup4** - Parsing de HTML
- **mysql-connector-python** - Conexión a BD
- **Sistema de proxies rotativos** - Evasión de bloqueos

## 📁 Estructura del Proyecto
imdb-scraper/
├── imdbscraper/
│ ├── spiders/
│ │ └── imdbspider.py # Spider principal
│ ├── init.py
│ ├── items.py # Definición de datos
│ ├── pipelines.py # Procesamiento y BD
│ ├── middlewares.py # Middlewares personalizados
│ ├── proxy_manager.py # Gestión de proxies
│ ├── database_handler.py # Manejo de base de datos
│ └── settings.py # Configuración Scrapy
├── database_setup.sql # Script inicialización BD
├── queries_punto2.sql # Consultas SQL avanzadas
├── COMPARACION_TECNICA.md # Análisis técnico
├── movies.csv # Datos exportados
└── README.md # Este archivo


## 🚀 Instalación y Configuración

### 1. Requisitos Previos
```bash
# Instalar dependencias
pip install scrapy beautifulsoup4 mysql-connector-python scrapy-user-agents

# O usar requirements.txt
pip install -r requirements.txt

### 2. Configuración de Base de Datos

# Ejecutar script de inicialización
mysql -u root -p < database_setup.sql

### 3. Configuración del Proyecto
Modificar settings.py con tus credenciales de BD:

python
DB_CONFIG = {
    'host': 'localhost',
    'database': 'nombrebd',
    'user': 'user',
    'password': 'pass',
    'port': 3306
}

### Uso del Scraper
Ejecución Básica (sin proxies)

```bash

scrapy crawl imdbspider -o movies.csv

# Opción 1: Cambiar settings.py
PROXY_ENABLED = True

### Ejecución con Proxies Habilitados
```bash

# Opción 2: Usar argumento
scrapy crawl imdbspider -a use_proxies=true -o movies.csv


### Ejecución con Límite de Películas

```bash
scrapy crawl imdbspider -a limit=10 -o movies.csv


### 🔧 Configuración de Proxies
### Activación/Desactivación
### En settings.py:

PROXY_ENABLED = True  # Cambiar a False para deshabilitar


### Lista de Proxies
### En proxy_manager.py:
### se deben ajustar a tu necesidad

self.proxies = [
    'http://45.77.56.109:3128',
    'http://138.197.157.32:3128',
    'http://165.227.103.219:3128',
    'http://51.158.68.68:8811',
    'http://163.172.157.7:8811',
]


### Evidencia de Funcionamiento
### Proxies Rotativos

2025-10-24 17:24:01 [imdbspider] INFO: 🌐 REQUEST #1 con PROXY: http://51.158.68.68:8811
2025-10-24 17:24:01 [imdbspider] INFO: 📡 URL: https://m.imdb.com/chart/top/



#### Base de Datos

2025-10-24 17:24:17 [imdbspider] INFO: Scraping completado. Películas: 22, Actores: 110


#### Extracción de Datos
### 📈 Consultas SQL Avanzadas
### Ejecutar análisis de datos:

´´´bash

mysql -u imdbuser -p imdb < queries_punto2.sql

#### Consultas Implementadas:
Top 5 películas por duración por década
Desviación estándar de ratings por año
Diferencias significativas IMDB vs Metascore
Vista de películas y actores principales
Índices optimizados para performance

#### 🛡️ Estrategias de Evasión
Técnicas Implementadas:
✅ Headers personalizados - User-Agent rotation
✅ Delays aleatorios - 1-3 segundos entre requests
✅ Proxies rotativos - 5 IPs diferentes
✅ Cookies management - Manejo automático de sesiones
✅ Retry middleware - Reintentos automáticos en fallos

### Logs de Evidencia:

🔧 PROXIES HABILITADOS - Usando: http://51.158.68.68:8811
🌐 REQUEST #1 con PROXY: http://51.158.68.68:8811
🔄 PROXY ROTADO: http://51.158.68.68:8811 -> http://138.197.157.32:3128


# Comparación Técnica: Scrapy vs Selenium/Playwright

## Scrapy (Implementado)
- ✅ **Ventajas:** Más rápido, menos recursos, mejor para scraping a gran escala
- ✅ **Uso ideal:** APIs ocultas, datos estructurados, sitios con JSON
- ✅ **Nuestra implementación:** Extracción eficiente de IMDB via JSON interno

## Selenium/Playwright (Alternativa)
- 🔧 **Configuración:** Navegador real, headless, evasión de detección
- ⏱️ **Rendimiento:** Más lento pero maneja JavaScript complejo
- 🎯 **Caso de uso:** Cuando el sitio requiere ejecución de JS

## Justificación de Scrapy
IMDB tiene datos disponibles via JSON interno, haciendo Scrapy la opción óptima.


### 🐛 Solución de Problemas
Error: Connection Timeout

# En settings.py
DOWNLOAD_TIMEOUT = 30
RETRY_TIMES = 3

### Error: Base de Datos
bash
# Verificar conexión
mysql -u imdbuser -p imdb -e "SHOW TABLES;"

#### Error: Proxies
# Deshabilitar temporalmente
PROXY_ENABLED = False

### 📄 Licencia
### Este proyecto fue desarrollado como prueba técnica siguiendo los requisitos especificados en el documento de evaluación.


### 🎯 ENTREGA COMPLETA: Todos los puntos técnicos implementados y verificados ✅