# DigitalOcean Classroom Lab (24 estudiantes)

Automatizacion para aprovisionar 24 VMs de estudiantes en una VPC compartida de DigitalOcean, con acceso SSH y red privada entre VMs.

## Que crea

- 1 VPC compartida para toda la clase.
- 24 droplets pequenos (1 por estudiante, por defecto).
- 1 firewall con:
  - SSH desde CIDRs autorizadas.
  - Trafico interno TCP entre VMs de la VPC.
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

## Configuracion

1. Copia ejemplo de variables:

```bash
cd digitalocean-classroom/terraform
cp terraform.tfvars.example terraform.tfvars
```

2. Completa en terraform.tfvars:
- instructor_public_key
- student_public_keys (01..24)
- ssh_source_cidrs (idealmente tu IP publica/32)
- class_repo_url (guia de clase)

## Provisionar

```bash
cd digitalocean-classroom
chmod +x scripts/*.sh
./scripts/check-prereqs.sh
./scripts/apply.sh
```

Salida principal:

- student_instances.json con IPs y comando SSH.
- student_access.csv generado con scripts/render-student-sheet.sh.

```bash
./scripts/render-student-sheet.sh
```

## Destruir al final de clase

```bash
./scripts/destroy.sh
```

## Red: estan en la misma red?

Si. Todas las VMs se crean en la misma VPC definida por vpc_cidr.
Pueden comunicarse por IP privada entre si.

## Flujo sugerido de clase (3 horas)

- Bloque 1 (40 min): acceso SSH y verificacion de conectividad privada.
- Bloque 2 (50 min): deploy de app con Docker y pruebas.
- Bloque 3 (50 min): balanceo + estado compartido + caida de nodo.
- Bloque 4 (40 min): hardening minimo y evidencia tecnica.

Ver detalle en docs/GUIA_CLASE_3H.md.
