provider "kubernetes" {
  host                   = module.eks.endpoint
  cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.id]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.endpoint
    cluster_ca_certificate = base64decode(module.eks.kubeconfig-certificate-authority-data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.id]
    }
  }
}

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0" # or your desired version
    }
    kubernetes = {
        source  = "hashicorp/kubernetes"
        version = "~> 2.36.0" # or your desired version, kubernetes provider is needed.
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.91.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "test-tf-state-matas"
    key    = "eks-main/state"
    encrypt = true
    dynamodb_table = "test-tf-state-matas"
  }
}