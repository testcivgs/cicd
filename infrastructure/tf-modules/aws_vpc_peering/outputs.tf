output "aws_vpc_peering_connection_id" {
  value = "${aws_vpc_peering_connection.primary2secondary.id}"
}
