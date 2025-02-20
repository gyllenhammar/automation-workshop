variable "hostname" {}
variable "username" {}
variable "password" {}

terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.22.7"
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

resource "bigip_as3" "sample-app" {
  as3_json = file("simple-app.json")
}

resource "bigip_as3" "simple-per-app" {
  as3_json    = file("simple-per-app.json")
  tenant_name = "Sample_02"
}
