# Configure Terragrunt to automatically store tfstate files in an S3 bucket
terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket     = "ce-tf-remote-state-storage"
      key        = "${path_relative_to_include()}/terraform.tfstate"
      region     = "eu-central-1"
      encrypt    = true
      dynamodb_table = "terragrunt_locks"
    }
  }
}
