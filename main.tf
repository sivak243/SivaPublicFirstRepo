module networking{
  source="./vpc-module"
}


module instanceConfig{
  source="./server-node"
  VPC_ID = module.networking.Output_VPCID
  igw1_ID = module.networking.Output_GateWayID
  //VAR_PublicIP=module.InstanceConfig.instance_public_ip
  /*Finalpublic_ip= module.InstanceConfig.instance_public_ip
   var.Finalpublic_ip= module.instance_Finalpublic_ip*/
}