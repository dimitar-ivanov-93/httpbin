module "aws_lb_controller_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "AWSLoadBalancerControllerIAMPolicy-httpbin"
  path        = "/"
  description = "Policy for AWS Load Balancer Controller"

  policy = file("${path.module}/aws_controller_policy.json")
}

module "aws_lb_controller_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "aws-load-balancer-controller"
  role_policy_arns = {
    policy = module.aws_lb_controller_policy.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "lb_controller_service_account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.aws_lb_controller_role.iam_role_arn
    }
  }

  depends_on = [module.eks]
}