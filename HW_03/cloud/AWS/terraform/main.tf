#########################################################################
# Resources
#########################################################################
locals {
	config = jsondecode(file("${path.module}/../../config.json"))
	region = local.config.project.state_bucket_location_aws
}
#########################################################################
module "network" {
	source = "./modules/network"
	region = local.region
	vpcs = local.config.network
}
#########################################################################
module "security_groups" {
	source = "./modules/security_groups"
	security_groups = local.security_groups
	networks_by_name = local.networks_by_name
	vpc_ids_by_name  = module.network.vpc_ids_by_name
}
#########################################################################
module "vms" {
	source = "./modules/vms"
}
#########################################################################
module "db" {
	source = "./modules/database"
}
#########################################################################
