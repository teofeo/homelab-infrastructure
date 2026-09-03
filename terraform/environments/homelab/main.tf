resource "proxmox_virtual_environment_vm" "monitoring" {
  name      = var.vm_name
  node_name = var.proxmox_node

  clone {
    vm_id = var.template_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }
}
