terraform {
	required_providers {
		azurerm = {
			source  = "hashicorp/azurerm"
			version = "~>3.0"
		}
	}
	# backend "azurerm" {}
}

provider "azurerm" {
	features {}
}

resource "azurerm_resource_group" "main" {
	name     = "${local.config.project.name}-resource_group"
	location = local.config.project.state_bucket_location_azurerm
}
