resource "aws_security_group" "service_alb" {
  name_prefix = "${data.terraform_remote_state.vpc.environment}_alb"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "${data.terraform_remote_state.vpc.environment} ALB security group"

  tags {
    Name        = "${data.terraform_remote_state.vpc.environment}-als-sg",
    Environment = "${data.terraform_remote_state.vpc.environment}"
    Terraform   = "true"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks     = [ "0.0.0.0/0" ]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks     = [ "0.0.0.0/0" ]
  }
}
