resource "aws_route53_record" "main" {
  zone_id = "${data.terraform_remote_state.vpc.dns_zone_id}"
  name    = "${data.terraform_remote_state.vpc.dns_zone_name}"
  type    = "A"

  alias {
    name                   = "${aws_alb.service_alb.dns_name}"
    zone_id                = "${aws_alb.service_alb.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "service" {
  zone_id = "${data.terraform_remote_state.vpc.dns_zone_id}"
  name    = "*"
  type    = "A"

  alias {
    name                   = "${aws_alb.service_alb.dns_name}"
    zone_id                = "${aws_alb.service_alb.zone_id}"
    evaluate_target_health = false
  }
}
