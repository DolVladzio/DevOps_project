#########################################################################
# Resources
#########################################################################
resource "azurerm_resource_group" "HW_03_resource_group" {
	name     = var.RESOURCE_GROUP_NAME
	location = var.LOCATION
}
#########################################################################
resource "azurerm_virtual_network" "HW_03_virtual_network" {
	name                = "${var.DEV}_virtual_network"
	location            = azurerm_resource_group.HW_03_resource_group.location
	resource_group_name = azurerm_resource_group.HW_03_resource_group.name
	address_space       = ["10.0.0.0/16"]
}
#########################################################################
resource "azurerm_subnet" "HW_03_subnet" {
	name                 = "${var.DEV}_subnet"
	resource_group_name  = azurerm_resource_group.HW_03_resource_group.name
	virtual_network_name = azurerm_virtual_network.HW_03_virtual_network.name
	address_prefixes     = ["10.0.1.0/24"]
}
#########################################################################
resource "azurerm_public_ip" "HW_03_public_ip" {
	name                = "${var.DEV}_ip"
	location            = azurerm_resource_group.HW_03_resource_group.location
	resource_group_name = azurerm_resource_group.HW_03_resource_group.name
	allocation_method   = "Static"
	sku                 = "Standard"
}
#########################################################################
resource "azurerm_network_interface" "HW_03_network_interface" {
	name                = "${var.DEV}_network_interface"
	location            = azurerm_resource_group.HW_03_resource_group.location
	resource_group_name = azurerm_resource_group.HW_03_resource_group.name

	ip_configuration {
		name                          = "internal"
		subnet_id                     = azurerm_subnet.HW_03_subnet.id
		private_ip_address_allocation = "Dynamic"
		public_ip_address_id		  = azurerm_public_ip.HW_03_public_ip.id
	}
}
#########################################################################
resource "azurerm_network_security_group" "HW_03_nsg" {
	name                = "${var.DEV}_security_group"
	location            = azurerm_resource_group.HW_03_resource_group.location
	resource_group_name = azurerm_resource_group.HW_03_resource_group.name

	security_rule {
		name                       = "Allow-SSH"
		priority                   = 100
		direction                  = "Inbound"
		access                     = "Allow"
		protocol                   = "Tcp"
		source_port_range          = "*"
		destination_port_range     = "22"
		source_address_prefix      = "*"
		destination_address_prefix = "*"
	}
}
#########################################################################
resource "azurerm_linux_virtual_machine" "HW_03_virtual_machine" {
	name                  = "${var.DEV}_vm"
	resource_group_name   = azurerm_resource_group.HW_03_resource_group.name
	location              = azurerm_resource_group.HW_03_resource_group.location
	size                  = var.VM_SIZE
	admin_username        = var.ADMIN_USERNAME
	network_interface_ids = [azurerm_network_interface.HW_03_network_interface.id]
	computer_name = "hw03wm"

	admin_ssh_key {
		username   = var.ADMIN_USERNAME
		public_key = file(var.PUBLIC_SSH_KEY)
	}

	os_disk {
		caching              = "ReadWrite"
		storage_account_type = "Standard_LRS"
	}

	source_image_reference {
		publisher = "Canonical"
		offer     = "UbuntuServer"
		sku       = "18.04-LTS"
		version   = "latest"
	}
}
#########################################################################
