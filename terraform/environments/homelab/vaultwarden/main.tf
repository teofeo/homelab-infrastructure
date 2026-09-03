# terraform/vaultwarden/main.tf
variable "vm_id" {
  default = 1001
}

variable "vm_name" {
  default = "vaultwarden"
}

variable "cores" {
  default = 1
}

variable "memory" {
  default = 1024  # 1GB RAM suffit
}

variable "disk_size" {
  default = "20G"
}

variable "postgres_ip" {
  description = "IP de la VM PostgreSQL"
}

resource "proxmox_virtual_environment_vm" "vaultwarden_vm" {
  name        = var.vm_name
  vm_id       = var.vm_id
  node_name   = "proxmox"

  operating_system {
    type = "l26"
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = "local-lvm"
    size         = var.disk_size
    interface    = "scsi0"
    iothread     = true
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = "AA:BB:CC:DD:EE:02"
  }

  clone {
    vm_id       = 9000  # Ton template Ubuntu
    full       = true
  }

  agent {
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.101/24"  # À adapter
        gateway  = "192.168.1.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.vaultwarden_cloud_init.id
  }
}

resource "proxmox_virtual_environment_file" "vaultwarden_cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = "proxmox"

  source_raw {
    data = <<-EOT
      #cloud-config
      package_update: true
      package_upgrade: true
      packages:
        - qemu-guest-agent
        - curl
        - docker.io
        - ca-certificates
      runcmd:
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
        - usermod -aG docker ubuntu
      final_message: "Vaultwarden VM is ready for Docker!"
    EOT
    file_name = "vaultwarden-cloud-init.yml"
  }
}

output "vaultwarden_ip" {
  value = proxmox_virtual_environment_vm.vaultwarden_vm.ipv4_addresses[0].address
}