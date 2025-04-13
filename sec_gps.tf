

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group


# Bastion Host SG - allows SSH from anywhere
resource "aws_security_group" "bastion_sg" {
  name        = "assign2-bastion-sg"
  description = "Allow SSH access from anywhere (restricted by keypair)"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow all ipv4 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "assign2-bastion-sg"
  }
}
