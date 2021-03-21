resource "null_resource" "ssh_key_generate" {
  provisioner "local-exec" {
	when = create
    interpreter = ["/bin/bash","-c"]
    working_dir = path.module
    command = <<EOF
      rm ${local.ssh_key_name}
      rm ${local.ssh_key_pub}
      ssh-keygen -f ${local.ssh_key_name} -q -N ""
     EOF
  }

}

data "local_file" "key_pub" {
  depends_on = [null_resource.ssh_key_generate]
  filename = local.ssh_key_pub
}
resource "aws_key_pair" "key" {
  key_name = var.app_name
  public_key = data.local_file.key_pub.content
}