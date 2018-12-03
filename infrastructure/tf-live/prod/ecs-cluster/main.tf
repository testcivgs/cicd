terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_ecs_cluster" "ecs" {
  name = "${data.terraform_remote_state.vpc.environment}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    ecs_cluster                   = "${aws_ecs_cluster.ecs.name}"
    task_definition_logspout      = "${aws_ecs_task_definition.logspout.arn}"
    task_definition_cadvisor      = "${aws_ecs_task_definition.cadvisor.arn}"
    task_definition_node_exporter = "${aws_ecs_task_definition.cadvisor.arn}"

    s3_github_ssh_key             = "${data.terraform_remote_state.vars.s3_deployer_ssh_private_key}"
    git_infrastructure_repo       = "${data.terraform_remote_state.vars.git_infrastructure_repo}"
    git_infrastructure_host       = "${data.terraform_remote_state.vars.git_infrastructure_host}"
  }
}

resource "aws_launch_configuration" "ecs" {
  name_prefix          = "ecs_${data.terraform_remote_state.vpc.environment}-"
  image_id             = "${var.ecs_ami}"
  instance_type        = "${var.ecs_instance_type}"
  key_name             = "${data.terraform_remote_state.ssh_key.admin_key_name}"
  security_groups      = ["${aws_security_group.ecs.id}",
  						            "${data.terraform_remote_state.vpc.default_security_group_id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  user_data            = "${data.template_file.user_data.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  name                 = "ecs-${data.terraform_remote_state.vpc.environment}-asg"
  vpc_zone_identifier  = [
    "${data.terraform_remote_state.vpc.private_subnets_ids}"
  ]
  launch_configuration = "${aws_launch_configuration.ecs.name}"
  min_size             = "${var.ecs_instance_size_min}"
  max_size             = "${var.ecs_instance_size_max}"
  desired_capacity     = "${var.ecs_instance_size}"

  tag {
    key                 = "Name"
    value               = "ecs-host"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${data.terraform_remote_state.vpc.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "IAMSSH"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Monitoring"
    value               = "node_exporter"
    propagate_at_launch = true
  }
}
