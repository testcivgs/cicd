terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_route53_zone" "main" {
  name    = "${data.terraform_remote_state.vars.main_domain}"
  comment = "DNS Parrent Zone (Managed by Terraform)"

  tags {
    Environment = "prod"
    Terraform   = "true"
  }
}

resource "aws_route53_record" "root_domain" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "${data.terraform_remote_state.vars.main_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${data.terraform_remote_state.vars.main_domain_ip}"]
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "www"
  type    = "CNAME"
  ttl     = "300"
  records = ["${data.terraform_remote_state.vars.main_domain}"]
}
