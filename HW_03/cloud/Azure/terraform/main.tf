#########################################################################
# MODULES
#########################################################################
locals {
	config = jsondecode(file("${path.module}/../../config.json"))
}
#########################################################################
module "network" {
	source = "./modules/network"
	resource_group_name = local.config.project.name
	location = local.config.project.repository_location_azure
	network = local.config.network
}
#########################################################################
#module "vm" {
#	source = "./modules/vm"
#}
#########################################################################
# module "db_instance" {
# 	source = "./modules/db_instance"
# }
#########################################################################
