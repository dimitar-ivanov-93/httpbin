module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  name    = var.alb_name
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false
  internal                   = false

  security_groups = []

  security_group_ingress_rules = {
    my_ip_443 = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS Traffic"
      cidr_ipv4   = var.public_access_cidr
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  listeners = {
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

      fixed_response = {
        content_type = "text/plain"
        message_body = "Page not found"
        status_code  = "404"
      }
      rules = {
        httpbin = {
          priority = 100
          actions = [{
            type             = "forward"
            target_group_key = "httpbin"
          }]
          conditions = [
            {
              path_pattern = { values = ["/*"] }
            },
            {
              host_header = {
                values = [var.domain_name]
              }
            }
          ]
        }
      }
    }
  }

  target_groups = {
    httpbin = {
      name              = "k8s-httpbin"
      protocol          = "HTTP"
      port              = 80
      target_type       = "ip"
      create_attachment = false
      health_check = {
        path     = "/get"
        matcher  = "200"
        port     = "traffic-port"
        protocol = "HTTP"
      }
    }
  }
}

resource "aws_security_group_rule" "k8s_node_access" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.alb.security_group_id
  security_group_id        = module.eks.node_security_group_id
  description              = "Allow traffic from ${var.alb_name} LB to EKS node group."
}
