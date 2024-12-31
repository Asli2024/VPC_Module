variable "region" {
  description = "The region in which the VPC will be created."
  type        = string
  default     = ""
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = ""
}
variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "public_subnet_cidr_blocks" {
  description = "The list of CIDR blocks for the public subnets"
  type        = list(string)
  default     = []
}



variable "private_subnet_cidr_block" {
  description = "The CIDR block for the private subnet."
  type        = list(string)
  default     = []
}

variable "number_of_public_subnets" {
  description = "The number of public subnets to create."
  type        = number
  default     = 0
}

variable "number_of_private_subnets" {
  description = "The number of public subnets to create."
  type        = number
  default     = 0
}

variable "number_of_natgateways" {
  description = "The number of public subnets to create."
  type        = number
  default     = 0
}

variable "number_elastic_ips" {
  description = "The number of public subnets to create."
  type        = number
  default     = 0
}

variable "vpc_flow_logs_role_name" {
  description = "The name of the IAM role for the VPC flow logs."
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to create for vpc flow logs."
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "VPC_Module"
  }
}

