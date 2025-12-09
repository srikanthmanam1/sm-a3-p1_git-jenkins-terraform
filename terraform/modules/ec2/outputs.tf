output "mod_inst_pub_ip1" {
  description = "Public IP of the Mod EC2 instance"
  value       = aws_instance.mod_instance.public_ip
}

output "mod_inst_id1" {
  description = "Id of the Mod EC2 instance"
  value       = aws_instance.mod_instance.id
}
