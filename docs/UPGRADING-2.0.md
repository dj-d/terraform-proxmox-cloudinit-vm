# Upgrading from v1 to v2

Version 2 removes the module-managed Cloud-Init snippet and SSH key generation,
updates the provider compatibility range, and makes the module API independent
from the original author's Proxmox environment.

Review a saved Terraform plan before applying the upgrade. Provider upgrades
can expose drift or schema changes unrelated to this module.

## Required changes

### Set `node_name`

The environment-specific `reiner` default was removed:

```hcl
node_name = "pve"
```

### Replace `ipv4_address`

Before:

```hcl
ipv4_address = "10.0.0.100/24"
```

After:

```hcl
ipv4 = {
  address = "10.0.0.100/24"
  gateway = "10.0.0.1"
}
```

For DHCP:

```hcl
ipv4 = {
  address = "dhcp"
}
```

### Rename `init`

Before:

```hcl
init = false
```

After:

```hcl
initialization_enabled = false
```

### Manage Cloud-Init user-data outside the module

The following v1 inputs were removed:

- `use_base_user_data`
- `username`
- `hostname`
- `create_ssh_key`

Create a `proxmox_virtual_environment_file` in the root module and pass its ID:

```hcl
user_data_file_id = proxmox_virtual_environment_file.user_data.id
```

The input is optional in v2. The module no longer creates private keys or
stores private key material in Terraform state.

### Use a disk list

`disk` is a list and supports multiple disks:

```hcl
disk = [
  {
    datastore_id = "local-lvm"
    file_id       = proxmox_download_file.ubuntu.id
    interface     = "scsi0"
    size          = 20
  }
]
```

### Review lifecycle settings

Version 2 exposes the following settings:

```hcl
agent_enabled  = true
on_boot        = true
started        = true
stop_on_destroy = true
```

## Provider upgrade

Version 2 supports `bpg/proxmox >= 0.111.0, < 1.0.0`; version 1.1.0 used
`0.70.1`. Read the provider upgrade guide and review all intermediate breaking
changes before applying the new version.
