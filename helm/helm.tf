resource "helm_release" "httpbin" {
  name      = "httpbin"
  namespace = "httpbin"
  chart     = "./charts/httpbin"

  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true

  values = [
    file("${path.module}/charts/httpbin/values.yaml")
  ]

  set = [
    {
      name  = "targetGroupBinding.targetGroupARN"
      value = data.aws_lb_target_group.this.arn
    }
  ]
}