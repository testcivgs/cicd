terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_ecr_repository" "frontend" {
  name = "${var.frontend_app_name}"
}
