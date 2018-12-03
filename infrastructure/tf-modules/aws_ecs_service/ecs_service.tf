
data "template_file" "registry_task" {
  template = "${file(coalesce("task-definition/task.json", "${path.module}/task-definition/task.json"))}"

  vars = "${merge(map("service_name", "${var.service_name}",
                      "docker_image", "${var.docker_repository}:${var.docker_tag}",
                      "container_port", "${var.service_container_port}",
                      "docker_cpu_limit", "${var.docker_cpu_limit}",
                      "docker_memory_limit", "${var.docker_memory_limit}"),
                  var.ecs_task_env_vars)}"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                = "${var.environment}_${var.service_name}"
  container_definitions = "${data.template_file.registry_task.rendered}"
  task_role_arn         = "${var.task_role_arn}"
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.environment}_${var.service_name}"
  cluster         = "${var.ecs_cluster_name}"
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"
  desired_count   = "${var.ecs_service_desired_count}"
  iam_role        = "${aws_iam_role.ecs_service.name}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.service.id}"
    container_name   = "${var.service_name}"
    container_port   = "${var.service_container_port}"
  }

  depends_on = [
    "aws_iam_role_policy.ecs_service"
  ]
}
