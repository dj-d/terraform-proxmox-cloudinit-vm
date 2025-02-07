locals {
  content_type = "snippets"
  data_store = "local"
}

resource "tls_private_key" "this" {
  count = var.create_ssh_key ? 1 : 0

  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  count = var.create_ssh_key ? 1 : 0

  filename = "${var.vm_id}.pem"
  content = tls_private_key.this[0].private_key_pem
  directory_permission = "0400"
  file_permission = "0400"

  depends_on = [
    tls_private_key.this
  ]
}

data "template_file" "base" {
  count = var.use_base_user_data ? 1 : 0

  template = file("${path.module}/user_data/base.yml")
  vars = {
    hostname = var.hostname
    username = var.username
    # password = # TODO: Add random password generation
    ssh_public_key = var.create_ssh_key ? trimspace(tls_private_key.this[0].public_key_openssh) : ""
  }

  depends_on = [
    tls_private_key.this
  ]
}

resource "proxmox_virtual_environment_file" "base" {
  count = var.use_base_user_data ? 1 : 0

  content_type = local.content_type
  datastore_id = local.data_store
  node_name    = var.node_name

  source_raw {
    file_name = "${var.vm_id}-base.yaml"
    data      = data.template_file.base[0].rendered
  }

  depends_on = [
    data.template_file.base
  ]
}