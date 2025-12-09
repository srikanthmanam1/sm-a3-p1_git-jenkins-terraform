output "mod_inst_pub_ip2" {
  description = "Public IP of the Mod EC2_x instance"
  value       = aws_instance.mod_instance.public_ip
}

output "mod_inst_id2" {
  description = "Id of the Mod EC2_x instance"
  value       = aws_instance.mod_instance.id
}
