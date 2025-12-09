resource "aws_instance" "mod_instance" {
  ami = var.mod_ami_id
  instance_type = var.mod_instance_type

  tags = {
    Name = var.mod_instance_name
  }
}
