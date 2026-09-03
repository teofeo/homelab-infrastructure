output "monitoring_vm_id" {
  description = "Monitoring VM ID"
  value       = proxmox_virtual_environment_vm.monitoring.vm_id
}

output "monitoring_ipv4" {
  description = "Monitoring VM IPv4 address"
  value       = proxmox_virtual_environment_vm.monitoring.ipv4_addresses[1][0]
}
