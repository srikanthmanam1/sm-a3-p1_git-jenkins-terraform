module "Mod_EC2_Server" {
  source = "./modules/ec2"

  mod_instance_name = "Main_EC2_P0"
  #mod_instance_type = var.instance_type
  mod_instance_type = "t2.micro"
}
