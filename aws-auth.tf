resource "kubernetes_config_map" "aws_auth_github" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = "arn:aws:iam::541495491938:role/GitHubEKSCluster"
        username = "github-actions"
        groups   = ["system:masters"]
      }
    ])
  }

  depends_on = [aws_eks_cluster.main]
}