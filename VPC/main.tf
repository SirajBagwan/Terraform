# Adding VPC
resource "aws_vpc" "prod_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "prod_vpc"
  }
}

# Adding subnets to VPC
resource "aws_subnet" "Public_A" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = var.pub_sub_a
  availability_zone = var.az-a
  depends_on        = [aws_vpc.prod_vpc]
  tags = {
    Name = "publicA"
  }
}

resource "aws_subnet" "Public_B" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = var.pub_sub_b
  availability_zone = var.az-b
  depends_on        = [aws_vpc.prod_vpc]
  tags = {
    Name = "publicB"
  }
}

resource "aws_subnet" "Private_A" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = var.pri_sub_a
  availability_zone = var.az-a
  depends_on        = [aws_vpc.prod_vpc]
  tags = {
    Name = "privateA"
  }
}

resource "aws_subnet" "Private_B" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = var.pri_sub_b
  availability_zone = var.az-b
  depends_on        = [aws_vpc.prod_vpc]
  tags = {
    Name = "privateB"
  }
}

# Adding internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id     = aws_vpc.prod_vpc.id
  depends_on = [aws_vpc.prod_vpc]
  tags = {
    Name = "igw"
  }
}

# Adding Route Tables
resource "aws_route_table" "RT_Public" {
  vpc_id     = aws_vpc.prod_vpc.id
  depends_on = [aws_subnet.Public_A, aws_subnet.Public_B]
  route {
    cidr_block = var.all_traffic_anywhere
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "publicRT"
  }
}

# Route Table Association to public subnet
resource "aws_route_table_association" "RT_Public_A_Asso" {
  subnet_id      = aws_subnet.Public_A.id
  route_table_id = aws_route_table.RT_Public.id
  depends_on     = [aws_route_table.RT_Public]
}

resource "aws_route_table_association" "RT_Public_B_Asso" {
  subnet_id      = aws_subnet.Public_B.id
  route_table_id = aws_route_table.RT_Public.id
  depends_on     = [aws_route_table.RT_Public]
}

#Creating Elastic IP and Nat
resource "aws_eip" "eip" {
 }

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.Public_A.id
  depends_on = [ aws_internet_gateway.igw ]
  tags = {
    Name = "NAT"
  }
}

#Route tables for private subnets 
resource "aws_route_table" "RT_Priavte_A" {
  vpc_id     = aws_vpc.prod_vpc.id
  depends_on = [aws_subnet.Private_A, aws_subnet.Private_A]
  route {
    cidr_block = var.all_traffic_anywhere
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "RT_Private_A"
  }
}

resource "aws_route_table" "RT_Priavte_B" {
  vpc_id     = aws_vpc.prod_vpc.id
  depends_on = [aws_subnet.Private_B, aws_subnet.Private_B]
  route {
    cidr_block = var.all_traffic_anywhere
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "RT_Private_B"
  }
}

#Priavte route table association
resource "aws_route_table_association" "RT_Private_A_Asso" {
  subnet_id      = aws_subnet.Private_A.id
  route_table_id = aws_route_table.RT_Priavte_A.id
  depends_on     = [aws_route_table.RT_Priavte_A]
}

resource "aws_route_table_association" "RT_Private_B_Asso" {
  subnet_id      = aws_subnet.Private_B.id
  route_table_id = aws_route_table.RT_Priavte_B.id
  depends_on     = [aws_route_table.RT_Priavte_B]
}
