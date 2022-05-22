# data 
data "aws_availability_zones" "available" {}

# Network vpc and subnet

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "MainVPC"
  cidr = var.network_address_space

  azs             = slice(data.aws_availability_zones.available.names,0, (var.az_count))
  public_subnets = [for t in range(var.subnet_count) : cidrsubnet(var.network_address_space, 8, t)]
  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(local.common_tags, { Name = "VPC"})
}