/*Creating a new VPC*/

resource "aws_vpc" "my_vpc" {
  cidr_block = var.private_cidr_block
  

  tags = {
    Name = var.vpc_name
  }
}

/*
resource "aws_instance" "NewEc2" {
  ami           = "ami-076e3a557efe1aa9c" # ap-south-1
  instance_type = "t2.micro"

  subnet_id= aws_subnet.my_PublicSubnet.id 
   user_data = file("script.sh")

  tags = {
    Name = var.instance_name
  }

}

resource "aws_subnet" "my_PublicSubnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet1_cidr_block
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet_T"
  }
}
*/
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "mainIGW_T"
  }
}
/*
resource "aws_route_table" "PublicRouteTable1" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = var.OpenIP
    //cidr_block ="::/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  tags = {
    Name = "PublicRT_T"
  }
}

resource "aws_route_table_association" "RouteAssociation" {
  subnet_id      = aws_subnet.my_PublicSubnet.id
  route_table_id = aws_route_table.PublicRouteTable1.id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.allow_http.id
  network_interface_id = aws_instance.NewEc2.primary_network_interface_id
}
*/