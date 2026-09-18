output "vpc_name" {
  description = "Nombre de la VPC"
  value       = digitalocean_vpc.classroom.name
}

output "student_instances" {
  description = "Datos de acceso por estudiante"
  value = {
    for sid, d in digitalocean_droplet.student_vm : sid => {
      droplet_name = d.name
      username     = "student${sid}"
      public_ip    = d.ipv4_address
      private_ip   = d.ipv4_address_private
      ssh_command  = "ssh student${sid}@${d.ipv4_address}"
    }
  }
}

output "student_instances_b" {
  description = "Datos de acceso por estudiante - segunda VM (nodo B), si esta habilitada"
  value = {
    for sid, d in digitalocean_droplet.student_vm_b : sid => {
      droplet_name = d.name
      username     = "student${sid}"
      public_ip    = d.ipv4_address
      private_ip   = d.ipv4_address_private
      ssh_command  = "ssh student${sid}@${d.ipv4_address}"
    }
  }
}
