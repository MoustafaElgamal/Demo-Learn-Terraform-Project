terraform {
  backend "s3" {
    bucket         = "demo-learn-terraform-project-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "Demo_Learn_Terraform_Project"
  }
}
