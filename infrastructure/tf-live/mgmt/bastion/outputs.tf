
output "public_ip" {
  value = "${aws_eip.bastion_eip.public_ip}"
}
