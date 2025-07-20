data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_lb_target_group" "this" {
  name = var.target_group_name
}