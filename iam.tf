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
        Principal = { Service = "ec2.amazonaws.com" } # Allow EC2 to use this for nodes
      }
    ]
  })
}
