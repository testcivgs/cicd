output "dns_zone_name_main" {
  value = "${aws_route53_zone.main.name}"
}

output "dns_zone_id_main" {
  value = "${aws_route53_zone.main.id}"
}
