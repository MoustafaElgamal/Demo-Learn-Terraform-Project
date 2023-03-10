variable "vpc_cidr" {
  type = string
}

variable "public_subnet_1_cidr" {
  type = string
}

variable "public_subnet_2_cidr" {
  type = string
}

variable "private_subnet_1_cidr" {
  type = string
}

variable "private_subnet_2_cidr" {
  type = string
}

variable "region_id" {
  type = string
}

variable "region_subnet_1_id" {
  type = string
}

variable "region_subnet_2_id" {
  type = string
}

variable "env_prefix" {
  type = string
}

variable "my_ip" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "public_key_location" {
  type = string
}

variable "image_name" {
  type = string
}

variable "image_name_owner" {
  type = string
}

variable "db_instance" {
  type = string
}

variable "all_ips_cidr" {
  type = string
}

variable "rds_db_identifier" {
  type = string
}

variable "rds_db_name" {
  type = string
}

variable "rds_db_username" {
  type = string
}

variable "rds_db_password" {
  type = string
}

variable "rds_db_engine" {
  type = string
}

variable "rds_db_engine_version" {
  type = string
}

variable "rds_db_storage_type" {
  type = string
}