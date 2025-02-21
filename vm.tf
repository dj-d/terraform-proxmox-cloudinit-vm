resource "proxmox_virtual_environment_vm" "this" {
  vm_id     = var.vm_id
  name      = var.name
  node_name = var.node_name

  bios            = var.bios
  keyboard_layout = var.keyboard_layout

  scsi_hardware = var.scsi_hardware

  started = var.started

  stop_on_destroy = true

  agent {
    enabled = true
  }

  dynamic "initialization" {
    for_each = var.init ? [var.init] : []
    content {
      ip_config {
        ipv4 {
          address = var.ipv4_address
        }
      }

      user_data_file_id = var.user_data_file_id == null ? proxmox_virtual_environment_file.base[0].id : var.user_data_file_id
      meta_data_file_id = var.meta_data_file_id == null ? null : var.meta_data_file_id
    }
  }

  cpu {
    cores   = var.cpu_config.cores
    sockets = 1
    type    = var.cpu_config.type
    flags   = []
  }

  memory {
    dedicated = var.memory.dedicated
    floating  = var.memory.floating
  }

  dynamic "disk" {
    for_each = var.disk

    content {
      interface         = disk.value.interface
      datastore_id      = disk.value.datastore_id
      size              = disk.value.size
      file_id           = disk.value.file_id
      path_in_datastore = disk.value.path_in_datastore
      file_format       = disk.value.file_format
      iothread          = disk.value.iothread
    }
  }

  network_device {
    bridge = var.network_device.bridge
  }

  dynamic "tpm_state" {
    for_each = var.tpm_conf == null ? [] : [var.tpm_conf]

    content {
      datastore_id = tpm_state.value.datastore_id
      version      = tpm_state.value.version
    }
  }

  dynamic "efi_disk" {
    for_each = var.efi_disk_conf == null ? [] : [var.efi_disk_conf]
    content {
      datastore_id      = efi_disk.value.datastore_id
      file_format       = efi_disk.value.file_format
      type              = efi_disk.value.type
      pre_enrolled_keys = efi_disk.value.pre_enrolled_keys
    }
  }

  dynamic "operating_system" {
    for_each = var.operating_system == null ? [] : [var.operating_system]
    content {
      type = operating_system.value.type
    }
  }

  tags = var.tags
}