# Imágenes Docker utilizadas

## 1. PostgreSQL

- Imagen: `postgres:18-alpine`
- Versión: PostgreSQL 18
- Uso: base de datos de la aplicación
- Tamaño aproximado: 433 MB
- Puerto utilizado en la práctica inicial: `5432:5432`
- Volumen: `pgdata-practica`

Comando utilizado en la práctica inicial:

```bash
docker run -d --name db-app \
  -e POSTGRES_PASSWORD=<PASSWORD> \
  -e POSTGRES_DB=appdb \
  -p 5432:5432 \
  -v pgdata-practica:/var/lib/postgresql \
  postgres:18-alpine -c shared_buffers=32MB -c max_connections=20
```

## 2. API

- Imagen: `visualstudio-api`
- Tamaño de la imagen multi-etapa: **522 MB (disk usage)**
- Content size: **142 MB**
- Base utilizada: eclipse-temurin:21-jre
- Construcción: Dockerfile multi-etapa con Maven
- Lenguaje: Java 21
- Framework: Spring Boot
- Puerto interno: 8080
- Usuario: `appuser` (no root)

## 3. Nginx

- Imagen: `nginx:1.30-alpine`
- Uso: proxy inverso
- Puerto del contenedor: 80
- Puerto publicado en el host: 8080

## 4. Comparación de imágenes


 Se compararon dos versiones de la imagen de la API

 | Imagen | Tipo de construcción | Disk usage | Content size |
 |---|---|---:|---:|
 | `visualstudio-api` | Multi-etapa | 522 MB | 142 MB |
 | `api-single-stage:1.0.0` | Una sola etapa | 947 MB | 310 MB |

 La imagen construida mediante Dockerfile multi-etapa utiliza menos espacio     que la imagen equivalente de una sola etapa. La diferencia de disk usage es       
 de aproximadamente 425 MB.

 La construcción multi-etapa permite separar la compilación de la ejecución y evita incluir las herramientas de Maven en la imagen final.

 Para revisar el tamaño y las capas de las imágenes se utilizaron:

 ```bash
 docker images
 docker history visualstudio-api
 docker system df
```

## 5. Verificación

Las imágenes y los contenedores se verificaron mediante:

```bash
docker compose build api
docker compose ps
docker images
docker history visualstudio-api
docker system df
```

