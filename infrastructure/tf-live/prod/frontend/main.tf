terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

module "ecs_service" {
  source                    = "../../../tf-modules/aws_ecs_service"

  vpc_id                    = "${data.terraform_remote_state.vpc.vpc_id}"
  service_hostname          = "${var.service_hostname}"
  service_name              = "frontend"
  environment               = "${data.terraform_remote_state.vpc.environment}"
  service_container_port    = "${var.frontend_container_port}"
  vpc_default_sg_id         = "${data.terraform_remote_state.vpc.default_security_group_id}"
  docker_repository         = "${data.terraform_remote_state.ecs_repo.frontend_repo_url}"
  docker_tag                = "${var.frontend_docker_tag}"
  ecs_service_desired_count = "${var.frontend_desired_count}"
  service_health_check_path = "${var.frontend_health_check_path}"
  service_health_check_code = "${var.frontend_health_check_code}"
  dns_zone_id               = "${data.terraform_remote_state.vpc.dns_zone_id}"
  dns_zone_name             = "${data.terraform_remote_state.vars.prod_domain_name}"
  ecs_cluster_name          = "${data.terraform_remote_state.ecs_cluster.cluster_name}"
  listener_http_arn         = "${data.terraform_remote_state.aws_alb.service_listener_http_arn}"
  listener_https_arn        = "${data.terraform_remote_state.aws_alb.service_listener_https_arn}"
  alb_rule_priority         = 110
  docker_memory_limit       = "300"
  docker_cpu_limit          = "100"
  ecs_task_env_vars         = {
    api_protocol = "https"
    api_host     = "${data.terraform_remote_state.api.backend_fqdn}"
    server_name  = "${data.terraform_remote_state.vars.prod_domain_name}"
  }
}
