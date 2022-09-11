

/*output instance_public_ip{
  description = "Public IP of AWS EC2 Instance"
  value =aws_instance.NewEc2.public_ip
    
  }*/
  
  output Output_VPCID {
  description = "this variable will have output vpc id"
  value =aws_vpc.my_vpc.id
  }

  output Output_GateWayID {
  description = "this variable will have output Gateway id"
  value =aws_internet_gateway.gw.id
  }


