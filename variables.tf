##providers.tf variables
variable "aws_region" {
  description = "Primary AWS region for EKS cluster"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_region_ecr" {
  description = "AWS region for ECR Public (default us-east-1)"
  type        = string
  default     = "us-east-1"
}

##eks.tf Variables
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

#aws-auth.tf variables

variable "github_role_arn" {
  description = "IAM Role ARN for GitHub Actions to access the EKS cluster"
  type        = string
}

variable "github_username" {
  description = "Usernames for GitHub Actions in aws-auth config map"
  type        = string
  default     = "github-actions"
}

variable "github_groups" {
  description = "Kubernetes groups for GitHub Actions role"
  type        = list(string)
  default     = ["system:masters"]
}

##IAM.TF Variables

variable "eks_role_name" {
  description = "Name of the IAM Role for EKS cluster and nodes"
  type        = string
  default     = "eksclusterrole"
}

variable "cluster_policies" {
  description = "Policies attached to the EKS cluster role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  ]
}

variable "node_policies" {
  description = "Policies attached to the EKS node role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}
