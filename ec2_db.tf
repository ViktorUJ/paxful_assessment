
resource "random_string" "db_user_password" {
  length = 10
  special = true
  override_special = ".,%~@#%*"
  min_special = 2
}

resource "random_string" "db_user_name" {
  length = 10
  special = false
  number = false

}

resource "random_string" "db_db_name" {
  length = 12
  special = false
  number = false

}



resource "random_string" "postgresql_streaming_user_password" {
  length = 10
  special = true
  override_special = ".,%~@#%*"
  min_special = 2
}

resource "random_string" "postgresql_streaming_user_name" {
  length = 10
  special = false
  number = false

}


data "template_file" "db" {
  template = file("template/user_data_db.sh")
  vars = {
  db_user_name=random_string.db_user_name.result
  db_user_password=random_string.db_user_password.result
  db_db_name=random_string.db_db_name.result
  }
}

resource "aws_instance" "db_master" {
  ami           = data.aws_ami.debian.id
  instance_type = var.db.instance_type_master
  subnet_id = local.subnet_db_master
  associate_public_ip_address = "true"
  user_data = data.template_file.db.rendered
  security_groups = [aws_security_group.db.id]
  key_name = aws_key_pair.key.key_name
  tags = {
	 Name = "${var.app_name}-db-master"
  }
   volume_tags = {
	 Name = "${var.app_name}-db-master"
  }
  root_block_device {
   volume_type= var.db.volume_type
   volume_size = var.db.volume_size
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

resource "aws_eip" "db_master" {
   vpc      = true
   instance = aws_instance.db_master.id
   tags =local.commmon_tags
}

resource "aws_instance" "db_slave" {
  ami           = data.aws_ami.debian.id
  instance_type = var.db.instance_type_slave
  subnet_id = local.subnet_db_slave
  associate_public_ip_address = "true"
  security_groups = [aws_security_group.db.id]
  key_name = aws_key_pair.key.key_name
  tags = {
	 Name = "${var.app_name}-db-slave"
  }
   volume_tags = {
	 Name = "${var.app_name}-db-slave"
  }
  root_block_device {
   volume_type= var.db.volume_type
   volume_size = var.db.volume_size
   delete_on_termination ="true"
   }

  lifecycle {
    ignore_changes = [
      security_groups,
      tags
    ]
  }

}

resource "aws_eip" "db_slave" {
   vpc      = true
   instance = aws_instance.db_slave.id
   tags =local.commmon_tags
}




