#------------------------------------------------------------
# outputs.tf
#------------------------------------------------------------
output "inst_public_ip1" {
  description = "Public IP address of the EC2 instance"
  value       = local.use_a ? module.Mod_EC2_Server[0].mod_inst_pub_ip1 : null
  # Only create if chosen 
  # count = local.use_a ? 1 : 0
}

output "inst_id1" {
  description = "ID of the EC2 instance"
  value       = local.use_a ? module.Mod_EC2_Server[0].mod_inst_id1 : null
  # Only create if chosen 
  # count = local.use_a ? 1 : 0
}


output "inst_public_ip2" {
  description = "Public IP address of the EC2 instance"
  value       = local.use_b ? module.Mod_ECx_Server[0].mod_inst_pub_ip2 : null
  # Only create if chosen 
  # count = local.use_b ? 1 : 0
}

output "inst_id2" {
  description = "ID of the EC2 instance"
  value       = local.use_b ? module.Mod_ECx_Server[0].mod_inst_id2 : null
  # Only create if chosen 
  # count = local.use_b ? 1 : 0
}
