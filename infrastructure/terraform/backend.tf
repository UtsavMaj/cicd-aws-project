# infrastructure/terraform/backend.tf
terraform {
  backend "s3" {
    bucket         = "cicd-tf-state-kushagra"   # change to your name
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}