#------------------------------------------------------------
# outputs.tf
#------------------------------------------------------------
#output "instance_public_ip" {
#  description = "Public IP address of the EC2 instance"
#  value       = aws_instance.sm_ec2_instance.public_ip
#}

#output "instance_id" {
#  description = "ID of the EC2 instance"
#  value       = aws_instance.sm_ec2_instance.id
#}


output "inst_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.Mod_EC2_Server.mod_inst_pub_ip
}

output "inst_id" {
  description = "ID of the EC2 instance"
  value       = module.Mod_EC2_Server.mod_inst_id
}
