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

# 1. Primary AWS Provider
provider "aws" {
  region = "ap-southeast-1"
}

# 2. AWS Alias for ECR Public (Mandatory for the token)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# 3. Fetch the Token using the Alias
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.us_east_1
}

# 4. Auth for the Cluster
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.main.name
}

# 5. SINGLE Helm Provider (Merging auth and registry)
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }

  # This part fixes the 403 Forbidden error
  registry {
    url      = "oci://public.ecr.aws"
    username = data.aws_ecrpublic_authorization_token.token.user_name
    password = data.aws_ecrpublic_authorization_token.token.password
  }
}

# 6. Kubernetes Provider (Optional, for other k8s resources)
provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}