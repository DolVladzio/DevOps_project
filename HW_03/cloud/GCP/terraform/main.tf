#########################################################################
# MODULES
#########################################################################
locals {
	config = jsondecode(file("${path.module}/../../config.json"))

	region = local.config.project.repository_location_gcp
}
#########################################################################
module "network" {
	source = "./modules/network"
	region = local.region
	acls = local.config.networks
	network = local.config.network
	security_groups = local.config.security_groups
}
#########################################################################
