data "aws_ami" "debian" {
  most_recent      = true
  owners = ["379101102735"]
  filter {
   name   = "name"
   values = ["debian-stretch-hvm-x86_64*"]
  }

}

data "external" "db_streaming_password_md5" {
  program = ["bash",
    "postgres_md5_password.sh",
    random_string.postgresql_streaming_user_name.result,
    random_string.postgresql_streaming_user_password.result]
}


data "external" "db_user_password_md5" {
  program = [
    "bash",
    "postgres_md5_password.sh",
    random_string.db_user_name.result,
    random_string.db_user_password.result]
}