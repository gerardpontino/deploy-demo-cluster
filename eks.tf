data "aws_vpc" "default" {
  id = var.vpc_id != "" ? var.vpc_id : null
  default = var.vpc_id == "" ? true : false
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.kubernetes_version

  bootstrap_self_managed_addons = false

  compute_config {
    enabled       = true
    node_pools    = var.node_pools
    node_role_arn = aws_iam_role.eks_cluster_role.arn
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

  depends_on = [aws_iam_role_policy_attachment.cluster_auto_mode_policies]
}
