module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs = local.azs

  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 2, k)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 3, k + 6)]

  public_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k + 8)]
  #   database_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 10)] ## if needed for an rds db


  create_database_subnet_group = false
  enable_nat_gateway           = true
  single_nat_gateway           = true

  private_route_table_tags = {
    "type" = "private"
  }

  public_route_table_tags = {
    "type" = "public"
  }

  intra_route_table_tags = {
    "type" = "intra"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}