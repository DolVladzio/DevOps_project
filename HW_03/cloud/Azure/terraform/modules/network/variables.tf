#########################################################################
# VARIABLES
#########################################################################
variable "resource_group_name" {}
#########################################################################
variable "location" {}
#########################################################################
variable "network" {
	type = list(object({
		name = string
		vpc_cidr = string
		subnets = list(object({
			name = string
			cidr = string
			public = bool
			zone = string
		}))
	}))
	description = "List of subnets with name, cidr, and whether public"
}
#########################################################################
