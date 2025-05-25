locals {
	config = jsondecode(file("${path.module}/../config.json"))
}

module "vm" {
	source = "./modules/vm"
	azurerm_resource_group = azurerm_resource_group.main
	ssh_keys = local.config.project.ssh_keys
	vm_instances = local.config.vm_instances
	username = local.config.project.os
	admin_username = local.config.project.terraform_username
}
