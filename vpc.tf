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
  map_public_ip_on_launch = true # this is defualted to false via the docs - we to enable as to give our webservers public IPs

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

resource "aws_route_table_association" "webserver_rt_assoc_az2" {
  subnet_id      = aws_subnet.webserver_subnet_az2.id
  route_table_id = aws_route_table.webserver_rt.id
}


