resource "kubernetes_config_map" "aws_auth_github" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = var.github_role_arn
        username = var.github_username
        groups   = var.github_groups
      }
    ])
  }

  depends_on = [aws_eks_cluster.main]
}
