terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_s3_bucket" "bootstrap_data" {
  bucket = "${var.bootstrap_data_bucket}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "ansible_vault_file" {
  bucket  = "${aws_s3_bucket.bootstrap_data.bucket}"
  key     = "ansible/vault.txt"
  content = "${var.ansible_vault_password}"

  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "deployer_ssh_key" {
  bucket  = "${aws_s3_bucket.bootstrap_data.bucket}"
  key     = "ssh-keys/id_rsa"
  content = "${var.deployer_ssh_key}"

  server_side_encryption = "AES256"
}

resource "aws_s3_bucket" "backup" {
  bucket = "${var.backup_bucket}"
  acl    = "private"

  versioning {
    enabled = true
  }
}
