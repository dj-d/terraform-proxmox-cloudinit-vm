resource "proxmox_virtual_environment_vm" "this" {
  vm_id     = var.vm_id
  name      = var.name
  node_name = var.node_name

  stop_on_destroy = true

  agent {
    enabled = true
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ipv4_address
      }
    }

    user_data_file_id = var.user_data_file_id == null ? proxmox_virtual_environment_file.base[0].id : var.user_data_file_id
    meta_data_file_id = var.meta_data_file_id == null ? null : var.meta_data_file_id
  }

  cpu {
    cores   = var.cpu_cores
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = var.memory.dedicated
    floating  = var.memory.floating
  }

  disk {
    interface    = "scsi0"
    datastore_id = var.disk.datastore_id
    size         = var.disk.size
    file_id      = var.disk.file_id
  }

  network_device {
    bridge = var.network_device.bridge
  }

  tags = var.tags
}