output instance_Finalpublic_ip{
  description = "Public IP of AWS EC2 Instance"
    /*value =aws_instance.NewEc2.public_ip
    //value = "{module.aws_instance.NewEc2.public_ip}"
    //value =module.InstanceConfig.aws_instance.NewEc2.public_ip
    //value=module.InstanceConfig.aws_instance.NewEc2.public_ip*/
    value=module.instanceConfig.OutputInstance_public_ip
    
 }
  

