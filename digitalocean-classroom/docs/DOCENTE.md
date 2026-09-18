# Notas para el docente (no compartir con estudiantes)

Automatización para aprovisionar 24 VMs de estudiantes en una VPC compartida de DigitalOcean, con acceso SSH y red privada entre VMs.

## Qué crea

- 1 VPC compartida para toda la clase.
- 24 droplets pequeños (1 por estudiante, por defecto).
- 1 firewall con:
  - SSH desde CIDRs autorizadas.
  - Tráfico interno TCP entre VMs de la VPC.
  - Egreso completo para instalar herramientas.
- Usuario Linux por estudiante: student01..student24.

## Requisitos

- Terraform >= 1.5
- jq
- Cuenta de DigitalOcean con cuota suficiente

## Seguridad de token

No guardes el token en archivos del repo.
Define la variable de entorno antes de ejecutar:

```bash
export DIGITALOCEAN_TOKEN="dop_v1_..."
```

## Configuración

1. Copia ejemplo de variables:

```bash
cd digitalocean-classroom/terraform
cp terraform.tfvars.example terraform.tfvars
```

2. Completa en `terraform.tfvars`:
- `instructor_public_key`
- `student_public_keys` (01..24)
- `ssh_source_cidrs` (idealmente tu IP pública/32)
- `class_repo_url` (guía de clase)

## Provisionar

```bash
cd digitalocean-classroom
chmod +x scripts/*.sh
./scripts/check-prereqs.sh
./scripts/apply.sh
```

Salida principal:

- `student_instances.json` con IPs y comando SSH.
- `student_access.csv` generado con `scripts/render-student-sheet.sh`.

```bash
./scripts/render-student-sheet.sh
```

## Destruir al finalizar la actividad

```bash
./scripts/destroy.sh
```

## Red: ¿están en la misma red?

Sí. Todas las VMs se crean en la misma VPC definida por `vpc_cidr`.
Pueden comunicarse por IP privada entre sí.

## Flujo sugerido de la actividad (referencia interna)

- Bloque 1 (40 min): acceso SSH y verificación de conectividad privada.
- Bloque 2 (50 min): deploy de app con Docker y pruebas.
- Bloque 3 (50 min): balanceo + estado compartido + caída de nodo.
- Bloque 4 (40 min): hardening mínimo y evidencia técnica.

El material que ven los estudiantes está en [GUIA_ESTUDIANTE.md](GUIA_ESTUDIANTE.md) (sin referencias a Terraform ni a la infraestructura).
