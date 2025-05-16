#########################################################################
# VARIABLES
#########################################################################
variable "region" {}
#########################################################################
variable "project_id" {}
#########################################################################
variable "private_networks" {
	description = "Map of network name to VPC self-link"
}
#########################################################################
variable "subnet_self_links" {
	description = "Map of subnet name to self-link"
}
#########################################################################
variable "database" {
	type = list(object({
		name = string
		network = string
		type = string
		version = string
		size = string
		zone = list(string)
		subnets = list(string)
		port = number
		security_groups = list(string)
	}))
}
#########################################################################
