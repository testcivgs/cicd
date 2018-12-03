terragrunt = {
  include = {
    path = "${find_in_parent_folders()}"
  }

  dependencies {
  	paths = [
      "../vpc",
      "../../global/aws_key_pair"
    ]
  }
}
