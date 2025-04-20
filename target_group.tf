# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group.html

# 


resource "aws_lb_target_group" "web_tg" {
  name     = "assign2-web-tg"
  port     = 8050
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "assign2-web-tg"
  }
}
