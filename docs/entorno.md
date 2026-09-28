# Entorno de trabajo

## Sistema operativo

- Sistema operativo: Windows 11
- Versión: 25H2
- Compilación: 26200.9168
- Arquitectura: 64 bits

## Hardware

- Memoria RAM: aproximadamente 7.9 GB
- Espacio libre en disco C: aproximadamente 66 GB
- Virtualización: habilitada

## WSL2

- WSL: versión 2.7.8.0
- Kernel: 6.18.33.1-1
- Distribución Linux: Ubuntu 24.04 LTS

## Docker

- Docker Engine: 29.8.0
- Docker Compose: v5.5.1
- Contexto Docker: default
- Motor de almacenamiento: overlayfs

## Instalación

Docker Engine fue instalado dentro de Ubuntu mediante el repositorio oficial de Docker.

Se utilizó WSL2 para ejecutar Ubuntu 24.04 LTS en Windows 11.

Docker Desktop estaba instalado previamente, pero se utilizó Docker Engine directamente dentro de Ubuntu para evitar conflictos entre los diferentes contextos de Docker.

## Verificación

Se verificó correctamente la instalación mediante:

- `docker --version`
- `docker compose version`
- `docker info`
- `docker run --rm hello-world`

La prueba `hello-world` se ejecutó correctamente.

## Inconvenientes y soluciones

Durante la práctica con PostgreSQL 18 se presentó un inconveniente relacionado con la ubicación del directorio de datos. El contenedor inicialmente terminó con código de salida 1.

Al revisar los logs se identificó que PostgreSQL 18 utiliza una estructura de directorios específica para los datos y recomienda montar `/var/lib/postgresql`.

Se eliminó el contenedor con el error y se creó nuevamente utilizando el volumen `pgdata-practica` montado en `/var/lib/postgresql`. Después del cambio, PostgreSQL inició correctamente y mostró el mensaje:

`database system is ready to accept connections`

También se verificó Nginx mediante el navegador usando el puerto `8080`, mostrando correctamente la página de bienvenida de Nginx.
