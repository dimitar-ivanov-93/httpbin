variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "httpbin"
}

variable "target_group_name" {
  description = "The name of the target group."
  type        = string
  default     = "k8s-httpbin"
}

variable "region" {
  description = "The AWS region in which the EKS cluster is deployed."
  type        = string
  default     = "eu-central-1"
}