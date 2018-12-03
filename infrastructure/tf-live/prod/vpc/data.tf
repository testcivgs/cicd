data "aws_caller_identity" "current" { }

data "terraform_remote_state" "mgmt" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "mgmt/vpc/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}

data "terraform_remote_state" "route53" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "global/route_53/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}
