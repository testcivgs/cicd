variable "name" {
  default = "bastion"
}

variable "ami" {
  description = "AWS AMI. Default: Ubuntu Server 16.04 LTS (HVM), SSD Volume Type"
  default = "ami-df8406b0"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "user_data_file" {
  default = "user-data.sh"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "subnet_ids" {
  default     = []
  description = "A list of subnet ids"
}

variable "associate_public_ip_address" {
  default = false
}

variable "aws_route53_zone_id" {
  default = ""
}

variable "role" {
  default = "bastion,openvpn"
}