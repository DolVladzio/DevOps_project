#########################################################################
# Resources
#########################################################################
resource "aws_vpc" "HW_03_vpc" {
	cidr_block           = "10.0.0.0/16"
	enable_dns_support   = true
	enable_dns_hostnames = true

	tags = {
			Name = "${var.DEV}_vpc"
	}
	}

	resource "aws_subnet" "HW_03_subnet" {
	vpc_id            = aws_vpc.HW_03_vpc.id
	cidr_block        = "10.0.1.0/24"
	availability_zone = "eu-west-1a"
	map_public_ip_on_launch = true

	tags = {
		Name = "${var.DEV}_subnet"
	}
}
#########################################################################
resource "aws_security_group" "HW_03_security_group" {
	name        = "example-sg"
	description = "Allow SSH and HTTP"
	vpc_id      = aws_vpc.HW_03_vpc.id

	ingress {
			from_port   = 22
			to_port     = 22
			protocol    = "tcp"
			cidr_blocks = ["176.117.188.172/32"]
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
resource "aws_key_pair" "HW_03_key_pair" {
	key_name   = var.SSH_KEY_NAME
	public_key = file("~/.ssh/terraform-aws.pem.pub")
}
#########################################################################
resource "aws_internet_gateway" "HW_03_igw" {
	vpc_id = aws_vpc.HW_03_vpc.id
}
#########################################################################
resource "aws_route_table" "HW_03_route_table" {
	vpc_id = aws_vpc.HW_03_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.HW_03_igw.id
	}
}
#########################################################################
resource "aws_route_table_association" "HW_03_route_table_association" {
	subnet_id      = aws_subnet.HW_03_subnet.id
	route_table_id = aws_route_table.HW_03_route_table.id
}
#########################################################################
resource "aws_instance" "HW_03_instance" {
	ami           = var.AMI_ID
	instance_type = var.INSTANCE_TYPE
	subnet_id     = aws_subnet.HW_03_subnet.id
	key_name      = aws_key_pair.HW_03_key_pair.key_name
	security_groups = [aws_security_group.HW_03_security_group.id]
	associate_public_ip_address = true

	tags = {
		Name = "${var.DEV}_instance"
	}
}
#########################################################################
