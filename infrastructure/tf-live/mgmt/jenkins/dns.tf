
resource "aws_route53_record" "jenkins" {
  zone_id = "${data.terraform_remote_state.vpc.dns_zone_mgmt_id}"
  name    = "jenkins"
  type    = "A"

  alias {
    name                   = "${aws_elb.jenkins.dns_name}"
    zone_id                = "${aws_elb.jenkins.zone_id}"
    evaluate_target_health = false
  }
}
