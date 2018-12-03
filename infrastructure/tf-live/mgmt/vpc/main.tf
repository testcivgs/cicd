terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

module "vpc" {
  source = "../../../tf-modules/aws_vpc"

	name                       = "mgmt"
	cidr                       = "${data.terraform_remote_state.vars.aws_vpc_cidr_mgmt}"
	public_subnets             = ["${data.terraform_remote_state.vars.mgmt_public_subnets}"]
	private_subnets            = ["${data.terraform_remote_state.vars.mgmt_private_subnets}"]
	azs                        = ["${data.terraform_remote_state.vars.mgmt_azs}"]
	enable_dns_hostnames       = true
	enable_dns_support         = true
	enable_nat_gateway         = true
	map_public_ip_on_launch    = true
        vpc_endpoints_service_name = "com.amazonaws.${data.terraform_remote_state.vars.aws_region}.s3"

	tags = {
	    "Terraform"   = "true"
	    "Environment" = "mgmt"
	}
}
