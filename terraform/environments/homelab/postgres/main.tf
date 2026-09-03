# terraform/postgres/main.tf
variable "vm_id" {
  default = 1000
}

variable "vm_name" {
  default = "postgres-server"
}

variable "cores" {
  default = 2
}

variable "memory" {
  default = 4096  # 4GB RAM
}

variable "disk_size" {
  default = "50G"
}

resource "proxmox_virtual_environment_vm" "postgres_vm" {
  name        = var.vm_name
  vm_id       = var.vm_id
  node_name   = "proxmox"

  operating_system {
    type = "l26"  # Linux 5.x+
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
    discard      = true
    ssd          = true
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = "AA:BB:CC:DD:EE:01"
  }

  # Utilise ton template Ubuntu 24.04
  clone {
    vm_id       = 9000  # ID de ton template Packer
    full       = true
    retries    = 3
  }

  # Activer QEMU Guest Agent
  agent {
    enabled = true
  }

  # Configuration initiale via cloud-init
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.1.100/24"  # À adapter
        gateway  = "192.168.1.1"
      }
    }

    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
  }
}

resource "proxmox_virtual_environment_file" "cloud_init" {
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
        - ca-certificates
      runcmd:
        - systemctl enable qemu-guest-agent
        - systemctl start qemu-guest-agent
      final_message: "PostgreSQL VM is ready!"
    EOT
    file_name = "postgres-cloud-init.yml"
  }
}

output "postgres_ip" {
  value = proxmox_virtual_environment_vm.postgres_vm.ipv4_addresses[0].address
}
