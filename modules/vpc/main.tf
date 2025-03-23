resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = var.tags
}

resource "aws_subnet" "eks_subnet" {
  for_each = merge([
    for group_name, group in var.subnet_groups : {
      for i, az_index in group.az_indexes : "${group_name}-${i}" => {
        group_name = group_name
        az_index   = az_index
        cidr_block = group.cidr_blocks[i]
        is_private = group.is_private
      }
    }
  ]...)

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = data.aws_availability_zones.available.names[each.value.az_index]

  tags = merge(var.tags, { is_private = each.value.is_private ? true : false })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = var.tags
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.eks_subnet["public-0"].id

  tags = {
    Name = "nat-gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "subnet_rt_association" {
  for_each = {
    for subnet_key, subnet in aws_subnet.eks_subnet : subnet_key => subnet
  }

  subnet_id      = each.value.id
  route_table_id = each.value.tags.is_private == "true" ? aws_route_table.private_rt.id : aws_route_table.public_rt.id
}