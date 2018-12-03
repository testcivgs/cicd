resource "aws_security_group" "bastion" {
  name        = "${var.name}"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "Bastion security group (only SSH inbound access is allowed)"

  tags {
    Name = "${var.name}"
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    protocol    = "udp"
    from_port   = 1194
    to_port     = 1194
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}
