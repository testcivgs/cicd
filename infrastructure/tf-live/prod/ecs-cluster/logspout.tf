data "template_file" "logspout" {
  template = "${file("${path.module}/task-definition/logspout.json")}"

  vars {
    name_logspout       = "logspout"
    image_logspout      = "gliderlabs/logspout"
    docker_cpu_limit    = "1"
    docker_memory_limit = "128"
    papertrailapp_host  = "${data.terraform_remote_state.vars.papertrail_host}"
    papertrailapp_port  = "${data.terraform_remote_state.vars.papertrail_port}"
  }
}

resource "aws_ecs_task_definition" "logspout" {
  family                = "logspout"
  container_definitions = "${data.template_file.logspout.rendered}"

  volume {
    name      = "dockersock"
    host_path = "/var/run/docker.sock"
  }
}
