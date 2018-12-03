data "terraform_remote_state" "vpc" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "mgmt/vpc/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}

data "terraform_remote_state" "global" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "global/aws_key_pair/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}
