terraform {
  backend "s3" {
    bucket         = "fluxdeploy-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "fluxdeploy-terraform-lock"
    encrypt        = true
  }
}