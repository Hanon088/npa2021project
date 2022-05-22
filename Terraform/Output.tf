# output

output "main_instance" {
  value = aws_instance.Servers[0].id
}

output "aws_lb_public_dns" {
  value = aws_lb.webELB.dns_name
}