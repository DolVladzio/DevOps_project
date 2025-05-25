variable "azurerm_resource_group" {}

variable "ssh_keys" {}

variable "vm_instances" {
	type = list(object({
		name            = string
		network         = string
		size            = string
		zone            = string
		subnet          = string
		tags            = set(string)
		port            = number
		security_groups = optional(list(string), [])
		public_ip       = bool
	}))
	description = "List of VMs (from config.json)"
}

variable "username" {}

variable "terraform_username" {}
