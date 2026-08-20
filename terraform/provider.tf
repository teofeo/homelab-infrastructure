terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox" # Fournisseur moderne pour Proxmox
      version = "0.68.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://proxmox.homelab.teo-franoux.fr"
  api_token = "root@pam!terraform=a82c0c1c-9197-477d-832c-458791b2b82b"
  insecure  = true
}
