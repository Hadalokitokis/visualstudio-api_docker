# Visual Studio API - Docker Deployment SENA

Proyecto integrador del curso **Despliegue de aplicaciones en contenedores Docker**.

La solución ejecuta tres servicios:

- **db:** PostgreSQL 18 Alpine.
- **api:** API Java 21 con Spring Boot, construida con Dockerfile multi-etapa y usuario sin privilegios.
- **proxy:** Nginx como proxy inverso.

Solo Nginx publica un puerto del host: **8080**. La API y PostgreSQL permanecen dentro de la red interna de Docker.

## Arquitectura

```
Cliente
   |
   | HTTP :8080
   v
 Nginx (proxy)
   |
   | red interna "interna"
   v
 API Spring Boot :8080
   |
   | PostgreSQL :5432
   v
 PostgreSQL 18
   |
   v
 volumen pgdata
```

El diagrama completo está en [docs/arquitectura.png](docs/arquitectura.png).

## Requisitos

- Git.
- Docker Engine + Docker Compose.
- Conexión a Internet para descargar las imágenes base.
- Aproximadamente 4 GB de RAM disponibles para trabajar cómodamente con la solución.

El entorno utilizado para validar el proyecto fue Windows 11 + WSL2 + Ubuntu 24.04 LTS. Los detalles están en [docs/entorno.md](docs/entorno.md).

## Instalación del motor Docker

### Windows

Se puede utilizar Docker Engine dentro de Ubuntu sobre WSL2, que es el entorno validado para este proyecto.

1. Instalar y habilitar WSL2.
2. Instalar Ubuntu 24.04 LTS.
3. Instalar Docker Engine y Docker Compose dentro de Ubuntu.
4. Verificar:

```bash
docker --version
docker compose version
docker run --rm hello-world
```

### Linux

Instalar Docker Engine y el plugin de Docker Compose siguiendo la documentación oficial de Docker para la distribución utilizada. Después verificar:

```bash
docker --version
docker compose version
docker run --rm hello-world
```

### macOS

Puede utilizarse Docker Desktop o un runtime compatible con Docker Engine, por ejemplo Colima.

Después de instalarlo y activar el runtime, verificar:

```bash
docker --version
docker compose version
docker run --rm hello-world
```

Para el entorno documentado del proyecto, consulte [docs/entorno.md](docs/entorno.md).

## Puesta en marcha

Clonar el repositorio:

```bash
git clone https://github.com/Hadalokitokis/visualstudio-api_docker.git
cd visualstudio-api_docker
```

Crear el archivo de configuración local:

```bash
cp .env.example .env
```

En Windows PowerShell, si se requiere:

```powershell
Copy-Item .env.example .env
```

Editar `.env` y establecer una contraseña local adecuada.

Levantar toda la solución:

```bash
docker compose up -d --build
```

Verificar:

```bash
docker compose ps
curl http://localhost:8080/health
```

## Persistencia

PostgreSQL utiliza el volumen Docker `pgdata`.

```bash
docker compose down
docker compose up -d
```

Estos comandos detienen y vuelven a iniciar los servicios sin eliminar el volumen.

**No usar `docker compose down -v`** si se desea conservar los datos.

## Variables de entorno

El archivo `.env` no se versiona. Se incluye `.env.example` con valores de ejemplo.

Variables principales:

- `DB_NAME`
- `DB_ADMIN_PASSWORD`

La API recibe las credenciales desde Compose y se conecta al host `db`, no a `localhost`.

## Publicación automática

El repositorio contiene [`.github/workflows/docker-publish.yml`](.github/workflows/docker-publish.yml).

Cada push a `main`:

1. Descarga el código.
2. Se autentica en GHCR mediante `GITHUB_TOKEN`.
3. Construye la imagen.
4. Publica `latest`.
5. Publica una etiqueta inmutable basada en el commit, por ejemplo `sha-5631b30`.

Evidencia de una ejecución exitosa:

https://github.com/Hadalokitokis/visualstudio-api_docker/actions/runs/36627645050

La imagen se publica en:

```
ghcr.io/hadalokitokis/visualstudio-api_docker
```

Versiones verificadas durante la práctica:

- `1.0.0` — publicación manual.
- `latest` — publicación automática.
- `sha-5631b30` — publicación automática e inmutable.

La documentación del flujo está en [docs/despliegue-automatizado.md](docs/despliegue-automatizado.md).

## Documentación

- [Requisitos de infraestructura](docs/requisitos.md)
- [Entorno](docs/entorno.md)
- [Imágenes Docker](docs/imagenes.md)
- [Manual técnico](docs/manual-tecnico.md)
- [Despliegue automatizado](docs/despliegue-automatizado.md)
- [Arquitectura](docs/arquitectura.png)

## Seguridad

- `.env` está excluido mediante `.gitignore`.
- La imagen final de la API ejecuta el proceso como `appuser`, no como root.
- PostgreSQL no publica el puerto 5432 al host.
- Las credenciales se suministran mediante variables de entorno.
- En producción se debe utilizar una etiqueta inmutable o un digest, no depender de `latest`.

## Pruebas realizadas

- Construcción de la API con Dockerfile multi-etapa.
- Levantamiento de db, api y proxy con Compose.
- Healthcheck de PostgreSQL.
- Prueba HTTP a través de Nginx.
- Prueba de persistencia después de `down` y `up`.
- Publicación manual en GHCR.
- Publicación automática mediante GitHub Actions.

## Entrega

Repositorio:

https://github.com/Hadalokitokis/visualstudio-api_docker
