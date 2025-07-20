variable "domain_name" {
  description = "Primary domain name for the application"
  type        = string
}

variable "primary_domain_hosted_zone_id" {
  description = "The Route53 hosted zone ID for the primary domain."
  type        = string
}

variable "environment" {
  description = "The environment in which the infrastructure is deployed (e.g., dev, staging, prod)."
  type        = string
  default     = "sandbox"
}

variable "vpc_name" {
  description = "The name of the VPC for the observability cluster."
  type        = string
  default     = "test-vpc-httpbin"
}

variable "vpc_cidr" {
  description = "The CIDR for the observability cluster VPC."
  type        = string
  default     = "10.1.0.0/22"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "httpbin"
}

variable "cluster_version" {
  description = "The version of the EKS cluster."
  type        = string
  default     = "1.33"
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS cluster endpoint is publicly accessible."
  type        = bool
  default     = false
}

variable "public_access_cidr" {
  description = "CIDR that can access the EKS cluster endpoint as well as ALB."
  type        = string
}

variable "alb_name" {
  description = "The name of the Application Load Balancer."
  type        = string
  default     = "httpbin-alb"
}

variable "personal_access_principal_arn" {
  description = "The ARN of the principal with personal access to the EKS cluster."
  type        = string
}

variable "region" {
  description = "The region in which Loki will be deployed."
  type        = string
  default     = "eu-central-1"
}

variable "node_group_min" {
  description = "The minimum nodes the node group can drop to."
  type        = number
  default     = 2
}

variable "node_group_max" {
  description = "The maximum nodes the node group can provision."
  type        = number
  default     = 3
}

variable "node_group_desired" {
  description = "The desired amount of nodes the node group maintains."
  type        = number
  default     = 2
}

variable "node_group_ami_type" {
  description = "The AMI type needs to match with the instance types."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "node_group_instance_types" {
  description = "A list of instance types the node group can use."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "repository" {
  description = "The repository where the Loki Docker image is stored."
  type        = string
  default     = "https://github.com/dimitar-ivanov-93/httpbin"
}
