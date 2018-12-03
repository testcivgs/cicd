
# Create a new load balancer
resource "aws_alb" "service_alb" {
  internal        = "${var.is_internal}"
  security_groups = ["${aws_security_group.service_alb.id}", "${data.terraform_remote_state.vpc.default_security_group_id}"]
  subnets         = ["${data.terraform_remote_state.vpc.public_subnets_ids}"]
  idle_timeout    = "${var.balancer_idle_timeout}"

  tags {
    Name        = "${data.terraform_remote_state.vpc.environment}-alb"
    Environment = "${data.terraform_remote_state.vpc.environment}"
    Terraform   = "true"
  }
}

resource "aws_alb_listener" "service_listener_http" {
   load_balancer_arn = "${aws_alb.service_alb.arn}"
   port              = "${var.service_listener_port}"
   protocol          = "HTTP"

   default_action {
     target_group_arn = "${aws_alb_target_group.service.arn}"
     type             = "forward"
   }
}

resource "aws_alb_listener" "service_listener_https" {
   load_balancer_arn = "${aws_alb.service_alb.arn}"
   port              = "${var.service_listener_port_ssl}"
   protocol          = "HTTPS"
   ssl_policy        = "ELBSecurityPolicy-2016-08"
   certificate_arn   = "${data.aws_acm_certificate.crt.arn}"

   default_action {
     target_group_arn = "${aws_alb_target_group.service.arn}"
     type             = "forward"
   }
}

resource "aws_alb_target_group" "service" {
  name                 = "${data.terraform_remote_state.vpc.environment}-dummy-alb-tg"
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${data.terraform_remote_state.vpc.vpc_id}"
  deregistration_delay = "60"
}
