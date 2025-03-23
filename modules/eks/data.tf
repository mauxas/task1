data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.main.id
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}