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

# resource "bigip_as3" "sample-app" {
#   as3_json = file("../1-as3/simple-app.json")

# }

# resource "bigip_as3" "simple-per-app1" {
#   as3_json    = file("../1-as3/simple-per-app1.json")
#   tenant_name = "Sample_02"

# }
# resource "bigip_as3" "simple-per-app2" {
#   as3_json    = file("../1-as3/simple-per-app2.json")
#   tenant_name = "Sample_02"

# }
# resource "bigip_as3" "simple-per-app3" {
#   as3_json    = file("../1-as3/simple-per-app3.json")
#   tenant_name = "Sample_02"

# }


