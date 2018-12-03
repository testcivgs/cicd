data "template_file" "node_exporter" {
  template = "${file("${path.module}/task-definition/node_exporter.json")}"

  vars {
    name_node_exporter  = "node_exporter"
    image_node_exporter = "prom/node-exporter:latest"
    docker_cpu_limit    = "1"
    docker_memory_limit = "256"
    }
}

resource "aws_ecs_task_definition" "node_exporter" {
  family                = "node_exporter"
  container_definitions = "${data.template_file.node_exporter.rendered}"
  network_mode          = "host"
}
