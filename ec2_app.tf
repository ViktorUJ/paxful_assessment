resource "aws_instance" "app" {
  ami           = data.aws_ami.debian.id
  instance_type = var.app.instance_type
  subnet_id = local.subnet_app
  associate_public_ip_address = "true"
  user_data = file("template/user_data_app.sh")
  security_groups = [aws_security_group.app.id]
  key_name = aws_key_pair.key.key_name
  tags = {
	 Name = "${var.app_name}-app"
  }
   volume_tags = {
	 Name = "${var.app_name}-app"
  }
  root_block_device {
   volume_type= var.app.volume_type
   volume_size = var.app.volume_size
   delete_on_termination ="true"
   }

  lifecycle {
    ignore_changes = [
      security_groups,
      tags,
      user_data

    ]
  }

}

resource "aws_eip" "app" {
   vpc      = true
   instance = aws_instance.app.id
   tags =local.commmon_tags
}
