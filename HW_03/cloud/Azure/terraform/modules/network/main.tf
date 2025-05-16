#########################################################################
# RESOURCES
#########################################################################
locals {
	# Create a map of VPC name to VPC for easier lookup
	vpcs_map = { for vpc in var.network : vpc.name => vpc }
}
#########################################################################
resource "azurerm_resource_group" "example" {
	name     = var.resource_group_name
	location = var.location
}
#########################################################################
resource "azurerm_virtual_network" "example" {
	for_each			= local.vpcs_map
	
	name                = each.value.name
	resource_group_name = azurerm_resource_group.example.name
	location            = azurerm_resource_group.example.location
	address_space       = [each.value.vpc_cidr]
}
#########################################################################
resource "azurerm_subnet" "example" {
	for_each = {
		for subnet_data in flatten([
		for vpc in var.network : [
			for subnet in vpc.subnets : {
			vpc_name    = vpc.name
			subnet_name = subnet.name
			cidr        = subnet.cidr
			}
		]
		]) : "${subnet_data.vpc_name}-${subnet_data.subnet_name}" => subnet_data
	}

	name                 = each.value.subnet_name
	address_prefixes     = [each.value.cidr]
	resource_group_name  = azurerm_resource_group.example.name
	virtual_network_name = azurerm_virtual_network.example[each.value.vpc_name].name
}
#########################################################################
