resource "aws_vpc" "main" {
 cidr_block           = "10.0.0.0/16"
 enable_dns_hostnames = true
 enable_dns_support   = true
 tags = {
   name = "main"
 }
}

resource "aws_subnet" "public_subnet_a" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1a"

}

resource "aws_subnet" "public_subnet_b" {
 vpc_id                  = aws_vpc.main.id
 cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
 map_public_ip_on_launch = true
 availability_zone       = "us-east-1b"

}


#`````````````````
# Public Subnet A
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 3)
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
}

# Private Subnet B
resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 4)
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
}



resource "aws_eip" "nat_eip" {
    depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "private_subnet_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}



#````````````````

resource "aws_internet_gateway" "internet_gateway" {
 vpc_id = aws_vpc.main.id
 tags = {
   Name = "internet_gateway"
 }
}

resource "aws_route_table" "route_table" {
 vpc_id = aws_vpc.main.id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.internet_gateway.id
 }
}

#resource "aws_route_table_association" "subnet_route" {
# subnet_id      = aws_subnet.subnet.id
# route_table_id = aws_route_table.route_table.id
#}
#
#resource "aws_route_table_association" "subnet2_route" {
# subnet_id      = aws_subnet.subnet2.id
# route_table_id = aws_route_table.route_table.id
#}


resource "aws_route_table_association" "subnet_route" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_route" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.route_table.id
}
