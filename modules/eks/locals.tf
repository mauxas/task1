locals {
  policy_attachments = {
    "AmazonEKSClusterPolicy"             = { role = aws_iam_role.eks.name, policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" },
    "AmazonEKSVPCResourceController"     = { role = aws_iam_role.eks.name, policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController" },
    "AmazonEC2ContainerRegistryReadOnly" = { role = aws_iam_role.node_group.name, policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" },
    "AmazonEKS_CNI_Policy"               = { role = aws_iam_role.node_group.name, policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" },
    "AmazonEKSWorkerNodePolicy"          = { role = aws_iam_role.node_group.name, policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" },
    "AmazonEC2ContainerRegistryPullOnly" = { role = aws_iam_role.node_group.name, policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly" },
  }
  cluster_security_group_rules = {
    "egress_internet" = {
      description = "Allow cluster egress access to the Internet."
      protocol    = "-1"
      cidr_blocks = [module.vpc.cidr_block]
      from_port   = 0
      to_port     = 0
      type        = "egress"
    },
    "ingress_https_worker" = {
      description              = "Allow pods to communicate with the EKS cluster API."
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.cluster.id
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
    },
    "ingress_api_nodes_webhook" = {
      description              = "Cluster API to nodes ports/protocols"
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.cluster.id
      from_port                = 15012
      to_port                  = 15012
      type                     = "ingress"
    }
  }
}