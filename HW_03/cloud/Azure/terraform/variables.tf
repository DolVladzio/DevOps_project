#########################################################################
# Variables
#########################################################################
variable "SUBSCRIPTION_ID" {
	description = "Subscription's id"
	default     = "2ff600aa-a32e-4a5a-b833-50b4c074258e"
}
#----------------------------------------------------
variable "RESOURCE_GROUP_NAME" {
	description = "Resource group name"
	default     = "Azure-group"
}
#----------------------------------------------------
variable "LOCATION" {
	description = "Location"
	default     = "East US"
}
#----------------------------------------------------
variable "DEV" {
	description = "AWS instance's name"
	default     = "HW_03"
}
#----------------------------------------------------
variable "VM_SIZE" {
	description = "VM's size"
	default     = "Standard_B1s"
}
#----------------------------------------------------
variable "ADMIN_USERNAME" {
	description = "Admin user's name"
	default     = "Azure-user"
}
#----------------------------------------------------
variable "PUBLIC_SSH_KEY" {
	description = "SSH's piblic key"
	default     = "~/.ssh/azure-key.pub"
}
#----------------------------------------------------
