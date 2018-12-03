resource "aws_alb_target_group" "service" {
  name                 = "${var.environment}-${var.service_name}"
  port                 = "${var.service_container_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "15"

  health_check {
    path = "${var.service_health_check_path}"
    matcher = "${var.service_health_check_code}"
  }
}

resource "aws_alb_listener_rule" "http" {
  listener_arn = "${var.listener_http_arn}"
  priority     = "${var.alb_rule_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.service.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.service_hostname}.${var.dns_zone_name}"]
  }
}

resource "aws_alb_listener_rule" "https" {
  listener_arn = "${var.listener_https_arn}"
  priority     = "${var.alb_rule_priority}"

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.service.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.service_hostname}.${var.dns_zone_name}"]
  }
}
