resource "aws_eks_access_entry" "github_actions" {
  cluster_name      = aws_eks_cluster.main.name
  principal_arn     = trimspace(var.github_role_arn) # Cleans up any hidden spaces
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "github_admin" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = trimspace(var.github_role_arn)
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  
  # Crucial: Association must wait for the Entry to exist
  depends_on = [aws_eks_access_entry.github_actions]

  access_scope {
    type = "cluster"
  }
}