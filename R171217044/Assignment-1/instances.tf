provider "aws" {
    region = "us-east-1"
}
resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "my-subnet" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = cidrsubnet(aws_vpc.my-vpc.cidr_block,3,1)
    map_public_ip_on_launch = true
    tags={
        Name="My Subnet"
    }
}
resource "aws_security_group" "my-group" {
  vpc_id = aws_vpc.my-vpc.id
    ingress{
      cidr_blocks = [ aws_vpc.my-vpc.cidr_block ]
      description = "TLS"
      from_port =22
      protocol = "tcp"
      to_port = 22
    } 
    egress{
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "value"
      from_port = 0
      protocol = "-1"
      self = false
      to_port = 0
    }
    tags = {
      Name = "My Security Group"
    }
}
resource "aws_internet_gateway" "my-gateway" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
      Name = "My Internet Gateway"
    }
}
resource "aws_route_table" "my-route-table" {
    vpc_id = aws_vpc.my-vpc.id
    route{
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.my-gateway.id
    }
    tags = {
      Name = "My Route Table"
    }
}
resource "aws_route_table_association" "my-route-table-association" {
    subnet_id = aws_subnet.my-subnet.id
    route_table_id = aws_route_table.my-route-table.id
}
resource "aws_key_pair" "my-ssh-key" {
    key_name = "My Key"
    public_key = file("~/.ssh/mykey.pub")
}
resource "aws_instance" "name" {
    ami = var.instance_image
    instance_type = "t2.micro"
    count = 2
    key_name = aws_key_pair.my-ssh-key.key_name
    security_groups = [ aws_security_group.my-group.id ]
    associate_public_ip_address = true
    subnet_id = aws_subnet.my-subnet.id
    tags = {
      "Name" = "Instance"
    }
}