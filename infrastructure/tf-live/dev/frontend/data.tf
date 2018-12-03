

data "terraform_remote_state" "vpc" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "dev/vpc/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}

data "terraform_remote_state" "ecs_repo" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "global/ecs_repository/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "dev/ecs-cluster/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}

data "terraform_remote_state" "aws_alb" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "dev/balancer/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}

data "terraform_remote_state" "api" {
  backend  = "s3"
  config {
    bucket = "${data.terraform_remote_state.vars.tf_remote_state_bucket_name}"
    key    = "dev/backend/terraform.tfstate"
    region = "${data.terraform_remote_state.vars.aws_region}"
  }
}
