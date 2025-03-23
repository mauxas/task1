module "eks" {
  source = "../eks"
  tags   = var.tags
}

module "helm" {
  source     = "../helm"
  depends_on = [module.eks]
  helm_releases = {
    "receiver" = {
      name        = "receiver"
      chart_path  = "../../helm/receiver"
      values_file = "configs/receiver.yaml" # example values file name.
    }
    "transmitter" = {
      name        = "transmitter"
      chart_path  = "../../helm/transmitter"
      values_file = "configs/transmitter.yaml" # example values file name.
    }
  }
  helm_releases_tests = {
    "transmitter-same-ns-diff-name-test" = {
      name        = "transmitter-same-ns-diff-name-test"
      chart_path  = "../../helm/transmitter"
      values_file = "configs/transmitter-same-ns-diff-name-test.yaml" # example values file name.
    }
    "transmitter-diff-ns-same-name-test" = {
      name        = "transmitter-diff-ns-same-name-test"
      chart_path  = "../../helm/transmitter"
      values_file = "configs/transmitter-diff-ns-same-name-test.yaml" # example values file name.
    }
  }
}

