variable "do_token" {
  description = "Token de API de DigitalOcean"
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "Prefijo para nombrar recursos"
  type        = string
  default     = "arqweb-lab"
}

variable "region" {
  description = "Region de DigitalOcean"
  type        = string
  default     = "nyc1"
}

variable "student_count" {
  description = "Cantidad de VMs de estudiantes"
  type        = number
  default     = 24
}

variable "droplet_size" {
  description = "Tamanio de droplet"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "droplet_image" {
  description = "Imagen base del droplet"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC compartida"
  type        = string
  default     = "10.30.0.0/16"
}

variable "ssh_source_cidrs" {
  description = "CIDRs permitidas para SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instructor_public_key" {
  description = "Clave publica SSH del docente"
  type        = string
}

variable "student_public_keys" {
  description = "Mapa de claves publicas por estudiante. Clave: 01..24"
  type        = map(string)
  default     = {}
}

variable "class_repo_url" {
  description = "Repositorio con la guia de laboratorio para clonar en cada VM"
  type        = string
  default     = ""
}

variable "enable_second_vm" {
  description = "Si es true, crea una segunda VM (nodo B) por estudiante para pruebas de HA entre maquinas reales"
  type        = bool
  default     = false
}
