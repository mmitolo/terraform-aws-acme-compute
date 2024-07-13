locals {
  public_subnet_cidrs  = length(var.public_subnets) == 0 ? null_resource.auto_public_subnet_cidrs.*.triggers.cidr_block : var.public_subnets
  private_subnet_cidrs = length(var.private_subnets) == 0 ? null_resource.auto_private_subnet_cidrs.*.triggers.cidr_block : var.private_subnets
}

resource "null_resource" "auto_public_subnet_cidrs" {
  count = length(var.azs)

  triggers = {
    cidr_block = cidrsubnet(cidrsubnet(var.cidr, 2, 3), length(var.azs), count.index)
  }
}

resource "null_resource" "auto_private_subnet_cidrs" {
  count = length(var.azs)

  triggers = {
    cidr_block = cidrsubnet(var.cidr, 2, count.index)
  }
}
