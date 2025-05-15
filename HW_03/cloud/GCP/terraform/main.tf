#########################################################################
# MODULES
#########################################################################
locals {
	config = jsondecode(file("${path.module}/../../config.json"))
}
#########################################################################
module "network" {
	source = "./modules/network"
	project_id = var.project_id
	region = local.config.project.repository_location_gcp
	acls = local.config.networks
	network = local.config.network
	security_groups = local.config.security_groups
}
#########################################################################
