terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

data "template_file" "user_data" {
  template = "${file("${path.module}/${var.user_data_file}")}"

  vars {
    s3_github_ssh_key         = "${data.terraform_remote_state.vars.s3_deployer_ssh_private_key}"
    s3_ansible_vault_file_key = "${data.terraform_remote_state.vars.s3_ansible_vault_file}"
    git_infrastructure_repo   = "${data.terraform_remote_state.vars.git_infrastructure_repo}"
    git_infrastructure_host   = "${data.terraform_remote_state.vars.git_infrastructure_host}"
  }
}

resource "aws_launch_configuration" "jenkins" {
  name_prefix                 = "${var.name}-"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  user_data                   = "${data.template_file.user_data.rendered}"
  security_groups             = [
    "${aws_security_group.jenkins.id}",
    "${data.terraform_remote_state.vpc.default_security_group_id}"
  ]
  iam_instance_profile        = "${aws_iam_instance_profile.jenkins.name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  key_name                    = "${data.terraform_remote_state.global.admin_key_name}"
  enable_monitoring           = false

  root_block_device {
    volume_type = "standard"
    volume_size = 100
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "jenkins" {
  vpc_zone_identifier       = [
    "${data.terraform_remote_state.vpc.private_subnets}"
  ]
  desired_capacity          = "1"
  min_size                  = "1"
  max_size                  = "1"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.jenkins.name}"
  // ALB requires two AZ. Will use ELB.
  //target_group_arns         = ["${aws_alb_target_group.jenkins.id}"]
  load_balancers            = ["${aws_elb.jenkins.name}"]

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "${var.role}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "mgmt"
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

  lifecycle {
    create_before_destroy = true
  }
}
