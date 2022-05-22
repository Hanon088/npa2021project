#ELB

resource "aws_lb" "webELB" {
  name = "webELB"
  load_balancer_type = "application"
  internal = false
  subnets = module.vpc.public_subnets
  security_groups = [aws_security_group.ELB-sg.id]

  tags = merge(local.common_tags, {Name = "WebLB"})
}

resource "aws_lb_target_group" "tgp" {
  name = "Tg"
  port = 80
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id

  depends_on = [
      aws_lb.webELB
  ]

  tags = merge(local.common_tags, { Name = "TG"})
}

resource "aws_lb_listener" "lbListener" {
    load_balancer_arn = aws_lb.webELB.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.tgp.arn
    }
  tags = merge(local.common_tags, { Name = "LBlistener"})
}

resource "aws_lb_target_group_attachment" "Serversattach" {
    count = var.instance_count
    target_group_arn = aws_lb_target_group.tgp.arn
    target_id = aws_instance.Servers[count.index].id 
    port = 80
}

resource "aws_lb_target_group_attachment" "Controllerattach" {
    target_group_arn = aws_lb_target_group.tgp.arn
    target_id = aws_instance.Controller.id
    port = 80
}