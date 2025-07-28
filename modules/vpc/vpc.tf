resource "aws_vpc" "iconik_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
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
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone[0] //list indices 
  map_public_ip_on_launch = true

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

resource "aws_subnet" "iconik_private_subnet" { ####
  vpc_id            = aws_vpc.iconik_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone[1] //list indices 

  tags = {
    Name = "iconik-private-subnet"
  }
}

resource "aws_eip" "eip" {
  domain = "vpc"
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "nat_gw" {
  connectivity_type = "public"
  subnet_id         = aws_subnet.iconik_public_subnet.id
  allocation_id     = aws_eip.eip.id
  depends_on        = [aws_internet_gateway.iconik_igw]

  tags = {
    Name = "iconik-nat-gateway"
  }
}

# Route Table for private subnet  ///
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.iconik_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "iconik-private-rt"
  }
}

# Associate private subnet with private route table ////
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.iconik_private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "iconik_public_rt_assoc" {
  subnet_id      = aws_subnet.iconik_public_subnet.id
  route_table_id = aws_route_table.iconik_public_rt.id
}

