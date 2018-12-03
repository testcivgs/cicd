
variable "is_internal" {
  description = "whether to deploy balancer in internal subnet."
  default     = true
}

variable "service_listener_port" {
  default = 80
}

variable "service_listener_port_ssl" {
  default = 443
}

variable "balancer_idle_timeout" {
  default = 600
}
