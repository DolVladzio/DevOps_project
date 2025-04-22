#########################################################################
# Resources 
#########################################################################
resource "aws_vpc" "example" {
	cidr_block           = "10.0.0.0/16"
	enable_dns_support   = true
	enable_dns_hostnames = true

	tags = {
		Name = "${var.DEV}-vpc"
	}
	}

	resource "aws_subnet" "example" {
	vpc_id            = aws_vpc.example.id
	cidr_block        = "10.0.1.0/24"
	availability_zone = "eu-west-1a"

	tags = {
		Name = "${var.DEV}-subnet"
	}
}
#########################################################################
resource "aws_security_group" "example" {
	name        = "example-sg"
	description = "Allow SSH and HTTP"
	vpc_id      = aws_vpc.example.id

	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}
#########################################################################
resource "aws_instance" "example" {
	ami           = var.AMI_ID
	instance_type = var.INSTANCE_TYPE
	subnet_id     = aws_subnet.example.id
	security_groups = [aws_security_group.example.id]

	tags = {
		Name = "${var.DEV}-instance"
	}
}
#########################################################################
