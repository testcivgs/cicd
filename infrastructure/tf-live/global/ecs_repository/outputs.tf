
output "frontend_repo_name" {
  value = "${aws_ecr_repository.frontend.name}"
}

output "frontend_repo_url" {
  value = "${aws_ecr_repository.frontend.repository_url}"
}
