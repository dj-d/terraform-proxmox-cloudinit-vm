# Changelog

All notable changes to this project are documented in this file. Releases
follow [Semantic Versioning](https://semver.org/) and are generated from
[Conventional Commits](https://www.conventionalcommits.org/).

## [2.0.0](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/compare/v1.1.0...v2.0.0) (2026-10-13)


### ⚠ BREAKING CHANGES

* stabilize the module v2 interface

### Features

* expose VM on-boot setting ([3c75592](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/commit/3c75592937f627a28c95b13f2679f6f9a1554078))
* **network:** support Proxmox NIC firewall flag ([e74ba47](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/commit/e74ba477dc629124ea22cfe6c8a9d08d1e81d8b8))
* removed base.yml ([c45a1f6](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/commit/c45a1f648b274bd22019296692edcc6a278cbcd9))
* removed snippet.tf ([f85e7f5](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/commit/f85e7f501ec7ad5fd0cf657d34521208fa009ba4))
* stabilize the module v2 interface ([6c5467f](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/commit/6c5467f427e0589e75af78798039a170dcc63509))
* updated ipv4 initialization ([9111251](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/commit/9111251b2c47fd5e4772db96139f1d704264d54f))
* updated version of providers ([66cde84](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/commit/66cde841d8b1b0717e1883800b92cbcb280dc772))
* validate module inputs and document outputs ([53459f0](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/commit/53459f0858e40d9e804e75cfd39c6c222857740c))

## [1.1.0](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/compare/v1.0.2...v1.1.0) (2025-02-21)

### Features

- add a basic usage example;
- add VM address outputs;
- support EFI disks and TPM state;
- update module documentation.

## [1.0.2](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/compare/v1.0.1...v1.0.2) (2025-02-07)

### Bug Fixes

- remove obsolete changelog files.

## [1.0.1](https://github.com/dj-d/terraform-proxmox-cloudinit-vm/releases/tag/v1.0.1) (2025-02-07)

Initial public release.
