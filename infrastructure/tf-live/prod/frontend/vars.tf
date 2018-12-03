variable "service_hostname" {
  default = "www"
}

variable "frontend_docker_tag" {
  default = "latest"
}

variable "frontend_desired_count" {
	default = 0
}

variable "frontend_container_port"  {
  default = 80
}

variable "frontend_health_check_path" {
  default = "/health"
}

variable "frontend_health_check_code" {
  default = 200
}
