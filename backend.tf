terraform {
  backend "s3" {
    bucket         = "demo-learn-terraform-project-state-bucket"
    key            = "terraform.tfstate"
    region         = var.region_id
    dynamodb_table = "Demo_Learn_Terraform_Project"
  }
}
