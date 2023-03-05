provider "aws" {
  region = var.region_id
}


module "myapp_bastion_host" {
  source = "./modules/bastion"

  vpc_id              = module.myapp_network.vpc_id
  my_ip               = var.my_ip
  all_ips_cidr        = var.all_ips_cidr
  image_name_owner    = var.image_name_owner
  image_name          = var.image_name
  public_key_location = var.public_key_location
  ec2_instance_type   = var.ec2_instance_type
  public1_subnet_id   = module.myapp_network.public1_subnet_id
  region_subnet_1_id  = var.region_subnet_1_id
  env_prefix          = var.env_prefix
}

module "myapp_database" {
  source = "./modules/database"

  rds_db_identifier     = var.rds_db_identifier
  rds_db_name           = var.rds_db_name
  rds_db_username       = var.rds_db_username
  rds_db_password       = var.rds_db_password
  rds_db_engine         = var.rds_db_engine
  db_instance           = var.db_instance
  region_subnet_1_id    = var.region_subnet_1_id
  private_subnet_1_id   = module.myapp_network.private1_subnet_id
  private_subnet_2_id   = module.myapp_network.private2_subnet_id
  vpc_id                = module.myapp_network.vpc_id
  all_ips_cidr          = var.all_ips_cidr
  region_subnet_2_id    = var.region_subnet_2_id
  rds_db_storage_type   = var.rds_db_storage_type
  rds_db_engine_version = var.rds_db_engine_version
}

module "myapp_network" {
  source = "./modules/network"

  vpc_cidr              = var.vpc_cidr
  all_ips_cidr          = var.all_ips_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  region_subnet_1_id    = var.region_subnet_1_id
  region_subnet_2_id    = var.region_subnet_2_id
  env_prefix            = var.env_prefix
}

module "myapp_webserver" {
  source = "./modules/webserver"

  vpc_id                = module.myapp_network.vpc_id
  all_ips_cidr          = var.all_ips_cidr
  my_ip                 = var.my_ip
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  env_prefix            = var.env_prefix
  image_name_owner      = var.image_name_owner
  image_name            = var.image_name
  ec2_instance_type     = var.ec2_instance_type
  private1_subnet_id    = module.myapp_network.private1_subnet_id
  private2_subnet_id    = module.myapp_network.private2_subnet_id
}