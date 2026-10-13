variable "vm_id" {
  description = "The ID of the VM."
  type        = number

  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 999999999 && floor(var.vm_id) == var.vm_id
    error_message = "vm_id must be an integer between 100 and 999999999."
  }
}

variable "name" {
  description = "The name of the VM."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}

variable "node_name" {
  description = "The name of the Proxmox node on which to create the VM."
  type        = string

  validation {
    condition     = length(trimspace(var.node_name)) > 0
    error_message = "node_name must not be empty."
  }
}

variable "ipv4" {
  description = "The Cloud-Init IPv4 configuration. Use 'dhcp' or a CIDR address."
  type = object({
    address = string
    gateway = optional(string, null)
  })
  default = {
    address : "dhcp"
  }

  validation {
    condition     = var.ipv4.address == "dhcp" || can(cidrnetmask(var.ipv4.address))
    error_message = "ipv4.address must be 'dhcp' or a valid IPv4 CIDR address."
  }

  validation {
    condition     = var.ipv4.gateway == null ? true : can(cidrnetmask("${var.ipv4.gateway}/32"))
    error_message = "ipv4.gateway must be null or a valid IPv4 address without a prefix length."
  }

  validation {
    condition     = var.ipv4.address == "dhcp" ? var.ipv4.gateway == null : true
    error_message = "ipv4.gateway must be null when ipv4.address is 'dhcp'."
  }
}

variable "user_data_file_id" {
  description = "Optional Proxmox file ID containing Cloud-Init user data."
  type        = string
  default     = null
}

variable "meta_data_file_id" {
  description = "The ID of the meta data file."
  type        = string
  default     = null
}

variable "cpu_config" {
  description = "The VM CPU configuration."
  type = object({
    cores = number
    type  = optional(string, "host")
  })
  default = {
    cores = 1
    type  = "host"
  }


  validation {
    condition     = var.cpu_config.cores >= 1 && floor(var.cpu_config.cores) == var.cpu_config.cores
    error_message = "cpu_config.cores must be a positive integer."
  }

  validation {
    condition     = length(trimspace(var.cpu_config.type)) > 0
    error_message = "cpu_config.type must not be empty."
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

  validation {
    condition = (
      var.memory.dedicated > 0 &&
      var.memory.floating >= 0 &&
      var.memory.floating <= var.memory.dedicated
    )
    error_message = "memory.dedicated must be positive and memory.floating must be between 0 and memory.dedicated."
  }
}

variable "disk" {
  description = "One or more VM disk configurations."
  type = list(object({
    interface         = optional(string, "scsi0")
    size              = number
    file_id           = optional(string)
    datastore_id      = string
    path_in_datastore = optional(string)
    file_format       = optional(string)
    iothread          = optional(bool, false)
  }))

  validation {
    condition     = length(var.disk) > 0
    error_message = "disk must contain at least one disk configuration."
  }

  validation {
    condition = alltrue([
      for disk in var.disk :
      disk.size > 0 &&
      length(trimspace(disk.interface)) > 0 &&
      length(trimspace(disk.datastore_id)) > 0
    ])
    error_message = "Each disk must have a positive size, a non-empty interface, and a non-empty datastore_id."
  }

  validation {
    condition     = length(distinct([for disk in var.disk : disk.interface])) == length(var.disk)
    error_message = "Each disk must use a unique interface."
  }

  validation {
    condition = alltrue([
      for disk in var.disk :
      !(disk.file_id != null && disk.path_in_datastore != null)
    ])
    error_message = "A disk cannot set both file_id and path_in_datastore."
  }
}

variable "network_device" {
  description = "The network device configuration."
  type = object({
    bridge   = string
    firewall = optional(bool, false)
  })
  default = {
    bridge   = "vmbr0"
    firewall = false
  }

  validation {
    condition     = length(trimspace(var.network_device.bridge)) > 0
    error_message = "network_device.bridge must not be empty."
  }
}

variable "tags" {
  description = "The tags of the VM."
  type        = list(string)
  default     = []
}

variable "tpm_conf" {
  description = "Optional TPM state configuration."
  type = object({
    datastore_id = string
    version      = string
  })
  default = null

  validation {
    condition = var.tpm_conf == null ? true : (
      length(trimspace(var.tpm_conf.datastore_id)) > 0 &&
      contains(["v1.2", "v2.0"], var.tpm_conf.version)
    )
    error_message = "tpm_conf.datastore_id must not be empty and version must be 'v1.2' or 'v2.0'."
  }
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

  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "bios must be either 'seabios' or 'ovmf'."
  }
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

  validation {
    condition = contains([
      "lsi",
      "lsi53c810",
      "megasas",
      "pvscsi",
      "virtio-scsi-pci",
      "virtio-scsi-single",
    ], var.scsi_hardware)
    error_message = "scsi_hardware must be a supported Proxmox SCSI controller type."
  }
}

variable "started" {
  description = "Whether the VM should be running."
  type        = bool
  default     = true
}

variable "on_boot" {
  description = "Whether to start the VM when the Proxmox node boots."
  type        = bool
  default     = true
}

variable "initialization_enabled" {
  description = "Whether to configure the Proxmox Cloud-Init initialization block."
  type        = bool
  default     = true
}

variable "agent_enabled" {
  description = "Whether to enable the QEMU guest agent integration."
  type        = bool
  default     = true
}

variable "stop_on_destroy" {
  description = "Whether to stop the VM before destroying it."
  type        = bool
  default     = true
}
