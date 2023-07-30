resource "aws_vpc" "tech_threads_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tech_threads_vpc"
  }

}
