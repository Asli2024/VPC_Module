variable "region" {
  description = "The region in which the VPC will be created."
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "The list of CIDR blocks for the public subnets"
  type        = list(string)
}



variable "private_subnet_cidr_block" {
  description = "The CIDR block for the private subnet."
  type        = list(string)
}

variable "number_of_public_subnets" {
  description = "The number of public subnets to create."
  type        = number
}

variable "number_of_private_subnets" {
  description = "The number of private subnets to create."
  type        = number
}

variable "number_of_natgateways" {
  description = "The number of nat gateways to create."
  type        = number
}

variable "number_elastic_ips" {
  description = "The list of EIP allocation IDs for the NAT gateways."
  type        = number
}

variable "vpc_flow_logs_role_name" {
  description = "The name of the IAM role for the VPC flow logs."
  type        = string
}
