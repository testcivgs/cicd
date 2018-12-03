output "service_listener_http_arn" {
	value = "${aws_alb_listener.service_listener_http.arn}"
}

output "service_listener_https_arn" {
	value = "${aws_alb_listener.service_listener_https.arn}"
}

output "balancer_dns_name" {
	value = "${aws_alb.service_alb.dns_name}"
}

output "balancer_zone_id" {
	value = "${aws_alb.service_alb.zone_id}"
}
