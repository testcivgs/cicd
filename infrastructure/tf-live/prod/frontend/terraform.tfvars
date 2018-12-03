terragrunt = {
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
    paths = [
      "../vpc",
      "../ecs-cluster",
      "../../global/ecs_repository",
      "../../global/vars",
      "../balancer"
    ]
  }
}
