module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.37.2"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  enable_cluster_creator_admin_permissions = false
  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs     = [var.public_access_cidr]

  node_security_group_additional_rules = {}

  access_entries = {
    personal_access = {
      principal_arn = var.personal_access_principal_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_groups = {
    amd = {
      ami_type       = var.node_group_ami_type
      instance_types = var.node_group_instance_types

      min_size     = var.node_group_min
      max_size     = var.node_group_max
      desired_size = var.node_group_desired
    }
  }

  node_security_group_tags = local.tags
  tags                     = local.tags
}
