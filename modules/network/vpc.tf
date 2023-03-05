resource "aws_vpc" "myvpc" {
  cidr_block         = var.vpc_cidr
  enable_dns_support = "false"

  tags = {
     Name: "${var.env_prefix}-vpc"
  }
}
