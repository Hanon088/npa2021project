# output

output "main_instance" {
  value = aws_instance.Servers[0].id
}

output "aws_lb_public_dns" {
  value = aws_lb.webELB.dns_name
}

output "test" {
  value = format("echo '%s' | sudo tee hosts", join("",formatlist("testAnsible ansible_user=ec2-user ansible_host=${aws_instance.Controller.private_ip} ansible_ssh_private_key_file=vockey.pem \n%s", [for i in range(var.instance_count) : "testAnsible${i} ansible_user=ec2-user ansible_host=${aws_instance.Servers[i].public_ip} ansible_ssh_private_key_file=vockey.pem \n"])))

}