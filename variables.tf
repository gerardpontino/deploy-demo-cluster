variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
  default     = "gerard-dev-cluster"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.34"
}

variable "node_pools" {
  description = "List of node pools for EKS Auto Mode"
  type        = list(string)
  default     = ["general-purpose", "system"]
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
  default     = ""  # optional; can be dynamically fetched
}

variable "subnet_count" {
  description = "Number of subnets to use from the VPC"
  type        = number
  default     = 2
}

variable "github_role_arn" {
  description = "IAM Role ARN for GitHub Actions to access the EKS cluster"
  type        = string
}

variable "github_username" {
  description = "Username for GitHub Actions in aws-auth config map"
  type        = string
  default     = "github-actions"
}

variable "github_groups" {
  description = "Kubernetes groups for GitHub Actions role"
  type        = list(string)
  default     = ["system:masters"]
}
