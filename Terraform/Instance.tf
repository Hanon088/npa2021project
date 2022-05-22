# Data

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
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
resource "aws_instance" "Controller" {
  ami = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http_https.id]
  subnet_id = module.vpc.public_subnets[0]
  tags = merge(local.common_tags, { Name = "Controller"})
  connection {
      type = "ssh"
      host = self.public_ip
      user = "ec2-user"
      private_key = file(var.private_key_path)
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
    provisioner "remote-exec" {
      inline = [
          format("echo '%s' | sudo tee hosts", join("",formatlist("Controller ansible_user=ec2-user ansible_host=${aws_instance.Controller.private_ip} ansible_ssh_private_key_file=vockey.pem \n%s", [for i in range(var.instance_count) : "Servers-${i} ansible_user=ec2-user ansible_host=${aws_instance.Servers[i].public_ip} ansible_ssh_private_key_file=vockey.pem \n"]))),
          "sudo yum install python -y",
          "sudo chmod 600 vockey.pem",
          "sudo python3 -m pip install ansible",
          "ansible-playbook install_app.yml",
          
      ]
  }
}

resource "aws_instance" "Servers" {
  count = var.instance_count
  ami = data.aws_ami.aws-linux.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_http_https.id]
  subnet_id = module.vpc.public_subnets[(count.index % 2 == 0 ? 1 : 0)]
  tags = merge(local.common_tags, { Name = "Server-${count.index}"})
}