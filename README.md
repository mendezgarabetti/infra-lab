# Laboratorio: Alta Disponibilidad Web con Nginx, Node.js y Redis

Este repositorio contiene un laboratorio educativo para demostrar:

- Balanceo de carga con Nginx.
- Escalado horizontal con 2 nodos Node.js.
- Estado compartido con Redis.
- Alta disponibilidad básica frente a caída de un nodo.

## Estructura

```text
infra-lab/
├── docker-compose.yml
├── .gitattributes
├── README.md
├── stress-test.sh
├── nginx/
│   └── nginx.conf
└── app/
    ├── Dockerfile
    ├── package.json
    └── server.js
```

## Requisitos

- Docker Desktop (o Docker Engine + Docker Compose)

## Levantar el laboratorio

Desde la carpeta `infra-lab` ejecuta:

```bash
docker-compose up --build -d
```

Verifica contenedores:

```bash
docker-compose ps
```

## Probar en navegador

Abre:

- http://localhost:8080

Recarga varias veces. Verás respuestas como:

```text
hostname=<contenedor> | global_visits=<contador_global>
```

- El hostname cambiará entre `web-n01` y `web-n02` por el balanceo.
- El contador `global_visits` seguirá subiendo globalmente porque Redis comparte estado.

## Prueba de estrés rápida

Dar permisos y ejecutar:

```bash
chmod +x stress-test.sh
./stress-test.sh
```

El script envía 100 peticiones rápidas y muestra las respuestas para observar el reparto de tráfico.

## Simular caída de un nodo (HA)

Puedes detener un nodo:

```bash
docker stop infra-lab-web-n01-1
```

Alternativa con Compose:

```bash
docker-compose stop web-n01
```

Luego vuelve a consultar http://localhost:8080 y comprobarás que el servicio responde por el otro nodo.

## Apagar y limpiar

```bash
docker-compose down
```

Si quieres también eliminar volúmenes:

```bash
docker-compose down -v
```
