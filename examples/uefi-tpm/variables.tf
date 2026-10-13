variable "proxmox_endpoint" {
  description = "The Proxmox API endpoint, for example https://pve.example.com:8006/."
  type        = string
}

variable "proxmox_api_token" {
  description = "The Proxmox API token in user@realm!token=secret format."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Whether to skip TLS certificate verification."
  type        = bool
  default     = false
}

variable "node_name" {
  description = "The target Proxmox node name."
  type        = string
}

variable "vm_id" {
  description = "The VM ID."
  type        = number
  default     = 101
}

variable "vm_name" {
  description = "The VM name."
  type        = string
  default     = "uefi-tpm-vm"
}

variable "datastore_id" {
  description = "Datastore used for the VM, EFI, and TPM disks."
  type        = string
  default     = "local-lvm"
}
