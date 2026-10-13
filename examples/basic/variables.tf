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
  default     = 100
}

variable "vm_name" {
  description = "The VM and guest hostname."
  type        = string
  default     = "ubuntu-24-04"
}

variable "image_datastore_id" {
  description = "Datastore used for the downloaded cloud image."
  type        = string
  default     = "local"
}

variable "snippet_datastore_id" {
  description = "Datastore with snippets content enabled."
  type        = string
  default     = "local"
}

variable "vm_datastore_id" {
  description = "Datastore used for the VM disk."
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Proxmox network bridge attached to the VM."
  type        = string
  default     = "vmbr0"
}

variable "ssh_public_key" {
  description = "Public SSH key installed for the ubuntu user."
  type        = string
}
