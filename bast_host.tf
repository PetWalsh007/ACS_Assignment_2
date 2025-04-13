# ------------------------
# Bastion Host EC2 Instance


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance




# Similar to Assignment 1 - we will attempt to fetch the most recent AMI for amazon linux 2023 -- 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami 


data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}





resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.nano"
  key_name      = var.keypair
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "assign2-bastion"
  }
}
