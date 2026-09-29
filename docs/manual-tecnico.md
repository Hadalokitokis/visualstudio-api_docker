# Manual técnico

## 1. Descripción

La solución implementa una API Java 21 con Spring Boot, PostgreSQL 18 y Nginx. Los servicios se ejecutan mediante Docker Compose y se comunican por una red interna denominada `interna`.

| Servicio | Imagen / construcción | Puerto interno | Puerto publicado |
|---|---|---:|---:|
| db | postgres:18-alpine | 5432 | ninguno |
| api | Dockerfile multi-etapa | 8080 | ninguno |
| proxy | nginx:1.30-alpine | 80 | 8080 |

Solo el proxy es accesible desde el host.

## 2. Arquitectura y red

El cliente realiza peticiones HTTP al puerto 8080 del host. Nginx recibe la petición y la reenvía a `http://api:8080`.

La API se conecta a PostgreSQL mediante `jdbc:postgresql://db:5432/<DB_NAME>`. El nombre `db` se resuelve dentro de la red Docker `interna`.

El servicio `db` no contiene una sección `ports`, por lo que PostgreSQL no queda expuesto directamente al host.

El diagrama se encuentra en `docs/arquitectura.png`.

## 3. Dockerfile

La API utiliza un Dockerfile multi-etapa:

1. Etapa `builder`: Maven + Eclipse Temurin 21 para compilar.
2. Etapa final: Eclipse Temurin 21 JRE para ejecutar únicamente el JAR.

La imagen final crea el usuario `appuser` con UID 1001 y ejecuta Java sin privilegios de root.

## 4. Variables de entorno

El archivo `.env` contiene valores locales y no se publica en Git.

Archivo de ejemplo:

```text
DB_NAME=appdb
DB_ADMIN_PASSWORD=example_password
```

Compose utiliza estas variables para configurar PostgreSQL y la API. La aplicación recibe `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME` y `SPRING_DATASOURCE_PASSWORD` mediante el entorno.

## 5. Volumen y persistencia

PostgreSQL utiliza el volumen Docker `pgdata`.

La persistencia se comprobó creando una tabla de prueba, ejecutando:

```bash
docker compose down
docker compose up -d
```

y consultando nuevamente los datos. Los datos permanecieron disponibles después del reinicio.

Para eliminar deliberadamente los datos debe utilizarse:

```bash
docker compose down -v
```

## 6. Despliegue local

Desde una copia limpia:

```bash
git clone https://github.com/Hadalokitokis/visualstudio-api_docker.git
cd visualstudio-api_docker
cp .env.example .env
docker compose up -d --build
```

Verificación:

```bash
docker compose ps
curl http://localhost:8080/health
```

También:

```bash
docker compose logs -f api
```

## 7. Pruebas de validación

Configuración:

```bash
docker compose config
```

Estado:

```bash
docker compose ps
```

Healthcheck de la API:

```bash
curl http://localhost:8080/health
```

Persistencia:

```bash
docker compose down
docker compose up -d
```

Imagen de API:

```bash
docker history visualstudio-api
```

## 8. Publicación en GHCR

La imagen se publicó manualmente como:

```
ghcr.io/hadalokitokis/visualstudio-api_docker:1.0.0
```

Después se automatizó la publicación mediante GitHub Actions usando `GITHUB_TOKEN` con permisos `contents: read` y `packages: write`.

## 9. Despliegue remoto

Cuando el instructor habilite el servidor remoto del curso:

1. Conectarse por SSH.
2. Verificar Docker Engine y Docker Compose.
3. Clonar el repositorio.
4. Crear `.env` desde `.env.example`.
5. Ajustar el puerto externo asignado.
6. Ejecutar `docker compose up -d --build`.
7. Verificar `docker compose ps` y `curl http://localhost:<PUERTO_ASIGNADO>/health`.

En un servidor compartido no se deben reutilizar rutas, volúmenes o puertos de otros equipos. Los secretos deben mantenerse fuera del repositorio.

**Estado de evidencia:** el procedimiento remoto queda documentado; su ejecución depende de que el instructor habilite las credenciales, carpeta y puerto del equipo.

## 10. Propuesta de escalamiento

### Local vs. remoto

En local, el usuario controla equipo, rutas y puerto 8080. En remoto se deben considerar el puerto asignado, firewall, disponibilidad, almacenamiento persistente, copias de seguridad y monitoreo.

### Componentes para nube

- **API:** contenedores administrados para facilitar réplicas.
- **PostgreSQL:** servicio administrado para copias de seguridad y alta disponibilidad.
- **Nginx:** proxy o balanceador administrado.
- **GHCR:** registro de imágenes con etiquetas inmutables.

La API puede escalar horizontalmente porque no almacena el estado de negocio en el contenedor. PostgreSQL debe tratarse como componente persistente y escalarse con una arquitectura específica.

### Protección de datos personales

Si la aplicación procesa datos personales, deben aplicarse los principios y obligaciones de la Ley 1581 de 2012 y normas relacionadas: control de acceso, protección de credenciales, minimización de información en logs, conservación definida y eliminación segura.

## 11. Rollback

Para volver a una versión anterior se utiliza una etiqueta inmutable o digest.

Ejemplo:

```bash
docker pull ghcr.io/hadalokitokis/visualstudio-api_docker:sha-5631b30
```

Esto permite identificar exactamente la versión ejecutada y facilita volver a una versión anterior conocida.

## 12. Mantenimiento

```bash
docker compose ps
docker compose logs -f api
docker compose logs -f db
docker compose restart
docker compose down
```

No utilizar `docker compose down -v` salvo que se quiera eliminar deliberadamente el volumen y sus datos.
