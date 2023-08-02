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
  default_route_table_id = aws_vpc.architech_vpc.id

  tags = {
    Name = "architech_private_route"
  }
}

resource "aws_subnet" "architech_public_subnet" {
  count                   = length(var.public_cidrs)
  vpc_id                  = aws_vpc.architech_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.zones[count.index]

  tags = {
    Name = "arhitech_public-${count.index + 1}"
  }
}

resource "aws_subnet" "architech_private_subnet" {
  count                   = length(var.private_cidrs)
  vpc_id                  = aws_vpc.architech_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = local.zones[count.index]

  tags = {
    Name = "arhitech_private-${count.index + 1}"
  }
}

