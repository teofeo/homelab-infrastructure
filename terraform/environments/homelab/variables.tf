variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node"
  type        = string
}

variable "template_id" {
  description = "Ubuntu golden image template ID"
  type        = number
  default     = 9000
}

variable "vm_id" {
  description = "Monitoring VM ID"
  type        = number
  default     = 100
}

variable "vm_name" {
  description = "Monitoring VM name"
  type        = string
  default     = "monitoring"
}

variable "datastore_id" {
  description = "Proxmox datastore"
  type        = string
  default     = "local-lvm"
}
