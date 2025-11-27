#------------------------------------------------------------
# providers.tf
#------------------------------------------------------------
# Specify the provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

# Specify the provider and region
provider "aws" {
  region = var.aws_region
}
