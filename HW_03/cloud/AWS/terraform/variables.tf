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
variable "KEY_PAIR_NAME" {
	description = "SSH key's name"
	default     = "aws_instance"
}
#----------------------------------------------------
variable "AMI_ID" {
	description = "The AMI ID for the EC2 instance"
	default     = "ami-0f0c3baa60262d5b9"
}
#----------------------------------------------------
variable "INSTANCE_TYPE" {
	description = "AWS instance's type"
	default     = "t2.micro"
}
#----------------------------------------------------
