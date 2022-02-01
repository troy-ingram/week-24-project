# --- root/backend.tf ---

terraform {
  backend "s3" {
    bucket = "week-24-project-121"
    key    = "remote.tfstate"
    region = "us-east-1"
  }
}
