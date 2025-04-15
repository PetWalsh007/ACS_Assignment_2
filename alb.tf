
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# Inital we will use HTTP - this is to be updated later with HTTPS 

resource "aws_lb" "web_alb" {
  name               = "assign2-web-alb"
  internal           = false
  load_balancer_type = "application"
    subnets            = [
    aws_subnet.webserver_subnet_az1.id,
    aws_subnet.webserver_subnet_az2.id
  ]
  security_groups    = [aws_security_group.web_sg.id]

  tags = {
    Name = "assign2-web-alb"
  }
}

resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
