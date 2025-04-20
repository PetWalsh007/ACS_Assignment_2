resource "aws_autoscaling_group" "web_asg" {
  name                      = "assign2-web-asg"
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 2
    vpc_zone_identifier       = [
    aws_subnet.webserver_subnet_az1.id,
    aws_subnet.webserver_subnet_az2.id
  ]
  health_check_type         = "ELB"
  health_check_grace_period = 30   # defualt is 300 via docs - shortened to 30
  target_group_arns         = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.web_side_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "assign2-web-asg-instance"
    propagate_at_launch = true
  }
}
