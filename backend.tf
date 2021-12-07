# --- root/backend.tf ---

terraform {
  backend "s3" {
    bucket = "week-24-project-044"
    key    = "remote.tfstate"
    region = "ap-sUSouth-1"
  }
}
