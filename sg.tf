# sg for db
data "local_file" "sg_db_csv" {
  filename = var.sg_db_profile
}

locals {
  sg_db = csvdecode(data.local_file.sg_db_csv.content)
}

resource "aws_security_group" "db" {
  name        = "${var.app_name}-db"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    cidr_blocks = [var.vpc_default_cidr]
    description = "db from vpc"
 }
  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    self = true
  }
  ingress {
    from_port = 5432
    protocol = "tcp"
    to_port = 5432
    cidr_blocks = ["${aws_eip.app.public_ip}/32"]
    description = "db from app  server"
  }
  dynamic "ingress" {
    for_each = local.sg_db
	 content {
	   from_port = ingress.value.from_port
	   to_port = ingress.value.to_port
	   protocol =  ingress.value.protocol
	   cidr_blocks = split(" ", ingress.value.cidrs)
	   description = ingress.value.descriptions
	 }
  }

   egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags =local.commmon_tags

}

#  sg for app

data "local_file" "sg_app_csv" {
  filename = var.sg_app_profile
}

locals {
  sg_app = csvdecode(data.local_file.sg_app_csv.content)
}

resource "aws_security_group" "app" {
  name        = "${var.app_name}-app"
  vpc_id      = aws_vpc.default.id

  dynamic "ingress" {
    for_each = local.sg_app
	 content {
	   from_port = ingress.value.from_port
	   to_port = ingress.value.to_port
	   protocol =  ingress.value.protocol
	   cidr_blocks = split(" ", ingress.value.cidrs)
	   description = ingress.value.descriptions
	 }
  }


   egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags =local.commmon_tags

}