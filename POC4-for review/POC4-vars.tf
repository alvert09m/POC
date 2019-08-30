#Regions
variable "region" {
  description     = "regions"
  default         = "us-east-2"
}

#SUBNETS
variable "SUBNET" {
  description     = "CIDR SUBNET"
  default         = ["9.0.1.0/24","9.0.2.0/24","9.0.3.0/24","9.0.4.0/24","9.0.5.0/24"]
}
#Availability Zone
data "aws_availability_zones" "available" {
  state           = "available"
}
#ROUTING TABLE
variable "ALLIP" {
  description     = "CIDR ALL IP"
  default         = "0.0.0.0/0"
}

#Ami for ubuntu
data "aws_ami" "ubuntu" {
most_recent=true
 
filter {
name="name"
values= ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
 }
 
filter {
name="virtualization-type"
values= ["hvm"]
 }
 
owners= ["099720109477"] # Canonical
}
resource "aws_key_pair" "KP2" {
  key_name       = "KP2"
  public_key     = "${file("KP1-pub.pem")}"
}


#SECURITY GROUP
variable "SSH" {
  description     = "SSH"
  default         = "22"
}
variable "HTTP" {
  description     = "HTTP"
  default         = "80"
}
variable "ALL" {
  description     = "ALL"
  default         = "0"
}

