resource "random_id" "architech_node_id" {
  byte_length = 2
  count       = var.main_instance_count

}

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

}

resource "aws_instance" "architech_main" {
  count                  = var.main_instance_count
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.server_ami.id
  vpc_security_group_ids = [aws_security_group.architech_security.id]
  subnet_id              = aws_subnet.architech_public_subnet[count.index].id
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "architech_main-${random_id.architech_node_id[count.index].dec}"

  }
}



