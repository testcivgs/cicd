
variable "peer_owner_id" {
  description = "The AWS account ID of the owner of the peer VPC."
}

variable "vpc_id" {
  description = "The ID of the VPC with which you are creating the VPC Peering Connection."
}

variable "peer_vpc_id" {
  description = "The ID of the requester VPC."
}

variable "auto_accept" {
  description = "Accept the peering (both VPCs need to be in the same AWS account)."
  default     = true
}

variable "vpc_peering_tags" {
  description = "A mapping of tags to assign to the resource."
  default = {}
}

variable "vpc_route_table_ids" {
  description = "The list of route table IDs of the VPC with which you are creating the VPC Peering Connection."
  default = []
}

variable "vpc_route_table_count" {
  description = "The count of route table IDs of the VPC with which you are creating the VPC Peering Connection."
}

variable "peer_vpc_route_table_ids" {
  description = "The list of route table IDs of the requester VPC."
  default = []
}

variable "peer_vpc_route_table_count" {
  description = "The count of route table IDs of the requester VPC."
}

variable "vpc_destination_cidr_block" {
  description = "CIDR block / IP range of the requester VPC."
}

variable "peer_vpc_destination_cidr_block" {
  description = "CIDR block / IP range of the VPC with which you are creating the VPC Peering Connection."
}