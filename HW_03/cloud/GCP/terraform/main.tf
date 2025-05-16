#########################################################################
# MODULES
#########################################################################
data "google_secret_manager_secret_version_access" "db_username" {
	secret  = "db_username"
	version = "latest"
}
#########################################################################
data "google_secret_manager_secret_version_access" "db_password" {
	secret  = "db_pass"
	version = "latest"
}
#########################################################################
locals {
	config = jsondecode(file("${path.module}/../../config.json"))

	region = local.config.project.repository_location_gcp

	db_username = data.google_secret_manager_secret_version_access.db_username.secret
	db_password = data.google_secret_manager_secret_version_access.db_password.secret
}
#########################################################################
module "network" {
	source = "./modules/network"
	project_id = var.project_id
	region = local.region
	acls = local.config.networks
	network = local.config.network
	security_groups = local.config.security_groups
}
#########################################################################
module "vm" {
	source = "./modules/vm"
	project_id = var.project_id
	region = local.region
	vm_instances = local.config.security_groups
	subnet_self_links_map = module.network.subnet_self_links_by_name
	project_os = local.config.project.os

	depends_on = [ module.network ]
}
#########################################################################
module "db_instance" {
	source = "./modules/db_instance"
	project_id = var.project_id
	region = local.region
	database = local.config.databases
	private_networks = module.network.vpc_self_links
	subnet_self_links = module.network.subnet_self_links_by_name
	db_pass = local.db_password
	db_username = local.db_username
	
	depends_on       = [module.network]
}
#########################################################################
