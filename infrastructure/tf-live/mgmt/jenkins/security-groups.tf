resource "aws_security_group" "jenkins" {
  name_prefix = "jenkins"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "Jenkins security group"

  tags {
    Name = "${var.name}"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = ["${data.terraform_remote_state.vpc.default_security_group_id}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  lifecycle {
    create_before_destroy = true
  }
}
