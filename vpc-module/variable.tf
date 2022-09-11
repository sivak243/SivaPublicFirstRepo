variable "instance_name" {
  description = "New Linux EC2"
  type = string
  default = "DefaultEC2_T"
  
}

variable "vpc_name" {
  description = "New VPC name"
  type = string
  default = "VPC_Terraform_T"
  
}


variable "private_cidr_block" {
  description = "Private IP EC2 CIDR Block"
  type = string
  default = "10.42.0.0/16"
  
}

variable "subnet1_cidr_block" {
  description = "Subnet 1 Range"
  type = string
  default = "172.1.0.0/26"
  
}

variable "OpenIP" {
  description = "Open IP for IGW"
  type = string
  default = "0.0.0.0/0"
  
}

data "aws_availability_zones" "available" {
  state = "available"
}