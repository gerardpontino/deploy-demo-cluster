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
