#########################################################################
# OUTPUTS
#########################################################################
output "GCP_REGION" {
	value = local.region
}
### NETWORK #############################################################
output "subnet_self_links" {
	value = module.network.subnet_self_links
}
#########################################################################
output "subnet_self_links_by_name" {
	value = module.network.subnet_self_links_by_name
}
#########################################################################
output "vpc_self_links" {
	value = module.network.vpc_self_links
}
### VM ##################################################################
output "public_ips" {
	value = module.vm.public_ips
}
#########################################################################
output "private_ips" {
	value = module.vm.private_ips
}
### DB_INSTANCE #########################################################
output "instance_connection_names" {
	value = module.db_instance.instance_connection_names
}
#########################################################################
output "database_names" {
	value = module.db_instance.database_names
}
#########################################################################
