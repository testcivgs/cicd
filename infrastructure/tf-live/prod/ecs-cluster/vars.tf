
// http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
variable "ecs_ami" {
  description = "AWS ECS Optimized AMI."
  default = "ami-eacf5d85"
}

variable "ecs_instance_type" {
  description = "Instance Type"
  default = "t2.medium"
}

variable "ecs_instance_size" {
  description = "ECS cluster desired capacity"
  default = "1"
}

variable "ecs_instance_size_min" {
  description = "ECS cluster min capacity"
  default = "1"
}

variable "ecs_instance_size_max" {
  description = "ECS cluster max capacity"
  default = "5"
}
