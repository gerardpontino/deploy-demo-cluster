resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_role_name

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
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_auto_mode_policies" {
  for_each  = toset(var.cluster_policies)
  policy_arn = each.value
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "node_auto_mode_policies" {
  for_each  = toset(var.node_policies)
  policy_arn = each.value
  role       = aws_iam_role.eks_cluster_role.name
}
