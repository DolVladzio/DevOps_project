#########################################################################
# VARIABLES
#########################################################################
variable "region" {}
#########################################################################
variable "project_id" {}
#########################################################################
variable "vm_instances" {
	type = list(object({
		name = string
		network = string
		size = string
		zone = string
		subnet = string
		tags = list(string)
		public_ip = bool
		port = number
		security_groups = optional(list(string), [])
	}))
	description = "List of VMs (from config.json)"
}
#########################################################################
variable "subnet_self_links_map" {}
#########################################################################
variable "project_os" {}
#########################################################################
