output "vm_id" {
  description = "The created VM ID."
  value       = module.vm.vm_id
}

output "ipv4_addresses" {
  description = "IPv4 addresses reported by the QEMU guest agent."
  value       = module.vm.ipv4_addresses
}
