variable "aws_region" {
  default="eu-north-1"
}
variable "vpc_default_cidr" {
  default = "10.0.0.0/16"
}
variable "az_ids" {
   default = {
      "10.0.0.0/19"="eun1-az1"
      "10.0.32.0/19"= "eun1-az2"
      "10.0.64.0/19"= "eun1-az3"
 }

}


variable "aws_profile" {
  default = "default"
}


variable "app_name" {
  default = "simple_php"
}

variable "sg_db_profile" {
  default = "template/db.csv"

}

variable "sg_app_profile" {
  default = "template/app.csv"

}

variable "db" {
  default = {
    "instance_type_master"="t3.micro"
    "instance_type_slave"="t3.micro"
    "volume_type"="gp3"
    "volume_size"="15"
  }
}

variable "app" {
  default = {
    "instance_type"="t3.micro"
    "volume_type"="gp3"
    "volume_size"="10"
  }
}
variable "ec2" {
  default = {
    "enventory"="ansible_env"
    "user_name"="admin"
  }
}

variable "postgresql_version" {
  default = "11"
}