### Networking ###
# One VPC 
# Three Public Subnets
# Three Private Subnets
# Internet Gateway
# Route Table

output vpc_server {
  value       = aws_vpc.wordpress-vpc.id
}

output pub_sub_server {
  value       = aws_subnet.pub-subnet["pub_sub1"].id
}

output priv_sub_server {
  value       = [aws_subnet.priv-subnet["priv_sub1"].id, aws_subnet.priv-subnet["priv_sub2"].id, aws_subnet.priv-subnet["priv_sub3"].id]
}

resource "aws_vpc" "wordpress-vpc" {
  cidr_block       = var.vpc_cidr_block 
  tags = {
    Name = var.vpc_tag
  } 
}

resource "aws_subnet" "pub-subnet" {
  vpc_id     = aws_vpc.wordpress-vpc.id
  for_each = var.pubsubnets
  cidr_block = each.value
  availability_zone = var.azs_pub[each.key]
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "priv-subnet" {
  vpc_id     = aws_vpc.wordpress-vpc.id
  for_each = var.privsubnets
  cidr_block = each.value
  availability_zone = var.azs_priv[each.key] 
  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress-vpc.id
  tags = {
    Name = var.igw_tag
  }
}

resource "aws_route_table" "wordpress_rt" {
  vpc_id = aws_vpc.wordpress-vpc.id
  tags = {
    Name = var.rt_tag
  }

  route {
    cidr_block = var.cidr_rt
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }
}

resource "aws_route_table_association" "wordpress_rt_as_pubsubnet" {
  for_each = var.pubsubnets
  subnet_id      = aws_subnet.pub-subnet[each.key].id
  route_table_id = aws_route_table.wordpress_rt.id
}