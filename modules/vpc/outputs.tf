output "id" {
  value = aws_vpc.main.id
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "subnet_ids" {
  value = [for subnet_key, subnet in aws_subnet.eks_subnet : subnet.id if subnet.tags.is_private == "true"]
}
