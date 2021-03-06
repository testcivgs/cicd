/**
 * Provides internal access to container ports
 */
resource "aws_security_group" "ecs" {
  description = "Container Instance Allowed Ports"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port = 1
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "ecs-${data.terraform_remote_state.vpc.environment}-sg"
    Terraform   = "true"
    Environment = "${data.terraform_remote_state.vpc.environment}"
  }
}
