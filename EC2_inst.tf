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
  subnet_id     = aws_subnet.webserver_subnet_az1.id
  key_name      = var.keypair
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = "assign2-bastion"
  }
}


resource "aws_instance" "db_server_priv" {
  ami                         = "ami-070289e46f076ccf5" 
  instance_type               = "t2.nano"
  subnet_id                   = aws_subnet.db_subnet_az1.id
  private_ip                  = "10.0.2.84"
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  associate_public_ip_address = false
  key_name                    = var.keypair

  tags = {
    Name = "assign2-db-server"
  }
}

