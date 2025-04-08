variable "hostname" {}
variable "username" {}
variable "password" {}

terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.22.9"
    }
  }
  required_version = ">= 0.13"
}

provider "bigip" {
  address  = var.hostname
  username = var.username
  password = var.password
  port     = 8443
}

locals {
  virtual_addresses = ["10.2.1.7"]
  virtual_port      = 80
  members = [
    { address = "10.2.1.4", port = 80 },
    { address = "10.2.1.5", port = 80 },
    { address = "10.2.1.6", port = 80 }
  ]
  tenant = "sample_03"
}

resource "local_file" "as3" {
  filename = "rendered_as3_declaration.json"
  content = templatefile("simple-app.tftpl", {
    virtual_addresses = local.virtual_addresses,
    virtual_port      = local.virtual_port
    members           = local.members
    tenant            = local.tenant
  })
}

resource "local_file" "per-app_as3" {
  filename = "rendered_per-app_as3_declaration.json"
  content = templatefile("simple-per-app.tftpl", {
    virtual_addresses = local.virtual_addresses,
    virtual_port      = local.virtual_port
    members           = local.members
  })
}

# resource "bigip_as3" "sample-app" {
#   as3_json = local_file.as3.content
# }

resource "bigip_as3" "simple-per-app" {
  as3_json    = local_file.per-app_as3.content
  tenant_name = local.tenant
}
