provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"

      # Needs awscli
      args = ["eks", "get-token", "--cluster-name", var.cluster_name]
    }
  }
}
