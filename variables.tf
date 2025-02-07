variable "vm_id" {
  description = "The ID of the VM."
  type = number
}

variable "name" {
  description = "The name of the VM."
  type = string
}

variable "node_name" {
  description = "The name of the node."
  type = string
  default = "reiner"
}

variable "ipv4_address" {
  description = "The IPv4 address of the VM."
  type = string
  default = "dhcp"
}

variable "user_data_file_id" {
  description = "The ID of the user data file."
  type = string
  default = null
}

variable "use_base_user_data" {
  description = "Use the base user data."
  type = bool
  default = true
}

variable "meta_data_file_id" {
  description = "The ID of the meta data file."
  type = string
  default = null
}

variable "cpu_cores" {
  description = "The number of CPU cores."
  type = number
  default = 2
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
  type = object({
    size         = number
    file_id      = string
    datastore_id = string
  })
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
  type = list(string)
  default = []
}

variable "username" {
  description = "The username."
  type = string
  default = "ubuntu"
}

variable "hostname" {
  description = "The hostname."
  type = string
  default = "ubuntu"
}

variable "create_ssh_key" {
  description = "The SSH key."
  type = string
  default = true
}