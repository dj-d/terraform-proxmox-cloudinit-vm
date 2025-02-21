variable "vm_id" {
  description = "The ID of the VM."
  type        = number
}

variable "name" {
  description = "The name of the VM."
  type        = string
}

variable "node_name" {
  description = "The name of the node."
  type        = string
  default     = "reiner"
}

variable "ipv4_address" {
  description = "The IPv4 address of the VM."
  type        = string
  default     = "dhcp"
}

variable "user_data_file_id" {
  description = "The ID of the user data file."
  type        = string
  default     = null
}

variable "use_base_user_data" {
  description = "Use the base user data."
  type        = bool
  default     = true
}

variable "meta_data_file_id" {
  description = "The ID of the meta data file."
  type        = string
  default     = null
}

variable "cpu_config" {
  description = "The number of CPU cores."
  type = object({
    cores = number
    type  = optional(string, "host")
  })
  default = {
    cores = 1
    type  = "host"
  }
}

variable "memory" {
  description = "The amount of memory in MB."
  type = object({
    dedicated = number
    floating  = number
  })
  default = {
    dedicated = 2048
    floating  = 2048
  }
}

variable "disk" {
  description = "The disk configuration."
  type = list(object({
    interface         = optional(string, "scsi0")
    size              = number
    file_id           = optional(string)
    datastore_id      = string
    path_in_datastore = optional(string)
    file_format       = optional(string)
    iothread          = optional(bool, false)
  }))
}

variable "network_device" {
  description = "The network device configuration."
  type = object({
    bridge = string
  })
  default = {
    bridge = "vmbr0"
  }
}

variable "tags" {
  description = "The tags of the VM."
  type        = list(string)
  default     = []
}

variable "username" {
  description = "The username."
  type        = string
  default     = "ubuntu"
}

variable "hostname" {
  description = "The hostname."
  type        = string
  default     = "ubuntu"
}

variable "create_ssh_key" {
  description = "The SSH key."
  type        = string
  default     = true
}

variable "tpm_conf" {
  description = "The TPM state."
  type = object({
    datastore_id = string
    version      = string
  })
  default = null
}

variable "efi_disk_conf" {
  description = "The EFI disk configuration."
  type = object({
    datastore_id      = string
    file_format       = optional(string, "raw")
    pre_enrolled_keys = optional(bool, true)
    type              = optional(string, "4m")
  })
  default = null
}

variable "bios" {
  description = "The BIOS configuration."
  type        = string
  default     = "seabios"
}

variable "keyboard_layout" {
  description = "The keyboard layout."
  type        = string
  default     = "en-us"
}

variable "operating_system" {
  description = "The operating system."
  type = object({
    type = string
  })
  default = {
    type = "l26"
  }
}

variable "scsi_hardware" {
  description = "The SCSI hardware."
  type        = string
  default     = "virtio-scsi-pci"
}

variable "started" {
  description = "Start the VM."
  type        = bool
  default     = true
}

variable "init" {
  description = "The init script."
  type        = bool
  default     = true
}