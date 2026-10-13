terraform {
  required_version = ">= 1.3.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.111.0, < 1.0.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}

module "vm" {
  source = "../.."

  vm_id                  = var.vm_id
  name                   = var.vm_name
  node_name              = var.node_name
  bios                   = "ovmf"
  initialization_enabled = false
  started                = false

  disk = [
    {
      datastore_id = var.datastore_id
      interface    = "scsi0"
      size         = 32
      iothread     = true
    }
  ]

  efi_disk_conf = {
    datastore_id      = var.datastore_id
    pre_enrolled_keys = true
  }

  tpm_conf = {
    datastore_id = var.datastore_id
    version      = "v2.0"
  }
}
