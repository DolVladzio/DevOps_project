#########################################################################
# RESOURCES
#########################################################################
locals {
	# Create a map of VPC name to VPC for easier lookup
	vpcs_map = { for vpc in var.network : vpc.name => vpc }
}
#########################################################################
resource "azurerm_resource_group" "default" {
	name     = var.resource_group_name
	location = var.location
}
#########################################################################
resource "azurerm_virtual_network" "example" {
	for_each			= local.vpcs_map
	
	name                = each.value.name
	resource_group_name = azurerm_resource_group.default.name
	location            = azurerm_resource_group.default.location
	address_space       = [each.value.vpc_cidr]
}
#########################################################################
