terraform {
  required_version = ">= 1.5.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.41"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

locals {
  student_ids = [for i in range(1, var.student_count + 1) : format("%02d", i)]

  students = {
    for sid in local.student_ids : sid => {
      username   = "student${sid}"
      public_key = lookup(var.student_public_keys, sid, "")
    }
  }

  common_tags = ["curso-arqweb", "ha-lab", "clase"]
}

resource "digitalocean_vpc" "classroom" {
  name     = "${var.prefix}-vpc"
  region   = var.region
  ip_range = var.vpc_cidr
}

resource "digitalocean_ssh_key" "instructor" {
  name       = "${var.prefix}-instructor"
  public_key = var.instructor_public_key
}

resource "digitalocean_droplet" "student_vm" {
  for_each = local.students

  name   = "${var.prefix}-st-${each.key}"
  region = var.region
  size   = var.droplet_size
  image  = var.droplet_image

  vpc_uuid = digitalocean_vpc.classroom.id
  ssh_keys = [digitalocean_ssh_key.instructor.fingerprint]

  monitoring = true
  ipv6       = false

  user_data = templatefile("${path.module}/templates/cloud-init.yml.tftpl", {
    username             = each.value.username
    student_public_key   = each.value.public_key
    instructor_public_key = var.instructor_public_key
    class_repo_url       = var.class_repo_url
  })

  tags = concat(local.common_tags, ["student-${each.key}"])
}

resource "digitalocean_droplet" "student_vm_b" {
  for_each = var.enable_second_vm ? local.students : {}

  name   = "${var.prefix}-st-${each.key}-b"
  region = var.region
  size   = var.droplet_size
  image  = var.droplet_image

  vpc_uuid = digitalocean_vpc.classroom.id
  ssh_keys = [digitalocean_ssh_key.instructor.fingerprint]

  monitoring = true
  ipv6       = false

  user_data = templatefile("${path.module}/templates/cloud-init.yml.tftpl", {
    username             = each.value.username
    student_public_key   = each.value.public_key
    instructor_public_key = var.instructor_public_key
    class_repo_url       = var.class_repo_url
  })

  tags = concat(local.common_tags, ["student-${each.key}", "nodo-b"])
}

resource "digitalocean_firewall" "classroom" {
  name = "${var.prefix}-fw"

  # DigitalOcean limita droplet_ids a 10 por firewall.
  # Con tags no hay ese limite, y aplica a todas las VMs con esa tag.
  tags = ["clase"]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = var.ssh_source_cidrs
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [var.vpc_cidr]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
