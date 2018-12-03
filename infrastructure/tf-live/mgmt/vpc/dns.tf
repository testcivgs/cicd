resource "aws_route53_zone" "mgmt" {
  name    = "${data.terraform_remote_state.vars.mgmt_domain_name}"
  comment = "Private Zone for Mgmt Environment"
  vpc_id  = "${module.vpc.vpc_id}"

  tags {
    Environment = "mgmt"
  }
}
