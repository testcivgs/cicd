data "template_file" "cadvisor" {
  template = "${file("${path.module}/task-definition/cadvisor.json")}"

  vars {
    name_cadvisor        = "cadvisor"
    image_cadvisor       = "google/cadvisor:latest"
    docker_cpu_limit    = "1"
    docker_memory_limit = "256"
    }
}

resource "aws_ecs_task_definition" "cadvisor" {
  family                = "cadvisor"
  container_definitions = "${data.template_file.cadvisor.rendered}"

  volume {
    name      = "rootfs"
    host_path = "/"
  }

  volume {
    name      = "run"
    host_path = "/var/run"
  }

  volume {
    name      = "sys"
    host_path = "/sys"
  }

  volume {
    name      = "docker"
    host_path = "/var/lib/docker/"
  }

  volume {
    name      = "cgroup"
    host_path = "/cgroup"
  }

}
