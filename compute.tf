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

resource "aws_key_pair" "main_key" {
  key_name   = "main_key"
  public_key = file(var.TERRAFORM_KEY)

}

resource "aws_instance" "architech_main" {
  count                  = var.main_instance_count
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.main_key.id
  vpc_security_group_ids = [aws_security_group.architech_security.id]
  subnet_id              = aws_subnet.architech_public_subnet[count.index].id
  user_data              = templatefile("./main-user-data.tpl", { new_hostname = "architech_main-${random_id.architech_node_id[count.index].dec}" })
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "architech_main-${random_id.architech_node_id[count.index].dec}"
  }

  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> aws_hosts"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sed -i '/^[0-9]/d' aws_hosts"
  }
}



