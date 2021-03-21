
resource "null_resource" "servers_ready" {
  depends_on = [
   aws_instance.app,
   aws_instance.db_slave,
   aws_instance.db_master
   ]
   provisioner "local-exec" {
    when = create
    interpreter = ["/bin/bash","-c"]
    working_dir = path.module
    command= <<EOF
     echo 'app  ip =   ${aws_eip.app.public_ip}  wait ssh  '
     ssh -oStrictHostKeyChecking=no ${var.ec2.user_name}@${aws_eip.app.public_ip}  -i ${local.ssh_key_name}  >/dev/null 2>&1
     while test $? -gt 0
       do
        sleep 5 #
        echo "Trying again..."
        ssh -oStrictHostKeyChecking=no ${var.ec2.user_name}@${aws_eip.app.public_ip}   -i ${local.ssh_key_name}  >/dev/null 2>&1
       done

     echo 'db_master  ip =   ${aws_eip.db_master.public_ip}  wait ssh  '
     ssh -oStrictHostKeyChecking=no ${var.ec2.user_name}@${aws_eip.db_master.public_ip}  -i ${local.ssh_key_name}  >/dev/null 2>&1
     while test $? -gt 0
       do
        sleep 5 #
        echo "Trying again..."
        ssh -oStrictHostKeyChecking=no ${var.ec2.user_name}@${aws_eip.db_master.public_ip}   -i ${local.ssh_key_name}  >/dev/null 2>&1
       done

     echo 'db_slave  ip =   ${aws_eip.db_slave.public_ip}  wait ssh  '
     ssh -oStrictHostKeyChecking=no ${var.ec2.user_name}@${aws_eip.db_slave.public_ip}  -i ${local.ssh_key_name}  >/dev/null 2>&1
     while test $? -gt 0
       do
        sleep 5 #
        echo "Trying again..."
        ssh -oStrictHostKeyChecking=no ${var.ec2.user_name}@${aws_eip.db_slave.public_ip}   -i ${local.ssh_key_name}  >/dev/null 2>&1
       done

EOF
  }
}

