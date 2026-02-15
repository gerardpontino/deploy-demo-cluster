# The 1st Role: eksclusterrole (Used for both Cluster and Node per your request)
resource "aws_iam_role" "eks_cluster_role" {
  name = "eksclusterrole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole", "sts:TagSession"]
        Effect = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" } # Allow EC2 to use this for nodes
      }
    ]
  })
}

# Policies required for EKS Auto Mode Cluster
resource "aws_iam_role_policy_attachment" "cluster_auto_mode_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",      # Required for Auto Mode
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy", # Required for Auto Mode
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",# Required for Auto Mode
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"    # Required for Auto Mode
  ])
  policy_arn = each.value
  role       = aws_iam_role.eks_cluster_role.name
}

# Permissions required for the nodes to join and function
resource "aws_iam_role_policy_attachment" "node_auto_mode_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  policy_arn = each.value
  role       = aws_iam_role.eks_cluster_role.name
}