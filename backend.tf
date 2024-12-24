terraform {
  backend "s3" {
    bucket  = "techwithaden-terraform-state"
    key     = "vpc_module/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}
