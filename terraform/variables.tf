#------------------------------------------------------------
# variables.tf
#------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to launch resources in"
  type        = string
  default     = "us-east-2"
}

/*variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
  #default     = "t3.medium"
}*/


