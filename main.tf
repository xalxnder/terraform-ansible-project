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
