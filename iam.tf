# Reference the existing IAM role instead of creating it
data "aws_iam_role" "eks_cluster_role" {
  name = var.eks_role_name  # e.g., "GitHubEKSCluster"
}

# Policies required for EKS Auto Mode Cluster
resource "aws_iam_role_policy_attachment" "cluster_auto_mode_policies" {
  for_each   = toset(var.cluster_policies)
  policy_arn = each.value
  role       = data.aws_iam_role.eks_cluster_role.name
}

# Permissions required for the nodes to join and function
resource "aws_iam_role_policy_attachment" "node_auto_mode_policies" {
  for_each   = toset(var.node_policies)
  policy_arn = each.value
  role       = data.aws_iam_role.eks_cluster_role.name
}