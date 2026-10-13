output "vm_id" {
  description = "The numeric ID of the VM."
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "The name of the VM."
  value       = proxmox_virtual_environment_vm.this.name
}

output "ipv4_addresses" {
  description = "IPv4 addresses reported by the QEMU guest agent."
  value       = proxmox_virtual_environment_vm.this.ipv4_addresses
}

output "ipv6_addresses" {
  description = "IPv6 addresses reported by the QEMU guest agent."
  value       = proxmox_virtual_environment_vm.this.ipv6_addresses
}

output "mac_addresses" {
  description = "MAC addresses reported for the VM network interfaces."
  value       = proxmox_virtual_environment_vm.this.mac_addresses
}
