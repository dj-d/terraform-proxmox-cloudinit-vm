# Terraform Proxmox Cloud-Init VM

[![Quality](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/actions/workflows/quality.yml/badge.svg)](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/actions/workflows/quality.yml)
[![Terraform Registry](https://img.shields.io/badge/Terraform%20Registry-dj--d%2Fcloudinit--vm%2Fproxmox-844FBA?logo=terraform)](https://registry.terraform.io/modules/dj-d/cloudinit-vm/proxmox/latest)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)

Terraform module for provisioning a Proxmox VE virtual machine with optional
Cloud-Init customization, multiple disks, UEFI, and TPM support.

## Features

- Cloud-Init DHCP or static IPv4 configuration.
- Custom Cloud-Init user-data and metadata snippets.
- Multiple disks with configurable interfaces and datastores.
- SeaBIOS or OVMF/UEFI boot.
- Optional EFI disk and TPM state.
- Configurable QEMU guest agent, NIC firewall, startup, and destroy behavior.

## Requirements

- Terraform `>= 1.3.0`.
- `bpg/proxmox` provider `>= 0.111.0, < 1.0.0`.
- A Proxmox VE API token configured in the root module.
- SSH access from the provider when importing an image that requires it.
- The `snippets` content type enabled when using custom Cloud-Init files.

The module does not configure the Proxmox provider and does not create or store
SSH private keys. Provider credentials and Cloud-Init files remain the
responsibility of the calling root module.

## Usage

```hcl
module "ubuntu_vm" {
  source  = "dj-d/cloudinit-vm/proxmox"
  version = "2.0.0"

  vm_id     = 100
  name      = "ubuntu-24-04"
  node_name = "pve"

  user_data_file_id = proxmox_virtual_environment_file.user_data.id

  disk = [
    {
      datastore_id = "local-lvm"
      file_id       = proxmox_download_file.ubuntu.id
      interface     = "scsi0"
      size          = 20
      iothread      = true
    }
  ]

  ipv4 = {
    address = "10.0.0.100/24"
    gateway = "10.0.0.1"
  }

  network_device = {
    bridge   = "vmbr0"
    firewall = true
  }
}
```

See [`examples/basic`](examples/basic) for a complete Cloud-Init deployment and
[`examples/uefi-tpm`](examples/uefi-tpm) for a UEFI/TPM configuration.

## Important behavior

- Custom user-data overrides parts of the native Proxmox Cloud-Init data. Set
  the hostname explicitly in custom user-data when required.
- `ipv4_addresses` and `ipv6_addresses` depend on the QEMU guest agent being
  installed, enabled, and running inside the guest.
- `stop_on_destroy` defaults to `true` to allow an orderly VM shutdown.
- `on_boot` and `started` default to `true`.
- Provider credentials must not be committed to the repository.

## Upgrading

Version 2 contains breaking input and behavior changes. See
[`docs/UPGRADING-2.0.md`](docs/UPGRADING-2.0.md) before upgrading from version
1.x.

## Examples

Examples use this repository as a local module source so they can be validated
in CI. Replace `source = "../.."` with the Registry source and a version when
copying an example into another repository.

## Module reference

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >= 0.111.0, < 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >= 0.111.0, < 1.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_vm.this](https://registry.terraform.io/providers/bpg/proxmox/latest/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_enabled"></a> [agent\_enabled](#input\_agent\_enabled) | Whether to enable the QEMU guest agent integration. | `bool` | `true` | no |
| <a name="input_bios"></a> [bios](#input\_bios) | The BIOS configuration. | `string` | `"seabios"` | no |
| <a name="input_cpu_config"></a> [cpu\_config](#input\_cpu\_config) | The VM CPU configuration. | <pre>object({<br/>    cores = number<br/>    type  = optional(string, "host")<br/>  })</pre> | <pre>{<br/>  "cores": 1,<br/>  "type": "host"<br/>}</pre> | no |
| <a name="input_disk"></a> [disk](#input\_disk) | One or more VM disk configurations. | <pre>list(object({<br/>    interface         = optional(string, "scsi0")<br/>    size              = number<br/>    file_id           = optional(string)<br/>    datastore_id      = string<br/>    path_in_datastore = optional(string)<br/>    file_format       = optional(string)<br/>    iothread          = optional(bool, false)<br/>  }))</pre> | n/a | yes |
| <a name="input_efi_disk_conf"></a> [efi\_disk\_conf](#input\_efi\_disk\_conf) | The EFI disk configuration. | <pre>object({<br/>    datastore_id      = string<br/>    file_format       = optional(string, "raw")<br/>    pre_enrolled_keys = optional(bool, true)<br/>    type              = optional(string, "4m")<br/>  })</pre> | `null` | no |
| <a name="input_initialization_enabled"></a> [initialization\_enabled](#input\_initialization\_enabled) | Whether to configure the Proxmox Cloud-Init initialization block. | `bool` | `true` | no |
| <a name="input_ipv4"></a> [ipv4](#input\_ipv4) | The Cloud-Init IPv4 configuration. Use 'dhcp' or a CIDR address. | <pre>object({<br/>    address = string<br/>    gateway = optional(string, null)<br/>  })</pre> | <pre>{<br/>  "address": "dhcp"<br/>}</pre> | no |
| <a name="input_keyboard_layout"></a> [keyboard\_layout](#input\_keyboard\_layout) | The keyboard layout. | `string` | `"en-us"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory in MB. | <pre>object({<br/>    dedicated = number<br/>    floating  = number<br/>  })</pre> | <pre>{<br/>  "dedicated": 2048,<br/>  "floating": 2048<br/>}</pre> | no |
| <a name="input_meta_data_file_id"></a> [meta\_data\_file\_id](#input\_meta\_data\_file\_id) | The ID of the meta data file. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the VM. | `string` | n/a | yes |
| <a name="input_network_device"></a> [network\_device](#input\_network\_device) | The network device configuration. | <pre>object({<br/>    bridge   = string<br/>    firewall = optional(bool, false)<br/>  })</pre> | <pre>{<br/>  "bridge": "vmbr0",<br/>  "firewall": false<br/>}</pre> | no |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | The name of the Proxmox node on which to create the VM. | `string` | n/a | yes |
| <a name="input_on_boot"></a> [on\_boot](#input\_on\_boot) | Whether to start the VM when the Proxmox node boots. | `bool` | `true` | no |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | The operating system. | <pre>object({<br/>    type = string<br/>  })</pre> | <pre>{<br/>  "type": "l26"<br/>}</pre> | no |
| <a name="input_scsi_hardware"></a> [scsi\_hardware](#input\_scsi\_hardware) | The SCSI hardware. | `string` | `"virtio-scsi-pci"` | no |
| <a name="input_started"></a> [started](#input\_started) | Whether the VM should be running. | `bool` | `true` | no |
| <a name="input_stop_on_destroy"></a> [stop\_on\_destroy](#input\_stop\_on\_destroy) | Whether to stop the VM before destroying it. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags of the VM. | `list(string)` | `[]` | no |
| <a name="input_tpm_conf"></a> [tpm\_conf](#input\_tpm\_conf) | Optional TPM state configuration. | <pre>object({<br/>    datastore_id = string<br/>    version      = string<br/>  })</pre> | `null` | no |
| <a name="input_user_data_file_id"></a> [user\_data\_file\_id](#input\_user\_data\_file\_id) | Optional Proxmox file ID containing Cloud-Init user data. | `string` | `null` | no |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | The ID of the VM. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ipv4_addresses"></a> [ipv4\_addresses](#output\_ipv4\_addresses) | IPv4 addresses reported by the QEMU guest agent. |
| <a name="output_ipv6_addresses"></a> [ipv6\_addresses](#output\_ipv6\_addresses) | IPv6 addresses reported by the QEMU guest agent. |
| <a name="output_mac_addresses"></a> [mac\_addresses](#output\_mac\_addresses) | MAC addresses reported for the VM network interfaces. |
| <a name="output_name"></a> [name](#output\_name) | The name of the VM. |
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | The numeric ID of the VM. |
<!-- END_TF_DOCS -->

## License

Licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE).
