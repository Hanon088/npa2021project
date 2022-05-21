# Data

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Instance

resource "aws_instance" "Servers" {
  count = var.instance_count
  ami = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http_https.id]
  subnet_id = module.vpc.public_subnets[(count.index)]
  connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file(var.private_key_path)
  }
  provisioner "remote-exec" {
      inline = [
          "sudo echo 'remote ok'",
          "sudo yum install python -y",
          "sudo pip install ansible",
          "echo 'testAnsible ansible_user=ec2-user ansible_host = ${aws_instance.Servers[0].public_ip} ansible_ssh_private_key_file = vockey.pem '| sudo tee host"
      ]
  }
  provisioner "file" {
    source = "../install_app.yml"
    destination = "install_app.yml"
  }
  provisioner "file" {
    source = "../ansible.cfg"
    destination = "ansible.cfg"
  }
  provisioner "file" {
    source = "vockey.pem"
    destination = "vockey.pem"
  }
  provisioner "file" {
    source = "../servers"
    destination = "servers"
  }
  
}