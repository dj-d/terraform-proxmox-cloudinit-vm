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

resource "proxmox_download_file" "ubuntu" {
  content_type = "iso"
  datastore_id = var.image_datastore_id
  node_name    = var.node_name
  url          = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  overwrite    = false
}

resource "proxmox_virtual_environment_file" "user_data" {
  content_type = "snippets"
  datastore_id = var.snippet_datastore_id
  node_name    = var.node_name

  source_raw {
    file_name = "${var.vm_id}-user-data.yaml"
    data      = <<-EOF
      #cloud-config
      hostname: ${var.vm_name}
      timezone: UTC
      users:
        - default
        - name: ubuntu
          groups:
            - sudo
          shell: /bin/bash
          ssh_authorized_keys:
            - ${var.ssh_public_key}
          sudo: ALL=(ALL) NOPASSWD:ALL
      package_update: true
      packages:
        - qemu-guest-agent
      runcmd:
        - systemctl enable --now qemu-guest-agent
    EOF
  }
}

module "vm" {
  source = "../.."

  vm_id     = var.vm_id
  name      = var.vm_name
  node_name = var.node_name

  user_data_file_id = proxmox_virtual_environment_file.user_data.id

  disk = [
    {
      datastore_id = var.vm_datastore_id
      file_id      = proxmox_download_file.ubuntu.id
      interface    = "scsi0"
      size         = 20
      iothread     = true
    }
  ]

  ipv4 = {
    address = "dhcp"
  }

  network_device = {
    bridge   = var.network_bridge
    firewall = true
  }
}
