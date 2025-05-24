terraform {
	required_providers {
		azurerm = {
			source  = "hashicorp/azurerm"
			version = "~>3.0"
		}
	}
	backend "azurerm" {}
}

provider "azurerm" {
	resource_provider_registrations = "none"
	features {}
}

resource "azurerm_resource_group" "state-demo-secure" {
	name     = "state-demo"
	location = "eastus"
}