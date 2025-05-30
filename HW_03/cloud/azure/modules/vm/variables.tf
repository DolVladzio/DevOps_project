variable "location_azurerm" {}

variable "resource_group_name_azurerm" {}

variable "ssh_keys" {}

variable "vm_instances" {
	description = "List of VM instances with their configurations"
	type = list(object({
		name             = string
		zone             = string
		tags             = list(string)
		public_ip        = bool
		port             = number
		security_groups  = list(string)
		allocation_method = string
		ip_configuration_name = string
		private_ip_address_allocation = string
		size = string
		os_image = list(object({
			publisher = string
			offer     = string
			sku       = string
			version   = string
		}))
		os_disk = list(object({
			caching               = string
			storage_account_type = string
		}))
	}))
}

variable "hostname" {}

variable "terraform_username" {}

variable "azurerm_subnet" {}

variable "nsg_ids" {}

variable "vm_instances_size_map" {
	description = "List of VM image sizes"
	type = list(object({
		small = string
		medium = string
		large = string
	}))
}