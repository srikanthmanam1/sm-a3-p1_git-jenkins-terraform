#------------------------------------------------------------
#main.tf
#------------------------------------------------------------
# Use existing VPC
data "aws_vpc" "sm_vpc" {
  filter {
    name   = "tag:Name"
    values = ["sm-vpc1"]
  }
}

# Use existing subnet
data "aws_subnet" "sm_subnet" {
  filter {
    name   = "tag:Name"
    values = ["sm-subnet1"]
  }
}

# Use existing Security Group
data "aws_security_group" "sm_sg" {
  filter {
    name   = "group-name"
    values = ["sm-sg1_ssh_http_s"]
  }

  vpc_id = data.aws_vpc.sm_vpc.id
}

# Use existing Internet Gateway
data "aws_internet_gateway" "sm_igw" {
  filter {
    name   = "tag:Name"
    values = ["sm-igw1"]
  }
}

# Use existing Route Table
data "aws_route_table" "sm_route_table" {
  filter {
    name   = "tag:Name"
    values = ["sm-route-table1"]
  }
}

# Create an EC2 instance
resource "aws_instance" "sm_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.sm_subnet.id
  vpc_security_group_ids = [data.aws_security_group.sm_sg.id]
  associate_public_ip_address = true  # <--- Ensures a public IP is assigned for instance. Overrides subnet setting

  tags = {
    Name = "sm-ec2-tf-ex2"
  }
}
