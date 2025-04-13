# ------------------------
# VPC and routes 



# Create VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc 
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true # this flag is defaulted to false via the docs - enabled to allow hostnames in vpc - may be used 

  tags = {
    Name = "assign2-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "assign2-igw"
  }
}

# Public Subnet (AZ1)
 # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet 

resource "aws_subnet" "webserver_subnet_az1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true # this is defualted to false via the docs - we need to enable as to give our webservers public IPs

  tags = {
    Name = "assign2-webserver-subnet-az1"
  }
}




# Private Subnet (AZ1)
 # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

resource "aws_subnet" "db_subnet_az1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "assign2-db-subnet-az1"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "webserver_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "assign2-webserver-rt"
  }
}

# Associate route table to webserver subnet
resource "aws_route_table_association" "webserver_rt_assoc" {
  subnet_id      = aws_subnet.webserver_subnet_az1.id
  route_table_id = aws_route_table.webserver_rt.id
}




resource "aws_subnet" "webserver_subnet_az2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b" # different AZ
  map_public_ip_on_launch = true

  tags = {
    Name = "assign2-webserver-subnet-az2"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association

resource "aws_route_table_association" "webserver_rt_assoc_az2" {
  subnet_id      = aws_subnet.webserver_subnet_az2.id
  route_table_id = aws_route_table.webserver_rt.id
}



# Elastic IP for NAT Gateway
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip 
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "assign2-nat-eip"
  }
}

# NAT Gateway in Webserver (public) subnet
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.webserver_subnet_az1.id

  tags = {
    Name = "assign2-nat-gw"
  }

  depends_on = [aws_internet_gateway.igw]
}




# Route table for private (DB) subnet
resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "assign2-db-rt"
  }
}

# Associate private route table to DB subnet
resource "aws_route_table_association" "db_rt_assoc" {
  subnet_id      = aws_subnet.db_subnet_az1.id
  route_table_id = aws_route_table.db_rt.id
}


resource "aws_subnet" "db_subnet_az2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "assign2-db-subnet-az2"
  }
}

resource "aws_route_table_association" "db_rt_assoc_az2" {
  subnet_id      = aws_subnet.db_subnet_az2.id
  route_table_id = aws_route_table.db_rt.id
}
