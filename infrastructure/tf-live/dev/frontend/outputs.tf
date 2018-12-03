output "frontend_fqdn" {
  value = "${data.terraform_remote_state.vars.dev_domain_name}"
}

output "frontend_desired_count" {
	value = "${var.frontend_desired_count}"
}

output "frontend_task_definition" {
  value = "${module.ecs_service.task_definition}"
}

output "frontend_task_definition_arn" {
  value = "${module.ecs_service.task_definition_arn}"
}

output "frontend_docker_tag" {
  value = "${var.frontend_docker_tag}"
}

output "frontend_service_name" {
  value = "${module.ecs_service.ecs_service_name}"
}

output "frontend_service_arn" {
  value = "${module.ecs_service.ecs_service_arn}"
}
