resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
     instance_tenancy = "default"
     enable_dns_hostnames = true
     enable_dns_support = true
        tags = {
        name = "timing1"
        Terraform = "true"
        Environment = "Dev"
     }
}

# create IG and attach to VPC

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
        name = "timing1 - ig"
        Terraform = "true"
        Environment = "Dev"
  }
}
 #create public subnet 
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
   tags = {
        name = "timing1-public-subnet"
        Terraform = "true"
        Environment = "Dev"
     }
  }


# create route table and assocaiate public subnet with public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
        name = "timing1-public-rt"
        Terraform = "true"
        Environment = "Dev"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
#create private subnet 
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.11.0/24"
   tags = {
        name = "timing1-private-subnet"
        Terraform = "true"
        Environment = "Dev"
     }
  }


# create route table and assocaiate private subnet with private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
        name = "timing1-private-rt"
        Terraform = "true"
        Environment = "Dev"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

#create database subnet 
resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.21.0/24"
   tags = {
        name = "timing1-database-subnet"
        Terraform = "true"
        Environment = "Dev"
     }
  }


# create route table and assocaiate database subnet with database route table
resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
        name = "timing1-database-rt"
        Terraform = "true"
        Environment = "Dev"
  }
}

resource "aws_route_table_association" "database" {
  subnet_id      = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.database_rt.id
}

resource "aws_eip" "elastic" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.elastic.id
  subnet_id     = aws_subnet.public_subnet.id
}

resource "aws_route" "Private" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.gw.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.gw.id
}