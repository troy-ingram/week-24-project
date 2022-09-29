# --- root/backend.tf ---

terraform {
  backend "s3" {
    bucket = "terraform-with-jenkins-23432"
    key    = "remote.tfstate"
    region = "us-east-1"
  }
}
