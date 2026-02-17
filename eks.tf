# Fetch the VPC
data "aws_vpc" "default" {
  id      = var.vpc_id != "" ? var.vpc_id : null
  default = var.vpc_id == "" ? true : false
}

# Fetch subnets for the VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = data.aws_iam_role.eks_cluster_role.arn  # <-- updated
  version  = var.kubernetes_version

  bootstrap_self_managed_addons = false

  compute_config {
    enabled       = true
    node_pools    = var.node_pools
    node_role_arn = data.aws_iam_role.eks_cluster_role.arn  # <-- updated
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids             = slice(data.aws_subnets.default.ids, 0, var.subnet_count)
    endpoint_public_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_auto_mode_policies,
    aws_iam_role_policy_attachment.node_auto_mode_policies
  ]
}