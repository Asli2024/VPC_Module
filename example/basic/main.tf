module "vpc_module" {
  source                    = "../../"
  region                    = var.region
  vpc_cidr_block            = var.vpc_cidr_block
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  private_subnet_cidr_block = var.private_subnet_cidr_block
  number_of_public_subnets  = var.number_of_public_subnets
  number_of_private_subnets = var.number_of_private_subnets
  number_of_natgateways     = var.number_of_natgateways
  number_elastic_ips        = var.number_elastic_ips
  vpc_flow_logs_role_name   = var.vpc_flow_logs_role_name
  enable_dns_hostnames      = var.enable_dns_hostnames
  enable_dns_support        = var.enable_dns_support
  s3_bucket_name            = var.s3_bucket_name
  common_tags               = var.common_tags
}
