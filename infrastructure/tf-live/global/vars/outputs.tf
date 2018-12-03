output "tf_remote_state_bucket_name" {
  value = "${var.tf_remote_state_bucket_name}"
}

output "rds_superuser_password_dev" {
  value = "${var.rds_superuser_password_dev}"
}

output "rds_superuser_password_prod" {
  value = "${var.rds_superuser_password_prod}"
}

output "rds_app_password_dev" {
  value = "${var.rds_app_password_dev}"
}

output "rds_app_password_prod" {
  value = "${var.rds_app_password_prod}"
}

output "rds_superuser_password_test" {
  value = "${var.rds_superuser_password_test}"
}

output "rds_app_password_test" {
  value = "${var.rds_app_password_test}"
}

output "ansible_vault_password" {
  value = "${var.ansible_vault_password}"
}

output "s3_ansible_vault_file_key" {
  value = "${aws_s3_bucket_object.ansible_vault_file.id}"
}

output "s3_deployer_ssh_key" {
  value = "${aws_s3_bucket_object.deployer_ssh_key.id}"
}

output "bootstrap_data_bucket_arn" {
  value = "${aws_s3_bucket.bootstrap_data.arn}"
}

output "bootstrap_data_bucket" {
  value = "${aws_s3_bucket.bootstrap_data.id}"
}

output "backup_bucket_arn" {
  value = "${aws_s3_bucket.backup.arn}"
}

output "backup_bucket" {
  value = "${aws_s3_bucket.backup.id}"
}

output "s3_deployer_ssh_private_key_arn" {
  value = "${aws_s3_bucket.bootstrap_data.arn}/${aws_s3_bucket_object.deployer_ssh_key.id}"
}

output "s3_deployer_ssh_private_key" {
  value = "${aws_s3_bucket.bootstrap_data.id}/${aws_s3_bucket_object.deployer_ssh_key.id}"
}

output "s3_ansible_vault_file_arn" {
  value = "${aws_s3_bucket.bootstrap_data.arn}/${aws_s3_bucket_object.ansible_vault_file.id}"
}

output "s3_ansible_vault_file" {
  value = "${aws_s3_bucket.bootstrap_data.id}/${aws_s3_bucket_object.ansible_vault_file.id}"
}

output "aws_ssh_public_key" {
  value = "${var.aws_ssh_public_key}"
}

output "main_domain" {
  value = "${var.main_domain}"
}

output "main_db_address" {
  value = "${var.main_db_address}"
}

output "main_domain_ip" {
  value = "${var.main_domain_ip}"
}

output "aws_vpc_cidr_mgmt" {
  value = "${var.aws_vpc_cidr_mgmt}"
}

output "mgmt_public_subnets" {
  value = ["${var.mgmt_public_subnets}"]
}

output "mgmt_private_subnets" {
  value = ["${var.mgmt_private_subnets}"]
}

output "mgmt_azs" {
  value = ["${var.mgmt_azs}"]
}

output "mgmt_domain_name" {
  value = "${var.mgmt_domain_name}"
}

output "aws_vpc_cidr_dev" {
  value = "${var.aws_vpc_cidr_dev}"
}

output "dev_public_subnets" {
  value = ["${var.dev_public_subnets}"]
}

output "dev_private_subnets" {
  value = ["${var.dev_private_subnets}"]
}

output "dev_azs" {
  value = ["${var.dev_azs}"]
}

output "dev_domain_name" {
  value = "${var.dev_domain_name}"
}

output "aws_vpc_cidr_test" {
  value = "${var.aws_vpc_cidr_test}"
}

output "test_public_subnets" {
  value = ["${var.test_public_subnets}"]
}

output "test_private_subnets" {
  value = ["${var.test_private_subnets}"]
}

output "test_azs" {
  value = ["${var.test_azs}"]
}

output "test_domain_name" {
  value = "${var.test_domain_name}"
}

output "prod_domain_name" {
  value = "${var.prod_domain_name}"
}

output "prod_azs" {
  value = "${var.prod_azs}"
}

output "prod_public_subnets" {
  value = "${var.prod_public_subnets}"
}

output "prod_private_subnets" {
  value = "${var.prod_private_subnets}"
}

output "aws_vpc_cidr_prod" {
  value = "${var.aws_vpc_cidr_prod}"
}

output "aws_region" {
  value = "${var.aws_region}"
}

output "git_infrastructure_repo" {
  value = "${var.git_infrastructure_repo}"
}

output "git_infrastructure_host" {
  value = "${var.git_infrastructure_host}"
}

output "papertrail_host" {
  value = "${var.papertrail_host}"
}

output "papertrail_port" {
  value = "${var.papertrail_port}"
}
