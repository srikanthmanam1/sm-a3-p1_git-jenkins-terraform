variable "mod_instance_name" {
  description = "Mod EC2 instance Tag name"
  type        = string
  default     = "Mod_EC2_P1"
}

variable "mod_instance_type" {
  description = "Mod EC2 instance type"
  type        = string
  #default     = "t2.micro"
  default     = "t3.medium"
}

variable "mod_ami_id" {
  description = "OS -- Ubuntu 22.04"
  type        = string
  default     = "ami-0c5ddb3560e768732" # Ubuntu 22.04 (us-east-2)
}
