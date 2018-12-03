
resource "aws_route53_zone" "dns" {
  name    = "${data.terraform_remote_state.vars.dev_domain_name}"
  comment = "DNS Zone for ${var.environment} Environment"

  tags {
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}

resource "aws_route53_record" "ns" {
  zone_id = "${data.terraform_remote_state.route53.dns_zone_id_main}"
  name    = "${data.terraform_remote_state.vars.dev_domain_name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.dns.name_servers.0}",
    "${aws_route53_zone.dns.name_servers.1}",
    "${aws_route53_zone.dns.name_servers.2}",
    "${aws_route53_zone.dns.name_servers.3}",
  ]
}
