locals {
  zones = data.aws_availability_zones.available.names
}
data "aws_availability_zones" "available" {

}

resource "random_id" "random" {
  byte_length = 2
}

resource "aws_vpc" "architech_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "architech_vpc-${random_id.random.dec}"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_internet_gateway" "architech_internet_gateway" {
  vpc_id = aws_vpc.architech_vpc.id

  tags = {
    Name = "architech_gateway-${random_id.random.dec}"
  }

}

resource "aws_route_table" "architech_public_route" {
  vpc_id = aws_vpc.architech_vpc.id

  tags = {
    Name = "architech_public_route"
  }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.architech_public_route.id
  # "0.0.0.0/0" - Anything that is destined for the outside world will hit this route
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.architech_internet_gateway.id

}

resource "aws_default_route_table" "architech_private_route" {
  default_route_table_id = aws_vpc.architech_vpc.default_route_table_id
  tags = {
    Name = "architech_private_route"
  }
}

resource "aws_subnet" "architech_public_subnet" {
  count                   = length(local.zones)
  vpc_id                  = aws_vpc.architech_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = local.zones[count.index]

  tags = {
    Name = "arhitech_public-${count.index + 1}"
  }
}

resource "aws_subnet" "architech_private_subnet" {
  # All private subnets will fall back to the DEFAULT route table
  count                   = length(local.zones)
  vpc_id                  = aws_vpc.architech_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, length(local.zones) + count.index)
  map_public_ip_on_launch = false
  availability_zone       = local.zones[count.index]

  tags = {
    Name = "arhitech_private-${count.index + 1}"
  }
}

resource "aws_route_table_association" "architech_public_association" {
  count          = length(local.zones)
  subnet_id      = aws_subnet.architech_public_subnet[count.index].id
  route_table_id = aws_route_table.architech_public_route.id

}



resource "aws_security_group" "architech_security" {
  name        = "public_security_group"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.architech_vpc.id

}

resource "aws_security_group_rule" "ingress_all" {
  #Traffic coming in
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.MY_IP]
  security_group_id = aws_security_group.architech_security.id

}

resource "aws_security_group_rule" "egress_all" {
  #Traffic going out
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.architech_security.id

}
