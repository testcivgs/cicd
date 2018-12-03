
data "terraform_remote_state" "vpc" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "prod/vpc/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "prod/ecs_cluster/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}

data "aws_acm_certificate" "crt" {
  domain   = "*.${data.terraform_remote_state.vars.prod_domain_name}"
  statuses = ["ISSUED"]
}
