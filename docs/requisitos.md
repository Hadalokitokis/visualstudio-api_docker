# Requisitos de infraestructura

| Requisito | Criterio de aceptación |
|---|---|
| RI-01. Los tres servicios se ejecutan en contenedores independientes. | `docker compose ps` muestra los servicios `db`, `api` y `proxy` en estado `Up`. |
| RI-02. Solo el proxy inverso está expuesto al exterior. | El servicio `proxy` tiene el puerto `8080:80`; `db` y `api` no tienen sección `ports`. |
| RI-03. Los datos de PostgreSQL persisten después de reiniciar los contenedores. | Después de ejecutar `docker compose down` y `docker compose up -d`, el volumen `pgdata-practica` continúa existiendo y PostgreSQL inicia correctamente. |
| RI-04. La solución debe operar con un máximo de 4 GB de memoria RAM. | `docker stats` permite verificar el consumo de memoria de los tres servicios durante la ejecución. |
| RI-05. La configuración sensible no está escrita directamente en la configuración de Docker Compose. | Las credenciales se suministran mediante variables de entorno y `.env` está incluido en `.gitignore`. |
| RI-06. Los servicios deben comunicarse mediante una red interna de Docker. | `docker compose config` muestra la red `interna` y los servicios están conectados a ella. |
| RI-07. PostgreSQL debe utilizar almacenamiento persistente. | El servicio `db` utiliza el volumen `pgdata-practica`. |
| RI-08. Nginx debe funcionar como proxy inverso hacia la API. | Al acceder a `http://localhost:8080/health`, Nginx reenvía la petición a la API y se obtiene una respuesta HTTP correcta. |
| RI-09. La API debe utilizar una imagen propia construida mediante Dockerfile multi-etapa. | `docker compose build api` construye correctamente la imagen de la API a partir del Dockerfile. |
| RI-OS-01. La solución debe poder ejecutarse en Windows mediante WSL2. | Docker Engine y Docker Compose funcionan correctamente dentro de Ubuntu 24.04 sobre WSL2. |
| RI-OS-02. La solución debe poder ejecutarse en Linux. | Los archivos Dockerfile y Docker Compose utilizan configuraciones compatibles con Linux. |
| RI-OS-03. La solución debe poder ejecutarse en macOS. | La solución utiliza Docker Compose y configuraciones independientes del sistema operativo anfitrión. |
