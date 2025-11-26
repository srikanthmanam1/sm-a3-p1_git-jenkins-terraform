variable "aws_region" {
  description = "AWS region to launch resources in"
  default     = "us-east-2"
}

variable "instance_type" {
  description = "EC2 instance type"
//  default     = "t3.large"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "Ubuntu 22.04"
  default     = "ami-0c5ddb3560e768732" # Ubuntu 22.04 (us-east-2)
}

variable "key_name" {
  description = "Name of the existing AWS key pair"
  type        = string
}
