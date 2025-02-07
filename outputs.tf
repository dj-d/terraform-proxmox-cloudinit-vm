output "instance_ip" {
  value = proxmox_virtual_environment_vm.this.*.initialization.0.ip_config.0.ipv4.0.address
}