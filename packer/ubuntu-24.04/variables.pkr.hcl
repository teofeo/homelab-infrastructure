variable "proxmox_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "proxmox_username" {
  type        = string
  description = "Proxmox API username"
}

variable "proxmox_token" {
  type        = string
  description = "Proxmox API token"
  sensitive   = true
}

variable "proxmox_node" {
  type        = string
  description = "Proxmox node where the template is built"
}

variable "proxmox_storage" {
  type        = string
  description = "Proxmox storage pool for the VM disk"
}

variable "proxmox_iso_storage" {
  type        = string
  description = "Proxmox storage pool containing the ISO"
}

variable "vm_id" {
  type        = number
  description = "VM ID of the resulting Proxmox template"
  default     = 9000
}

variable "vm_name" {
  type        = string
  description = "Temporary VM name"
  default     = "ubuntu-server-24-04"
}

variable "template_name" {
  type        = string
  description = "Final Proxmox template name"
  default     = "ubuntu-server-24-04"
}

variable "ubuntu_iso" {
  type        = string
  description = "Ubuntu ISO filename in the Proxmox ISO storage"
}

variable "ubuntu_iso_checksum" {
  type        = string
  description = "Ubuntu ISO SHA256 checksum"
}

variable "ssh_username" {
  type        = string
  description = "Initial Ubuntu user"
  default     = "ubuntu"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key installed in the template"
}

variable "ssh_private_key_file" {
  type        = string
  description = "Path to the SSH private key file"
}


variable "ssh_password_hash" {
  type        = string
  description = "SHA-512 password hash for the initial Ubuntu user"
  sensitive   = true
}

variable "timezone" {
  type        = string
  description = "Timezone configured in Ubuntu"
  default     = "Europe/Paris"
}
