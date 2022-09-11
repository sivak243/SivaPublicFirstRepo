variable "Publicinstance_name" {
  description = "New Linux EC2"
  type = string
  default = "TarraformPublicEC2"
  
}

variable "Privateinstance_name" {
  description = "New Linux EC2"
  type = string
  default = "TarraformPrivateEC2"
  
}

variable "vpc_name" {
  description = "New VPC name"
  type = string
  default = "VPC_Terraform_T"
  
}


variable "private_cidr_block" {
  description = "Private IP EC2 CIDR Block"
  type = string
  default = "172.1.0.0/24"
  
}

variable "subnet1_cidr_block" {
  description = "Subnet 1 Range"
  type = string
  default = "10.42.0.0/17"
  
}

variable "OpenIP" {
  description = "Open IP for IGW"
  type = string
  default = "0.0.0.0/0"
  
}

variable "subnet2_cidr_block" {
  description = "Subnet 2 Range"
  type = string
  default = "10.42.128.0/18"
  
}

variable "subnet3_cidr_block" {
  description = "Subnet 3 Range"
  type = string
  default = "10.42.192.0/18"
  
}


data "aws_availability_zones" "available" {
  state = "available"
}

variable "VPC_ID" {
  description = "This variable will be populated from o/p var of VPC module"
  type = string
  
  
}

variable "igw1_ID" {
  description = "This variable will be populated from o/p var of VPC module"
  type = string
   
}
