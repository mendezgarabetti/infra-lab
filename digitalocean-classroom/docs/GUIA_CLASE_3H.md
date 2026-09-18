# Guia de Actividad (3 horas)

Repositorio de la practica (guia, codigo y app): https://github.com/mendezgarabetti/infra-lab

## Objetivo

Que cada estudiante opere su propia VM y demuestre:

- Conectividad de red privada entre VMs.
- Despliegue reproducible de una app web.
- Balanceo de carga y continuidad ante fallas.
- Registro de evidencias tecnicas.

## Como conectarte a tu VM

El docente te asigno por WhatsApp:

- Un usuario (por ejemplo `student07`).
- Una IP publica.
- Una contraseña temporal.

Paso 1: conectate por SSH usando la contraseña.

```bash
ssh studentXX@TU_IP_PUBLICA
```

Cuando pregunte por la contraseña, pegala (no se ve mientras escribis, es normal).

Paso 2 (recomendado, mejora tu seguridad): una vez adentro, subi tu propia clave SSH para no depender mas de la contraseña.

Desde tu computadora (no desde la VM):

```bash
ssh-copy-id studentXX@TU_IP_PUBLICA
```

Desde ese momento podes entrar sin contraseña.

El repositorio de la practica ya viene clonado en la VM en:

```
/opt/lab/repo
```

## Parte A - Preflight (0:00 - 0:40)

1. Conectarse por SSH a su VM asignada (ver seccion anterior).
2. Confirmar usuario con `whoami`.
3. Confirmar IP privada con `ip -4 a` (buscar la interfaz con rango `10.30.x.x`).
4. Pedirle a un companero su IP privada y probar conectividad:

```bash
ping -c 3 10.30.0.X
```

Evidencia requerida:

- Captura de `whoami`.
- Captura de conectividad privada exitosa (ping a un companero).

## Parte B - Deploy Base (0:40 - 1:30)

1. Entrar a la carpeta del proyecto (ya clonado por el docente):

```bash
cd /opt/lab/repo
```

2. Levantar el stack completo:

```bash
sudo docker compose up --build -d
```

3. Verificar que los 4 servicios esten arriba:

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

## Parte C - HA y fallas (1:30 - 2:20)

1. Ejecutar la prueba de estres:

```bash
chmod +x stress-test.sh
./stress-test.sh
```

2. Detener un nodo web (simular una caida):

```bash
sudo docker stop infra-lab-web-n01-1
```

3. Verificar que el sistema sigue respondiendo:

```bash
curl http://localhost:8080
```

4. Restaurar el nodo y validar recuperacion:

```bash
sudo docker start infra-lab-web-n01-1
```

Evidencia requerida:

- Salida de `stress-test.sh`.
- Capturas de antes y despues de la falla (mostrando que el servicio siguio disponible).

## Parte D - Extension avanzada (2:20 - 3:00)

Implementar al menos 2 mejoras:

- Endpoint /healthz.
- Healthcheck en compose.
- Rate limit en Nginx.
- Ajuste de logs estructurados.
- Script de verificacion automatica.

Evidencia requerida:

- Commit con mejoras.
- Mini informe tecnico (max 1 pagina).

## Rubrica rapida

- 30% funcionamiento reproducible.
- 30% diagnostico y resolucion de fallas.
- 20% calidad tecnica de mejoras.
- 20% documentacion/evidencia.
