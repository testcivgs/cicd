terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_key_pair" "admin" {
  key_name = "admin"
  public_key = "${data.terraform_remote_state.vars.aws_ssh_public_key}"
}
