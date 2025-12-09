#------------------------------------------------------------
# variables.tf
#------------------------------------------------------------
variable "aws_region" {
  description = "AWS region to launch resources in"
  type        = string
  default     = "us-east-2"
}

variable "ch" {
  description = "Choice for EC2 or ECX: 1 or 2"
  type        = number
  default     = 2
  validation { 
     condition = var.ch == 1 || var.ch == 2 
     error_message = "selected_module must be either 1 or 2." 
  }
}

/*variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
  #default     = "t3.medium"
}*/
