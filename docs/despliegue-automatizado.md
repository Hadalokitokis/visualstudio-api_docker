# Despliegue automatizado

## 1. Objetivo

Automatizar la construcción y publicación de la imagen de la API en GitHub Container Registry (GHCR) cada vez que se integra un cambio en la rama `main`.

Workflow:

```
.github/workflows/docker-publish.yml
```

## 2. Cadena de publicación

```
push a main
    |
    v
GitHub Actions
    |
    +--> checkout
    +--> autenticación en ghcr.io con GITHUB_TOKEN
    +--> generación de etiquetas
    +--> docker build
    +--> docker push
    |
    v
GitHub Container Registry
```

El workflow utiliza:

```yaml
permissions:
  contents: read
  packages: write
```

## 3. Etiquetas

Se publican:

- `latest`: referencia móvil.
- `sha-<commit>`: referencia inmutable basada en el commit.

Durante la validación se publicó correctamente:

```
ghcr.io/hadalokitokis/visualstudio-api_docker:latest
ghcr.io/hadalokitokis/visualstudio-api_docker:sha-5631b30
```

También existe la versión manual:

```
ghcr.io/hadalokitokis/visualstudio-api_docker:1.0.0
```

Para producción se debe desplegar una referencia inmutable o digest, no depender de `latest`.

## 4. Evidencia

Ejecución exitosa:

https://github.com/Hadalokitokis/visualstudio-api_docker/actions/runs/36627645050

Resultado: **success**.

Commit asociado: `5631b30`.

## 5. Paquete

```
ghcr.io/hadalokitokis/visualstudio-api_docker
```

La etiqueta `sha-5631b30` aparece en Packages como versión publicada automáticamente.

## 6. Permisos

El repositorio `Hadalokitokis/visualstudio-api_docker` fue agregado a **Manage Actions access** del paquete con rol **Write**, permitiendo que el workflow publique nuevas versiones.

## 7. Continuación hacia producción

```
main
  |
  v
GitHub Actions
  |
  v
Build + GHCR
  |
  v
Pruebas
  |
  v
Aprobación de producción
  |
  v
Servidor / plataforma de contenedores
  |
  v
Pull de imagen inmutable
  |
  v
Healthcheck
  |
  v
Servicio disponible
```

Las claves SSH, host y usuario deben almacenarse como secretos protegidos y nunca escribirse en el repositorio.

## 8. Rollback

Si una versión falla, se utiliza una imagen anterior mediante su etiqueta inmutable o digest:

```bash
docker pull ghcr.io/hadalokitokis/visualstudio-api_docker:sha-5631b30
```

## 9. Seguridad

- No almacenar tokens ni contraseñas en el workflow.
- Utilizar `GITHUB_TOKEN` para publicar desde Actions.
- Mantener `.env` fuera del repositorio.
- Usar secretos de GitHub para credenciales de despliegue.
- En producción, preferir referencias inmutables.
