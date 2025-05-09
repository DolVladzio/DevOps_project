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
