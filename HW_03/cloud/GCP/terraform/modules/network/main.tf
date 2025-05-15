#########################################################################
# RESOURCES
#########################################################################
locals {
	# map ACL name → cidr
	acls_map = { for a in var.acls : a.name => a.cidr }

	# Create a map of VPC name to VPC for easier lookup
	vpcs_map = { for vpc in var.network : vpc.name => vpc }

	# Create a map of security group name to the instances it's attached to
	sg_to_instances_map = { for sg in var.security_groups : sg.name => sg.attach_to }
}
#########################################################################
resource "google_compute_network" "vpc" {
	for_each                = local.vpcs_map
	name                    = "${each.key}-vpc"
	auto_create_subnetworks = false
}
#########################################################################
