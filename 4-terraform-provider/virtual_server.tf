
locals {
  poolmembers = ["10.2.1.4", "10.2.1.5", "10.2.1.6"]
}

resource "bigip_partition" "partition" {
  name = "Terraform"
}

resource "bigip_ltm_pool" "pool" {
  name                   = "/Terraform/terraform_pool"
  load_balancing_mode    = "round-robin"
  minimum_active_members = 1

  monitors = ["http"]

  depends_on = [bigip_partition.partition]
}

resource "bigip_ltm_virtual_server" "virtual-server" {
  name        = "/Terraform/terraform_vs_http"
  destination = "10.2.1.7"
  port        = 8090
  pool        = bigip_ltm_pool.pool.name

  depends_on = [bigip_partition.partition, bigip_ltm_pool.pool]
}

resource "bigip_ltm_node" "nodes" {
  count   = length(local.poolmembers)
  address = local.poolmembers[count.index]
  name    = "/${bigip_partition.partition.name}/node-${count.index}"
}


resource "bigip_ltm_pool_attachment" "pool_attachments" {
  count = length(bigip_ltm_node.nodes)
  pool  = bigip_ltm_pool.pool.name
  node  = "${bigip_ltm_node.nodes[count.index].name}:80"

  depends_on = [bigip_partition.partition, bigip_ltm_pool.pool]
}

