# Basic Cloud-Init VM

This example downloads an Ubuntu 24.04 cloud image, uploads a custom Cloud-Init
user-data snippet, and creates a VM using DHCP.

The target image storage must accept ISO content and the snippet storage must
have the `snippets` content type enabled. Depending on the image and provider
configuration, SSH access to the Proxmox node may also be required for import.

Supply provider credentials through variables or your preferred secret
management mechanism. Do not commit them in a `.tfvars` file.
