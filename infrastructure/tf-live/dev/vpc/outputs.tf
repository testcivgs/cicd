
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnets_ids" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_subnets_ids" {
  value = ["${module.vpc.public_subnets}"]
}

output "public_route_table_ids" {
  value = ["${module.vpc.public_route_table_ids}"]
}

output "private_route_table_ids" {
  value = ["${module.vpc.private_route_table_ids}"]
}

output "default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
}

output "nat_eips" {
  value = ["${module.vpc.nat_eips}"]
}

output "igw_id" {
  value = "${module.vpc.igw_id}"
}

output "aws_db_subnet_group" {
	value = "${aws_db_subnet_group.default.id}"
}

output "dns_zone_id" {
  value = "${aws_route53_zone.dns.id}"
}

output "dns_zone_name" {
  value = "${data.terraform_remote_state.vars.dev_domain_name}"
}

output "environment" {
  value = "${var.environment}"
}
