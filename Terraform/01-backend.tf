# Backend for the Terraform state file
terraform {
  backend "gcs" {
    bucket = "sovereign_1"
    prefix = "terraform/state"
  }
}