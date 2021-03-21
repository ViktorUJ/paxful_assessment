output "vpc_id" {
  value = aws_vpc.default.id
}
output "image_id" {
  value = data.aws_ami.debian.id
}
output "subnets" {
  value = local.subnet_ids
}
output "subnet_db_master" {
  value = local.subnet_db_master
}

output "app" {
  value = aws_eip.app.public_ip
}
output "db_master" {
  value = aws_eip.db_master.public_ip
}

output "db_slave" {
  value = aws_eip.db_slave.public_ip
}
output "db_user_name" {
  value = random_string.db_user_name.result
}
output "db_user_password" {
  value = random_string.db_user_password.result
}
output "db_name" {
  value = random_string.db_db_name.result
}



output "connect_db_master" {
  value = "       ssh ${var.ec2.user_name}@${aws_eip.db_master.public_ip} -i ${local.ssh_key_name}         "
}

output "connect_app" {
  value = "       ssh ${var.ec2.user_name}@${aws_eip.app.public_ip} -i ${local.ssh_key_name}         "
}
  output "connect_db_slave" {
  value = "       ssh ${var.ec2.user_name}@${aws_eip.db_slave.public_ip} -i ${local.ssh_key_name}         "
}

  output "connect_mailer" {
  value = "  check email      http://${aws_eip.app.public_ip}:9099         "
}
