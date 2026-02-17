terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"  # This ONLY allows 2.x versions
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35.0"  # This ONLY allows 2.x versions
    }
  }
}

# Primary AWS Provider
provider "aws" {
  region = var.aws_region
}

# AWS Alias for ECR Public
provider "aws" {
  alias  = "us_east_1"
  region = var.aws_region_ecr
}

# 3. Fetch the Token using the Alias
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.us_east_1
}

# 4. Auth for the Cluster
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.main.name
}


# 6. Kubernetes Provider (Optional, for other k8s resources)
provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
