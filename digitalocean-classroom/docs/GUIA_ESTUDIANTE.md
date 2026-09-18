# Práctica: Alta disponibilidad web en una máquina en la nube

Repositorio de la práctica (guía, código y app): https://github.com/mendezgarabetti/infra-lab

## Objetivo de aprendizaje

Al terminar esta actividad vas a poder:

- Explicar qué es el balanceo de carga y para qué sirve.
- Explicar qué es la alta disponibilidad (HA) y por qué un sistema no debería depender de un único servidor.
- Entender cómo varios procesos pueden compartir estado (contador global) a través de un almacenamiento centralizado (Redis).
- Diagnosticar un servicio en una máquina Linux remota usando herramientas de red y contenedores.

## Objetivo práctico

Vas a operar tu propia máquina virtual (VM) en la nube, igual que lo haría alguien administrando un servidor real:

- Conectarte por SSH a tu VM.
- Desplegar una aplicación web compuesta por varios servicios (Nginx + 2 instancias Node.js + Redis) usando Docker.
- Comprobar que el sistema sigue funcionando aunque se caiga uno de los servidores.
- Proponer y aplicar una mejora técnica sobre el sistema.

## Consignas generales

1. Conectarte a tu VM y verificar que tenés acceso y red privada con tus compañeros.
2. Desplegar el stack completo con Docker Compose y validar que los 4 servicios están funcionando.
3. Someter el sistema a una prueba de carga y simular la caída de un nodo, comprobando que el servicio sigue respondiendo.
4. Implementar al menos **2 mejoras técnicas** sobre el sistema base y documentarlas.

En cada etapa vas a generar evidencia (capturas de pantalla o salidas de comandos) que forma parte de tu entrega.

## Cómo conectarte a tu VM

El docente te asignó por WhatsApp:

- Un usuario (por ejemplo `student07`).
- Una IP pública.
- Una contraseña temporal.

Paso 1: conectate por SSH usando la contraseña.

```bash
ssh studentXX@TU_IP_PUBLICA
```

Cuando pregunte por la contraseña, pegala (no se ve mientras escribís, es normal).

Paso 2 (recomendado, mejora tu seguridad): una vez adentro, subí tu propia clave SSH para no depender más de la contraseña.

Desde tu computadora (no desde la VM):

```bash
ssh-copy-id studentXX@TU_IP_PUBLICA
```

Desde ese momento podés entrar sin contraseña.

El repositorio de la práctica ya viene clonado en tu VM en:

```
/opt/lab/repo
```

## Bloque 1 — Conectividad

1. Conectarte por SSH a tu VM asignada (ver sección anterior).
2. Confirmar tu usuario con `whoami`.
3. Confirmar tu IP privada con `ip -4 a` (buscar la interfaz con rango `10.30.x.x`).
4. Pedirle a un compañero su IP privada y probar conectividad:

```bash
ping -c 3 10.30.0.X
```

Evidencia requerida:

- Captura de `whoami`.
- Captura de conectividad privada exitosa (ping a un compañero).

## Bloque 2 — Deploy de la aplicación

1. Entrar a la carpeta del proyecto (ya clonado en tu VM):

```bash
cd /opt/lab/repo
```

2. Levantar el stack completo:

```bash
sudo docker compose up --build -d
```

3. Verificar que los 4 servicios estén arriba:

```bash
sudo docker compose ps
```

4. Validar el endpoint localmente y anotar el hostname que responde:

```bash
curl http://localhost:8080
```

Evidencia requerida:

- Salida de `docker compose ps` con los 4 servicios en estado `Up`.
- 10 respuestas de `curl` mostrando hostname + contador (`global_visits`).

## Bloque 3 — Alta disponibilidad y fallas

1. Ejecutar la prueba de estrés:

```bash
chmod +x stress-test.sh
./stress-test.sh
```

2. Detener un nodo web (simular una caída):

```bash
sudo docker stop infra-lab-web-n01-1
```

3. Verificar que el sistema sigue respondiendo:

```bash
curl http://localhost:8080
```

4. Restaurar el nodo y validar recuperación:

```bash
sudo docker start infra-lab-web-n01-1
```

Evidencia requerida:

- Salida de `stress-test.sh`.
- Capturas de antes y después de la falla (mostrando que el servicio siguió disponible).

## Bloque 4 — Extensión avanzada

Implementá al menos 2 de estas mejoras:

- Endpoint `/healthz`.
- Healthcheck en el `docker-compose.yml`.
- Rate limit en Nginx.
- Logs estructurados.
- Script de verificación automática.

Evidencia requerida:

- Commit con tus mejoras.
- Mini informe técnico (máximo 1 página) explicando qué implementaste y por qué.

## Rúbrica

- 30% funcionamiento reproducible.
- 30% diagnóstico y resolución de fallas.
- 20% calidad técnica de las mejoras.
- 20% documentación/evidencia.
