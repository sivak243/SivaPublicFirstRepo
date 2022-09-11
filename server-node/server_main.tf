

resource "aws_instance" "LinuxPublicServerEC2" {
    count=1
     // ami = "ami-076e3a557efe1aa9c" # ap-south-1
        ami =data.aws_ami.ec2ami.id
        instance_type = "t2.micro"
        
        subnet_id = resource.aws_subnet.my_PublicSubnet.id

        user_data = file("script.sh")
    tags = {
   
         Name = format("%s_%s",var.Publicinstance_name,count.index)
    
  
   }
}

resource "aws_instance" "LinuxPrivateServerEC2" {
    count= 1
        ami =data.aws_ami.ec2ami.id
        instance_type = "t2.micro"
        
        subnet_id = resource.aws_subnet.my_PrivateSubnet.id

        user_data = file("script.sh")
    tags = {
   
         Name = format("%s_%s",var.Privateinstance_name,count.index)
   
  
   }
}

resource "aws_subnet" "my_PublicSubnet" {
  vpc_id=var.VPC_ID
  cidr_block        = var.subnet1_cidr_block
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet_T"
  }
}

resource "aws_subnet" "my_PrivateSubnet" {
  vpc_id=var.VPC_ID
  cidr_block        = var.subnet2_cidr_block
  availability_zone = "ap-south-1b"
 
 //Disabling the code , since we creating private EC2.
  //map_public_ip_on_launch = true

  tags = {
    Name = "PrivateSubnet_T"
  }
}

resource "aws_subnet" "my_DBSubnet" {
 
  vpc_id=var.VPC_ID
 
  cidr_block        = var.subnet3_cidr_block
  availability_zone = "ap-south-1c"


  tags = {
    Name = "DBSubnet_T"
  }
}



resource "aws_route_table" "PublicRouteTable1" {
 
  vpc_id=var.VPC_ID
  

  route {
    cidr_block = var.OpenIP
  
      gateway_id =var.igw1_ID
  }
  
  tags = {
    Name = "PublicRT_T"
  }
}

resource "aws_route_table_association" "RouteAssociation" {
  subnet_id      = aws_subnet.my_PublicSubnet.id
  route_table_id = aws_route_table.PublicRouteTable1.id
}


locals {
   ingress_rules = [{
      port        = 443
      description = "Ingress rules for port 443"
   },
   {
      port        = 80
      description = "Ingree rules for port 80"
   },
     {
      port        = 22
      description = "Ingree rules for port 22"
     },
     {
      port        = 3306
      description = "Ingree rules for port 22"
     }
   
   ]
}

resource "aws_security_group" "allow_http" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"

  vpc_id=var.VPC_ID


   dynamic "ingress" {
      for_each = local.ingress_rules

      content {
         description = ingress.value.description
         from_port   = ingress.value.port
         to_port     = ingress.value.port
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      
      }
   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http1"
  }
}


resource "aws_security_group" "allow_privateEc2" {
  name        = "PrivateEc2_acess"
  description = "Allow TLS inbound traffic"
  vpc_id=var.VPC_ID

  /*
  
  I am trying to make this block dynamic as below.

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }*/

   dynamic "ingress" {
      for_each = local.ingress_rules

      content {
         description = ingress.value.description
         from_port   = ingress.value.port
         to_port     = ingress.value.port
         protocol    = "tcp"
         cidr_blocks = ["10.42.0.0/17"]
       
      }
   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_privateEc2"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count =length(aws_instance.LinuxPublicServerEC2)
  security_group_id    = aws_security_group.allow_http.id
  network_interface_id = aws_instance.LinuxPublicServerEC2[count.index].primary_network_interface_id
    
}



resource "aws_network_interface_sg_attachment" "sg2_attachment" {
  count =length(aws_instance.LinuxPrivateServerEC2)
  security_group_id    = aws_security_group.allow_privateEc2.id
  network_interface_id = aws_instance.LinuxPrivateServerEC2[count.index].primary_network_interface_id
    
}

resource "aws_db_instance" "mysqldb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  db_subnet_group_name   =  aws_db_subnet_group.DBSubnetGroup.id 
  vpc_security_group_ids = [aws_security_group.allow_privateEc2.id]
}



resource "aws_db_subnet_group" "DBSubnetGroup" {
  name       = "main"
  subnet_ids = [aws_subnet.my_DBSubnet.id,aws_subnet.my_PrivateSubnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}
