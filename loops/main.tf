resource "aws_vpc" "main" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      Name = "timing-loops"
      Terraform = "true"
      Environment = "DEV"
    }
}

#create 2 public subnet by using count loop

resource "aws_subnet" "public-subnets" {
    count = length(var.public_cidr_block)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_cidr_block[count.index]
  availability_zone = var.azs[count.index]
  tags = {
 Name = var.public_tags[count.index]
  }
}

# create 2 private subnets by using for each loop

resource "aws_subnet" "private-subnets" {
for_each = var.private_subnets
vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.azs
  tags = {
    Name= each.value.Name
  }
  
}