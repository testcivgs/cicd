output "private_subnets" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr_block" {
  value = "${module.vpc.vpc_cidr_block}"
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

output "dns_zone_mgmt_id" {
  value = "${aws_route53_zone.mgmt.id}"
}
