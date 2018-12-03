variable "name" {
  default = "jenkins"
}

variable "ami" {
  description = "AWS AMI. Default: Ubuntu Server 16.04 LTS (HVM), SSD Volume Type"
  default = "ami-5055cd3f"
}

variable "instance_type" {
  default = "t2.small"
}

variable "user_data_file" {
  default = "user-data.sh"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "associate_public_ip_address" {
  default = false
}

variable "role" {
  default = "jenkins"
}
