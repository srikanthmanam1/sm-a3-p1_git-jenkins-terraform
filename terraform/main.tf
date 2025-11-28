#------------------------------------------------------------
#main.tf
#------------------------------------------------------------

# Create a VPC
resource "aws_vpc" "sm_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true	# To ensure to have Public DNS 
  enable_dns_hostnames = true	# To ensure to have Public DNS 
  tags = {
    Name = "sm-vpc1"
  }
}

# Create a subnet
resource "aws_subnet" "sm_subnet" {
  vpc_id                  = aws_vpc.sm_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true	# To ensure to have Public ip

  tags = {
    Name = "sm-subnet1"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "sm_igw" {
  vpc_id = aws_vpc.sm_vpc.id
  tags = {
    Name = "sm-igw1"
  }
}

# Create a route table
resource "aws_route_table" "sm_route_table" {
  vpc_id = aws_vpc.sm_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sm_igw.id
  }

  tags = {
    Name = "sm-route-table1"
  }
}

# Associate subnet with route table
resource "aws_route_table_association" "sm_rt_association" {
  subnet_id      = aws_subnet.sm_subnet.id
  route_table_id = aws_route_table.sm_route_table.id
}

# Create a security group
resource "aws_security_group" "sm_sg" {
  name        = "sm-sg1_ssh_http_s" # security group name
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.sm_vpc.id

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
    Name = "sm-sg1-tag_ssh_http_s" # name of sg tag
  }
}

###############################
# IAM Role
###############################
resource "aws_iam_role" "sm_ec2_role" {
  name = "sm-ec2-role1"

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
# IAM Policy (EC2 + VPC Create)
###############################
#resource "aws_iam_policy" "sm_ec2_policy" {
#  name        = "sm-ec2-policy1"
#  description = "Allow EC2 instance to create/manage EC2 resources including VPC, subnets, IGW, route tables"

#  policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [
      # ---- EC2 Permissions ----
#      {
#        Effect = "Allow"
#        Action = [
#          "ec2:RunInstances",
#          "ec2:TerminateInstances",
#          "ec2:DescribeInstances",
#          "ec2:CreateTags",
#          "ec2:DescribeInstanceTypes",
#          "ec2:DescribeImages"
#        ]
#        Resource = "*"
#      },

      # ---- VPC / Subnet / IGW / Route Table Permissions ----
#      {
#        Effect = "Allow"
#        Action = [
#          "ec2:CreateVpc",
#          "ec2:DeleteVpc",
#          "ec2:ModifyVpcAttribute",
#          "ec2:DescribeVpcs",

#          "ec2:CreateSubnet",
#          "ec2:DeleteSubnet",
#          "ec2:DescribeSubnets",

#          "ec2:CreateInternetGateway",
#          "ec2:AttachInternetGateway",
#          "ec2:DetachInternetGateway",
#          "ec2:DeleteInternetGateway",
#          "ec2:DescribeInternetGateways",

#          "ec2:CreateRouteTable",
#          "ec2:DeleteRouteTable",
#          "ec2:AssociateRouteTable",
#          "ec2:DisassociateRouteTable",
#          "ec2:DescribeRouteTables",

#          "ec2:CreateRoute",
#          "ec2:ReplaceRoute",
#          "ec2:DeleteRoute"
#        ]
#        Resource = "*"
#      }
#    ]
#  })
#}

resource "aws_iam_policy" "sm_ec2_policy" {
  name        = "sm-ec2-policy1"
  description = "Full EC2 access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "ec2:*"
        Resource = "*"
      }
    ]
  })
}
###############################
# Attach Policy to Role
###############################
resource "aws_iam_role_policy_attachment" "sm_attach_ec2_role_policy" {
  role       = aws_iam_role.sm_ec2_role.name
  policy_arn = aws_iam_policy.sm_ec2_policy.arn
}

###############################
# Instance Profile
###############################
resource "aws_iam_instance_profile" "sm_ec2_instance_profile" {
  name = "sm-ec2-instance-profile1"
  role = aws_iam_role.sm_ec2_role.name
}

# Create an EC2 instance
resource "aws_instance" "sm_ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.sm_subnet.id
  vpc_security_group_ids = [aws_security_group.sm_sg.id]
  #associate_public_ip_address = true  # <--- Ensures a public IP is assigned for instance. Overrides subnet setting
  iam_instance_profile = aws_iam_instance_profile.sm_ec2_instance_profile.name

  #key_name      = var.key_name
  #user_data = file("sm0_update.sh")
  tags = {
    Name = "sm-ec2-tf-ex1"
  }
}
#https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_manage_delete.html
#https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_manage-delete-cli.html
