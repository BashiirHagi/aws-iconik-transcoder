resource "aws_vpc" "iconik_vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "iconik-vpc"
  }
}

resource "aws_internet_gateway" "iconik_igw" {
  vpc_id = aws_vpc.iconik_vpc.id

  tags = {
    Name = "iconik-igw"
  }
}

resource "aws_subnet" "iconik_public_subnet" {
  vpc_id                  = aws_vpc.iconik_vpc.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"  

  tags = {
    Name = "iconik-public-subnet"
  }
}

resource "aws_route_table" "iconik_public_rt" {
  vpc_id = aws_vpc.iconik_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iconik_igw.id
  }

  tags = {
    Name = "iconik-public-rt"
  }
}

resource "aws_route_table_association" "iconik_public_rt_assoc" {
  subnet_id      = aws_subnet.iconik_public_subnet.id
  route_table_id = aws_route_table.iconik_public_rt.id
}

