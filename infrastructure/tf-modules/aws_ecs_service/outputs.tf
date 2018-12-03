
output "task_definition" {
  value = "${aws_ecs_task_definition.ecs_task.family}"
}

output "task_definition_arn" {
  value = "${aws_ecs_task_definition.ecs_task.arn}"
}

output "ecs_service_name" {
  value = "${aws_ecs_service.ecs_service.name}"
}

output "ecs_service_arn" {
  value = "${aws_ecs_service.ecs_service.id}"
}

output "aws_alb_target_group_arn" {
  value = "${aws_alb_target_group.service.arn}"
}
