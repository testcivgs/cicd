
# AWS VPC peering between VPC 1 and 2
resource "aws_vpc_peering_connection" "primary2secondary" {

  vpc_id        = "${var.vpc_id}"
  peer_owner_id = "${var.peer_owner_id}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  auto_accept   = "${var.auto_accept}"

  tags          = "${merge(var.vpc_peering_tags)}"
}

# Route from VPC 1 to 2
resource "aws_route" "primary2secondary" {
  count                     = "${var.vpc_route_table_count}"
  route_table_id            = "${element(var.vpc_route_table_ids, count.index)}"
  destination_cidr_block    = "${var.vpc_destination_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
}

# Route from VPC 2 to 1
resource "aws_route" "secondary2primary" {
  count                     = "${var.peer_vpc_route_table_count}"
  route_table_id            = "${element(var.peer_vpc_route_table_ids, count.index)}"
  destination_cidr_block    = "${var.peer_vpc_destination_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.primary2secondary.id}"
}
