#AWS Provider 
provider "aws" {
  region         = "${var.region}"
}
#VPC
resource "aws_vpc" "VPC-X" {
  cidr_block = "9.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-X"
  }
}
#INTERNET GATEWAY
resource "aws_internet_gateway" "IGW-X" {
  vpc_id             = "${aws_vpc.VPC-X.id}"
  tags = {
    Name             = "IGW-X"
  } 
}
#NAT GATEWAY
resource "aws_eip" "EIP" {
  vpc           = true
}
resource "aws_nat_gateway" "NAT" {
  allocation_id           = "${aws_eip.EIP.id}"
  subnet_id               = "${aws_subnet.Bastion.id}"
  tags = {
    Name                  = "NAT"
  }
}

#SUBNETS


#PUBLIC
resource "aws_subnet" "Bastion" {
  vpc_id                     = "${aws_vpc.VPC-X.id}"
  cidr_block                 = "${var.SUBNET[0]}"
  availability_zone          = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch    = true
  tags = {
    Name                     = "Bastion"
  }
}

resource "aws_subnet" "LB1" {
  vpc_id                     = "${aws_vpc.VPC-X.id}"
  cidr_block                 = "${var.SUBNET[1]}"
  availability_zone          = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch    = true
  tags = {
    Name                     = "LB1"
  }
}
resource "aws_subnet" "LB2" {
  vpc_id                     = "${aws_vpc.VPC-X.id}"
  cidr_block                 = "${var.SUBNET[2]}"
  availability_zone          = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch    = true
  tags = {
    Name                     = "LB2"
  }
}

#PRIVATE

resource "aws_subnet" "WH1" {
  vpc_id                     = "${aws_vpc.VPC-X.id}"
  cidr_block                 = "${var.SUBNET[3]}"
  availability_zone          = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name                     = "WH1"
  }
}

resource "aws_subnet" "WH2" {
  vpc_id                     = "${aws_vpc.VPC-X.id}"
  cidr_block                 = "${var.SUBNET[4]}"
  availability_zone          = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name                     = "WH2"
  }
}


#ROUTING TABLE

#PUBLIC
resource "aws_route_table" "PUBLIC" {
  vpc_id              = "${aws_vpc.VPC-X.id}"
  route {
    cidr_block        = "${var.ALLIP}"
    gateway_id        = "${aws_internet_gateway.IGW-X.id}"
  }
  tags = {
    Name              = "PUBLIC"
  }
}
#PUBLIC ASSOCIATES

resource "aws_route_table_association" "SubPublic1" {
 subnet_id               = "${aws_subnet.Bastion.id}"
  route_table_id         = "${aws_route_table.PUBLIC.id}"
}
resource "aws_route_table_association" "SubPublic2" {
 subnet_id               = "${aws_subnet.LB1.id}"
  route_table_id         = "${aws_route_table.PUBLIC.id}"
} 
resource "aws_route_table_association" "SubPublic3" {
 subnet_id               = "${aws_subnet.LB2.id}"
  route_table_id         = "${aws_route_table.PUBLIC.id}"
}

#PRIVATE
resource "aws_route_table" "PRIVATE" {
  vpc_id             = "${aws_vpc.VPC-X.id}"
  route {
    cidr_block       = "${var.ALLIP}"
    nat_gateway_id   = "${aws_nat_gateway.NAT.id}"
    }
  tags ={
     Name            = "PRIVATE"
    }
 
}
#PRIVATE ASSOCIATES
resource "aws_route_table_association" "SubPrivate1" {
 subnet_id               = "${aws_subnet.WH1.id}"
  route_table_id         = "${aws_route_table.PRIVATE.id}"
}
resource "aws_route_table_association" "SubPrivate2" {
 subnet_id               = "${aws_subnet.WH2.id}"
  route_table_id         = "${aws_route_table.PRIVATE.id}"
}