resource "aws_route53_record" "bastion" {
  zone_id = "${data.terraform_remote_state.route_53.dns_zone_id_main}"
  name = "bastion"
  type = "A"
  ttl = "300"
  records = [ "${aws_eip.bastion_eip.public_ip}" ]
}
