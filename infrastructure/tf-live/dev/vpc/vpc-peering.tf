
module "vpc_peering_mgmt_to_dev" {
  source = "../../../tf-modules/aws_vpc_peering"

  peer_owner_id                   = "${data.aws_caller_identity.current.account_id}"
  vpc_id                          = "${data.terraform_remote_state.mgmt.vpc_id}"
  peer_vpc_id                     = "${module.vpc.vpc_id}"
  auto_accept                     = true
  vpc_destination_cidr_block      = "${module.vpc.vpc_cidr_block}"
  peer_vpc_destination_cidr_block = "${data.terraform_remote_state.mgmt.vpc_cidr_block}"

  vpc_peering_tags                = {
        "Name" = "VPC Peering between MGMT and ${var.environment}"
  }

  // Count = 1 route table per private subnet + 1 route table for all public subnets
  vpc_route_table_count           = "${length(data.terraform_remote_state.vars.mgmt_private_subnets) + 1}"
  vpc_route_table_ids             = [
        "${data.terraform_remote_state.mgmt.private_route_table_ids}",
        "${data.terraform_remote_state.mgmt.public_route_table_ids}"
  ]

  // Count = 1 route table per private subnet + 1 route table for all public subnets
  peer_vpc_route_table_count      = "${length(data.terraform_remote_state.vars.dev_private_subnets) + 1}"
  peer_vpc_route_table_ids        = [
        "${module.vpc.public_route_table_ids}",
        "${module.vpc.private_route_table_ids}"
  ]
}
