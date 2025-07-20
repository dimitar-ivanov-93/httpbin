locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    created_by_terraform = "true"
    environment          = var.environment
    repository           = var.repository
  }
}