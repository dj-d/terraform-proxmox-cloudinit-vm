# terraform-proxmox-cloudinit-vm

Terraform module that uses the BPG/Proxmox provider to create and configure virtual machines (VMs) on a Proxmox VE
environment, leveraging Cloud-Init for initial configuration automation.

## Usage

Basic usage of this module is as follows:

```hcl
module "ubuntu_docker" {
  source = "dj-d/cloudinit-vm/proxmox"

  name  = "ubuntu-24-04-lts"
  vm_id = 100
  disk = {
    datastore_id = "local"
    size         = 20
  }
}
```

## Requirements

| Name                                                                   | Version |
|------------------------------------------------------------------------|---------|
| <a name="requirement_local"></a> [local](#requirement\_local)          | 2.5.2   |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox)    | 0.70.1  |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0   |
| <a name="requirement_tls"></a> [tls](#requirement\_tls)                | 4.0.6   |

## Providers

| Name                                                             | Version |
|------------------------------------------------------------------|---------|
| <a name="provider_local"></a> [local](#provider\_local)          | 2.5.2   |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox)    | 0.70.1  |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0   |
| <a name="provider_tls"></a> [tls](#provider\_tls)                | 4.0.6   |

## Modules

No modules.

## Resources

| Name                                                                                                                                        | Type        |
|---------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/2.5.2/docs/resources/file)                                 | resource    |
| [proxmox_virtual_environment_file.base](https://registry.terraform.io/providers/bpg/proxmox/0.70.1/docs/resources/virtual_environment_file) | resource    |
| [proxmox_virtual_environment_vm.this](https://registry.terraform.io/providers/bpg/proxmox/0.70.1/docs/resources/virtual_environment_vm)     | resource    |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/4.0.6/docs/resources/private_key)                              | resource    |
| [template_file.base](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file)                               | data source |

## Inputs

| Name                                                                                        | Description                       | Type                                                                                                                   | Default                                                            | Required |
|---------------------------------------------------------------------------------------------|-----------------------------------|------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------|:--------:|
| <a name="input_cpu_cores"></a> [cpu\_cores](#input\_cpu\_cores)                             | The number of CPU cores.          | `number`                                                                                                               | `2`                                                                |    no    |
| <a name="input_create_ssh_key"></a> [create\_ssh\_key](#input\_create\_ssh\_key)            | The SSH key.                      | `string`                                                                                                               | `true`                                                             |    no    |
| <a name="input_disk"></a> [disk](#input\_disk)                                              | The disk configuration.           | <pre>object({<br/>    size         = number<br/>    file_id      = string<br/>    datastore_id = string<br/>  })</pre> | n/a                                                                |   yes    |
| <a name="input_hostname"></a> [hostname](#input\_hostname)                                  | The hostname.                     | `string`                                                                                                               | `"ubuntu"`                                                         |    no    |
| <a name="input_ipv4_address"></a> [ipv4\_address](#input\_ipv4\_address)                    | The IPv4 address of the VM.       | `string`                                                                                                               | `"dhcp"`                                                           |    no    |
| <a name="input_memory"></a> [memory](#input\_memory)                                        | The amount of memory in MB.       | <pre>object({<br/>    dedicated = number<br/>    floating  = number<br/>  })</pre>                                     | <pre>{<br/>  "dedicated": 2048,<br/>  "floating": 2048<br/>}</pre> |    no    |
| <a name="input_meta_data_file_id"></a> [meta\_data\_file\_id](#input\_meta\_data\_file\_id) | The ID of the meta data file.     | `string`                                                                                                               | `null`                                                             |    no    |
| <a name="input_name"></a> [name](#input\_name)                                              | The name of the VM.               | `string`                                                                                                               | n/a                                                                |   yes    |
| <a name="input_network_device"></a> [network\_device](#input\_network\_device)              | The network device configuration. | <pre>object({<br/>    bridge = string<br/>  })</pre>                                                                   | <pre>{<br/>  "bridge": "vmbr0"<br/>}</pre>                         |    no    |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name)                             | The name of the node.             | `string`                                                                                                               | `"reiner"`                                                         |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                              | The tags of the VM.               | `list(string)`                                                                                                         | `[]`                                                               |    no    |
| <a name="input_user_data_file_id"></a> [user\_data\_file\_id](#input\_user\_data\_file\_id) | The ID of the user data file.     | `string`                                                                                                               | `null`                                                             |    no    |
| <a name="input_username"></a> [username](#input\_username)                                  | The username.                     | `string`                                                                                                               | `"ubuntu"`                                                         |    no    |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id)                                         | The ID of the VM.                 | `number`                                                                                                               | n/a                                                                |   yes    |

## Outputs

No outputs.