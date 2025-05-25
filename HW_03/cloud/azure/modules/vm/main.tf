locals {
	size_map = {
		small  = "Standard_B1s"   # Basic VM for testing or small workloads
		medium = "Standard_B2ms"  # Medium-sized VM for general workloads
		large  = "Standard_D2s_v4" # Larger VM for more demanding applications
	}

	os_image = {
		publisher = "Canonical"
		offer     = "UbuntuServer"
		sku       = "20_04-lts"
		version   = "latest"
	}

	os_disk = {
		caching              = "ReadWrite"
		storage_account_type = "Standard_LRS"
	}
}

resource "azurerm_linux_virtual_machine" "main" {
	for_each = { for vm in var.vm_instances : vm.name => vm }

	name                = each.key
	location            = var.azurerm_resource_group.main.location
	resource_group_name = var.azurerm_resource_group.main.name
	zone = "${var.azurerm_resource_group.main.location}-${each.value.zone}"
	
	size                = local.size_map.small
	admin_username      = var.terraform_username
	
	network_interface_ids = [
		#...
	]

	os_disk {
		caching              = local.os_disk.caching
		storage_account_type = local.os_disk.storage_account_type
	}

	source_image_reference {
		publisher = local.os_image.publisher
		offer     = local.os_image.offer
		sku       = local.os_image.sku
		version   = local.os_image.version
	}

	admin_ssh_key {
		username   = var.username
		public_key = join("\n", var.ssh_keys)
	}

	tags = {
		name = "${each.value.name}-linux-vm"
	}
}
