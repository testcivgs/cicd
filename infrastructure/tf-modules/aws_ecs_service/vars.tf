

variable "vpc_id" {
  description = "VPC ID"
}

variable "service_hostname" {
  description = "Service name used to compose DNS A record."
}

variable "service_name" {
  description = "Service name used to compose AWS resources names."
}

variable "environment" {
  description = "Environment resource tag."
}

variable "service_container_port"  {
  default = 8080
}

variable "service_listener_port" {
  default = 80
}

variable "service_listener_port_ssl" {
  default = 443
}

variable "aws_alb_subnets" {
  description = "AWS ALB subnets."
  default     = []
}

variable "vpc_default_sg_id" {
  description = "VPC default security group id."
}

variable "docker_tag" {
  default = "latest"
}

variable "docker_repository" {
}

variable "ecs_service_desired_count" {
	default = 0
}

variable "service_health_check_path" {
  default = "/"
}

variable "service_health_check_code" {
  default = 200
}

variable "dns_zone_id" {
  description = "VPC DNS Zone Id"
}

variable "dns_zone_name" {
  description = "DNS Zone Name"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
}

variable "docker_memory_limit" {
  default = 512
}

variable "docker_cpu_limit" {
  default = 1024
}

variable "docker_env_vars" {
  type    = "map"
  default = {}
}

variable "ecs_task_env_vars" {
  default = {a = "b"}
}

variable "ecs_task_default_env_vars" {
  type    = "map"
  default = {}
}

variable "listener_http_arn" {
}

variable "listener_https_arn" {
}

variable "alb_rule_priority" {
 default = 100
}

variable "task_role_arn" {
  default = ""
}
