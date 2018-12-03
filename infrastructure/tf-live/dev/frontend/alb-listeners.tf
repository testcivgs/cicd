resource "aws_alb_listener_rule" "http" {
  listener_arn = "${data.terraform_remote_state.aws_alb.service_listener_http_arn}"
  priority     = "50"

  action {
    type             = "forward"
    target_group_arn = "${module.ecs_service.aws_alb_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${data.terraform_remote_state.vars.dev_domain_name}"]
  }
}

resource "aws_alb_listener_rule" "http_api" {
  listener_arn = "${data.terraform_remote_state.aws_alb.service_listener_http_arn}"
  priority     = "40"

  action {
    type             = "forward"
    target_group_arn = "${data.terraform_remote_state.api.aws_alb_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${data.terraform_remote_state.vars.dev_domain_name}"]
  }

  condition {
    field  = "path-pattern"
    values = ["/api/*"]
  }
}

resource "aws_alb_listener_rule" "http_api_wildcard" {
  listener_arn = "${data.terraform_remote_state.aws_alb.service_listener_http_arn}"
  priority     = "150"

  action {
    type             = "forward"
    target_group_arn = "${data.terraform_remote_state.api.aws_alb_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.${data.terraform_remote_state.vars.dev_domain_name}"]
  }

  condition {
    field  = "path-pattern"
    values = ["/api/*"]
  }
}

resource "aws_alb_listener_rule" "http_wildcard" {
  listener_arn = "${data.terraform_remote_state.aws_alb.service_listener_http_arn}"
  priority     = "200"

  action {
    type             = "forward"
    target_group_arn = "${module.ecs_service.aws_alb_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.${data.terraform_remote_state.vars.dev_domain_name}"]
  }
}

resource "aws_alb_listener_rule" "https" {
  listener_arn = "${data.terraform_remote_state.aws_alb.service_listener_https_arn}"
  priority     = "50"

  action {
    type             = "forward"
    target_group_arn = "${module.ecs_service.aws_alb_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${data.terraform_remote_state.vars.dev_domain_name}"]
  }
}

resource "aws_alb_listener_rule" "https_api" {
  listener_arn = "${data.terraform_remote_state.aws_alb.service_listener_https_arn}"
  priority     = "40"

  action {
    type             = "forward"
    target_group_arn = "${data.terraform_remote_state.api.aws_alb_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["${data.terraform_remote_state.vars.dev_domain_name}"]
  }

  condition {
    field  = "path-pattern"
    values = ["/api/*"]
  }
}

resource "aws_alb_listener_rule" "https_api_wildcard" {
  listener_arn = "${data.terraform_remote_state.aws_alb.service_listener_https_arn}"
  priority     = "150"

  action {
    type             = "forward"
    target_group_arn = "${data.terraform_remote_state.api.aws_alb_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.${data.terraform_remote_state.vars.dev_domain_name}"]
  }

  condition {
    field  = "path-pattern"
    values = ["/api/*"]
  }
}

resource "aws_alb_listener_rule" "https_wildcard" {
  listener_arn = "${data.terraform_remote_state.aws_alb.service_listener_https_arn}"
  priority     = "200"

  action {
    type             = "forward"
    target_group_arn = "${module.ecs_service.aws_alb_target_group_arn}"
  }

  condition {
    field  = "host-header"
    values = ["*.${data.terraform_remote_state.vars.dev_domain_name}"]
  }
}
