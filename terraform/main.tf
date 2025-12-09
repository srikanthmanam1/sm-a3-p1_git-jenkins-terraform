#------------------------------------------------------------
# main.tf
#------------------------------------------------------------
locals {
  use_a = var.ch == 1
  use_b = var.ch == 2
}

module "Mod_EC2_Server" {
  source = "./modules/ec2"

  #mod_instance_name = "Main_EC2_P0A"
  #mod_instance_type = var.instance_type
  #mod_instance_type = "t2.large"

  # Only create if chosen 
  count = local.use_a ? 1 : 0

}

module "Mod_ECx_Server" {
  source = "./modules/ecx"

  #mod_instance_name = "Main_EC2_P0B"
  #mod_instance_type = var.instance_type
  #mod_instance_type = "t3.large"

  # Only create if chosen 
  count = local.use_b ? 1 : 0

}
