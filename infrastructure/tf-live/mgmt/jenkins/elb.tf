resource "aws_security_group" "jenkins_elb" {
  name_prefix = "jenkins_elb"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "Jenkins security group"

  tags {
    Name        = "jenkins-elb-sg",
    Environment = "mgmt"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# Create a new load balancer
resource "aws_elb" "jenkins" {
  name               = "jenkins-elb"
  internal           = true
  security_groups    = ["${aws_security_group.jenkins_elb.id}", "${data.terraform_remote_state.vpc.default_security_group_id}"]
  subnets            = ["${data.terraform_remote_state.vpc.private_subnets}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    target = "HTTP:8080/login"
    interval = 30
  }

  tags {
    Name        = "jenkins",
    Environment = "mgmt",
    Terraform   = "true"
  }
}
