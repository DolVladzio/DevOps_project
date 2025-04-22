#########################################################################
# Variables
#########################################################################
variable "AWS_REGION" {
	description = "AWS region"
	default     = "eu-west-1"
}
#----------------------------------------------------
variable "DEV" {
	description = "AWS instance's name"
	default     = "HW_03_instance"
}
#----------------------------------------------------
variable "INSTANCE_TYPE" {
	description = "AWS instance's type"
	default     = "t2.micro"
}
#----------------------------------------------------
variable "AMI_ID" {
	description = "The AMI ID for the EC2 instance"
	default     = "ami-0f0c3baa60262d5b9"
}
#----------------------------------------------------
