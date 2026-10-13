mock_provider "proxmox" {}

run "default_configuration" {
  command = plan

  variables {
    vm_id     = 9000
    name      = "test-vm"
    node_name = "pve"
    disk = [
      {
        datastore_id = "local-lvm"
        size         = 20
      }
    ]
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.vm_id == 9000
    error_message = "The VM ID was not propagated to the resource."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.started
    error_message = "The VM should be started by default."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.on_boot
    error_message = "The VM should start on node boot by default."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.stop_on_destroy
    error_message = "The VM should stop before destroy by default."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.agent[0].enabled
    error_message = "The QEMU guest agent integration should be enabled by default."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.network_device[0].bridge == "vmbr0"
    error_message = "The default network bridge should be vmbr0."
  }

  assert {
    condition     = !proxmox_virtual_environment_vm.this.network_device[0].firewall
    error_message = "The NIC firewall should be disabled by default."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.initialization[0].ip_config[0].ipv4[0].address == "dhcp"
    error_message = "Cloud-Init should use DHCP by default."
  }
}

run "static_ipv4_with_uefi_and_tpm" {
  command = plan

  variables {
    vm_id     = 9001
    name      = "secure-vm"
    node_name = "pve"
    bios      = "ovmf"
    started   = false
    on_boot   = false
    ipv4 = {
      address = "10.0.0.100/24"
      gateway = "10.0.0.1"
    }
    network_device = {
      bridge   = "vmbr1"
      firewall = true
    }
    disk = [
      {
        datastore_id = "local-lvm"
        interface    = "scsi0"
        size         = 32
      }
    ]
    efi_disk_conf = {
      datastore_id = "local-lvm"
    }
    tpm_conf = {
      datastore_id = "local-lvm"
      version      = "v2.0"
    }
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.bios == "ovmf"
    error_message = "The OVMF BIOS setting was not propagated."
  }

  assert {
    condition     = !proxmox_virtual_environment_vm.this.started && !proxmox_virtual_environment_vm.this.on_boot
    error_message = "The VM should remain stopped and disabled on boot."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.initialization[0].ip_config[0].ipv4[0].gateway == "10.0.0.1"
    error_message = "The static IPv4 gateway was not propagated."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.network_device[0].firewall
    error_message = "The NIC firewall setting was not propagated."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.efi_disk[0].pre_enrolled_keys
    error_message = "EFI pre-enrolled keys should default to enabled."
  }

  assert {
    condition     = proxmox_virtual_environment_vm.this.tpm_state[0].version == "v2.0"
    error_message = "The TPM version was not propagated."
  }
}

run "initialization_disabled" {
  command = plan

  variables {
    vm_id                  = 9002
    name                   = "uninitialized-vm"
    node_name              = "pve"
    initialization_enabled = false
    disk = [
      {
        datastore_id = "local-lvm"
        size         = 16
      }
    ]
  }

  assert {
    condition     = length(proxmox_virtual_environment_vm.this.initialization) == 0
    error_message = "The initialization block should be omitted when disabled."
  }
}

run "reject_invalid_vm_id" {
  command = plan

  variables {
    vm_id     = 99
    name      = "invalid-vm"
    node_name = "pve"
    disk = [
      {
        datastore_id = "local-lvm"
        size         = 16
      }
    ]
  }

  expect_failures = [var.vm_id]
}

run "reject_duplicate_disk_interfaces" {
  command = plan

  variables {
    vm_id     = 9003
    name      = "invalid-disks"
    node_name = "pve"
    disk = [
      {
        datastore_id = "local-lvm"
        interface    = "scsi0"
        size         = 16
      },
      {
        datastore_id = "local-lvm"
        interface    = "scsi0"
        size         = 16
      }
    ]
  }

  expect_failures = [var.disk]
}

run "reject_gateway_with_dhcp" {
  command = plan

  variables {
    vm_id     = 9004
    name      = "invalid-network"
    node_name = "pve"
    ipv4 = {
      address = "dhcp"
      gateway = "10.0.0.1"
    }
    disk = [
      {
        datastore_id = "local-lvm"
        size         = 16
      }
    ]
  }

  expect_failures = [var.ipv4]
}
