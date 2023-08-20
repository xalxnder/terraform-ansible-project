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

resource "aws_key_pair" "architech_key" {
  key_name   = "architech_key"
  public_key = file(var.TERRAFORM_KEY)

}

resource "aws_instance" "architech_main" {
  count                  = var.main_instance_count
  instance_type          = var.main_instance_type
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.architech_key.id
  vpc_security_group_ids = [aws_security_group.architech_security.id]
  subnet_id              = aws_subnet.architech_public_subnet[count.index].id
  root_block_device {
    volume_size = var.main_vol_size
  }

  tags = {
    Name = "architech_main-${random_id.architech_node_id[count.index].dec}"
  }

  provisioner "local-exec" {
    command = "printf '\n${self.public_ip}' >> aws_hosts && aws ec2 wait instance-status-ok --instance-ids ${self.id} --region us-east-1"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "sed -i '' '/^[0-9]/d' aws_hosts"
  }
}


resource "null_resource" "grafana_install" {
  depends_on = [aws_instance.architech_main]
  provisioner "local-exec" {
    command = "ansible-playbook -i aws_hosts --key-file /Users/xalexander/.ssh/architech_key playbooks/main_playbook.yml"

  }
}

output "grafana_url" {

  value = { for i in aws_instance.architech_main[*] : i.tags.Name => "${i.public_ip}:3000" }

}


