region                    = "eu-west-2"
vpc_cidr_block            = "10.0.0.0/16"
number_of_public_subnets  = 2
number_of_private_subnets = 2
number_of_natgateways     = 1
number_elastic_ips        = 1
private_subnet_cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
