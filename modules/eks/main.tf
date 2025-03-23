module "vpc" {
  source = "../vpc"
  tags   = var.tags
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids         = module.vpc.subnet_ids
    security_group_ids = [aws_security_group.cluster.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.policy_attachments["AmazonEKSClusterPolicy"],
    aws_iam_role_policy_attachment.policy_attachments["AmazonEKSVPCResourceController"],
  ]
}

resource "aws_iam_openid_connect_provider" "default" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

resource "aws_eks_node_group" "node_groups" {
  for_each = var.node_groups

  node_group_name = each.value.node_group_name
  cluster_name    = aws_eks_cluster.main.name
  node_role_arn   = aws_iam_role.node_group.arn
  subnet_ids      = module.vpc.subnet_ids
  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.maximum_size
    min_size     = each.value.minimum_size
  }

  disk_size      = each.value.disk_size
  instance_types = each.value.instance_types
  tags           = each.value.tags

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config[0].desired_size]
  }

  depends_on = [
    aws_iam_role_policy_attachment.policy_attachments["AmazonEKSWorkerNodePolicy"],
    aws_iam_role_policy_attachment.policy_attachments["AmazonEKS_CNI_Policy"],
    aws_iam_role_policy_attachment.policy_attachments["AmazonEC2ContainerRegistryReadOnly"],
  ]
}


resource "aws_security_group" "cluster" {

  name_prefix = var.cluster_name
  description = "EKS cluster security group."
  vpc_id      = module.vpc.id

  tags = var.tags
}

resource "aws_security_group_rule" "cluster_rules" {
  for_each                 = local.cluster_security_group_rules
  description              = each.value.description
  protocol                 = each.value.protocol
  security_group_id        = aws_security_group.cluster.id
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)              # Handle optional cidr_blocks
  source_security_group_id = lookup(each.value, "source_security_group_id", null) # Handle optional source_security_group_id
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  type                     = each.value.type
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks" {
  name               = "${var.cluster_name}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  for_each   = local.policy_attachments
  policy_arn = each.value.policy_arn
  role       = each.value.role
}

resource "aws_iam_role" "node_group" {
  name               = "${var.cluster_name}-eks-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.id
  addon_name   = "vpc-cni"

  configuration_values = jsonencode({
    enableNetworkPolicy = "true"
    nodeAgent = {
      healthProbeBindAddr = "8163"
      metricsBindAddr     = "8162"
    }
  })
}