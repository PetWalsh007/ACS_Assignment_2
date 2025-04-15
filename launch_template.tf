


resource "aws_launch_template" "web_side_lt" {
  name_prefix   = "assign2-web-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.nano"
  key_name      = var.keypair
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "assign2-web-instance"
    }
  }
}
