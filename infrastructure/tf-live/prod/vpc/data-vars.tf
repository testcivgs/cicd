
# Export Global Variables
data "terraform_remote_state" "vars" {
  backend  = "s3"
  config {
    bucket = "ce-tf-remote-state-storage"
    key    = "global/vars/terraform.tfstate"
    region = "eu-central-1"
  }
}