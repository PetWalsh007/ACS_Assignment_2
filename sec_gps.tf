# ---------------
# Security Group Definitions

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

# Web Server SG - allow HTTP from anywhere and SSH from Bastion
resource "aws_security_group" "web_sg" {
  name        = "assign2-web-sg"
  description = "Allow HTTP from internet, SSH from Bastion"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP from internet to app"
    from_port   = 8050
    to_port     = 8050
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id] 
  }



  ingress {
    description     = "SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "assign2-web-sg"
  }
}

# DB SG - 
resource "aws_security_group" "db_sg" {
  name        = "assign2-db-sg"
  description = "Allow DB Traffic from Webservers"
  vpc_id      = aws_vpc.main_vpc.id

    # to close these ports when we decide backend db 
  ingress {
    description     = "Allow API traffic from Web SG"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }


  
  ingress {
    description     = "SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "assign2-db-sg"
  }
}




resource "aws_security_group" "alb_sg" {
  name        = "assign2-alb-sg"
  description = "Allow HTTP from Internet to ALB"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "assign2-alb-sg"
  }
}
