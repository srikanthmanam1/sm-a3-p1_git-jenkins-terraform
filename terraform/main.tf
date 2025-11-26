#------------------------------------------------------------
#main.tf
#------------------------------------------------------------
#------------------------------------------------------------
# Specify the provider and region
provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true	# To ensure to have Public DNS 
  enable_dns_hostnames = true	# To ensure to have Public DNS 
  tags = {
    Name = "sm-vpc1"
  }
}

# Create a subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true	# To ensure to have Public ip

  tags = {
    Name = "sm-subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sm-igw"
  }
}

# Create a route table
resource "aws_route_table" "rtable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "sm-route-table"
  }
}

# Associate subnet with route table
resource "aws_route_table_association" "assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rtable.id
}

# Create a security group
resource "aws_security_group" "allow_ssh" {
  name        = "sm-sg_ssh_http_s" # security group name
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sm-sg_ssh_http_s2" # name of sg tag
  }
}

###############################
# IAM Role
###############################
resource "aws_iam_role" "ec2_role" {
  name = "sm-ec2-create-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

###############################
# IAM Policy (allow EC2 creation)
###############################
resource "aws_iam_policy" "ec2_create_policy" {
  name        = "sm-ec2-create-policy"
  description = "Allow EC2 instance to create/manage EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstances",
          "ec2:CreateTags",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeImages"
        ]
        Resource = "*"
      }
    ]
  })
}

#resource "aws_iam_policy" "ec2_full_access" {
#  name        = "ec2-full-access-policy"
#  description = "Full EC2 access"

#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
#      {
#        Effect = "Allow"
#        Action = "ec2:*"
#        Resource = "*"
#      }
#    ]
#  })
#}
###############################
# Attach Policy to Role
###############################
resource "aws_iam_role_policy_attachment" "attach_ec2_create" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_create_policy.arn
}

###############################
# Instance Profile
###############################
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "sm-ec2-create-profile"
  role = aws_iam_role.ec2_role.name
}

# Create an EC2 instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  #associate_public_ip_address = true  # <--- Ensures a public IP is assigned for instance. Overrides subnet setting
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  key_name      = var.key_name
  #user_data = file("sm0_update.sh")
  tags = {
    Name = "sm-tf-ec2"
  }
}
#https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_manage_delete.html
#https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-delete-cli.html
