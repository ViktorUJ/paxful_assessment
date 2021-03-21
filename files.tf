resource "local_file" "ansible_enventory" {
  filename = var.ec2.enventory
  content = <<EOF
[pgmaster]
pgmaster1 ansible_host=${aws_eip.db_master.public_ip}

[pgslave]
pgslave1 ansible_host=${aws_eip.db_slave.public_ip}

[app]
app1 ansible_host=${aws_eip.app.public_ip}

[db:children]
pgmaster
pgslave


[all_app_env:children]
pgmaster
pgslave
app

[all_app_env:vars]
ansible_connection=ssh
ansible_user=${var.ec2.user_name}
ansible_ssh_private_key_file=${local.ssh_key_name}
db_name=${random_string.db_db_name.result}
db_user_name=${random_string.db_user_name.result}
db_user_password=${random_string.db_user_password.result}
db_user_password_md5=${data.external.db_user_password_md5.result.md5}
db_host=${aws_eip.db_master.public_ip}
app_host=${aws_eip.app.public_ip}
postgresql_version=${var.postgresql_version}
postgresql_streaming_user_password=${random_string.postgresql_streaming_user_password.result}
postgresql_streaming_user_password_md5=${data.external.db_streaming_password_md5.result.md5}
postgresql_streaming_user_name=${random_string.postgresql_streaming_user_name.result}
EOF
}

resource "local_file" "ansible_config" {
  filename = "ansible.cfg"
  content = <<EOF
[defaults]
host_key_checking = false
inventory         = ${local_file.ansible_enventory.filename}
#interpreter_python = /usr/bin/python3
allow_world_readable_tmpfiles = true
pipelining=True
EOF
}


resource "local_file" "tests" {
  filename = "tests.sh"
  content = <<EOF
#!/bin/bash
echo '***** run tests'
n=5
echo "***** send http://${aws_eip.app.public_ip}?n=$n  responce = $(curl -s http://${aws_eip.app.public_ip}?n=$n)"
echo "***** check blacklist"
curl -v http://${aws_eip.app.public_ip}/blacklisted
EOF
}



resource "local_file" "vars_db_master" {
  filename = "vars_db_master.yaml"
  content = <<EOF
---

postgresql_version: ${var.postgresql_version}

postgresql_databases:
  - name: ${random_string.db_db_name.result}

postgresql_users:

  # postgresql >=10 does not accept unencrypted passwords
  - name: ${random_string.db_user_name.result}
    pass: ${data.external.db_user_password_md5.result.md5}
    encrypted: yes

  - name: ${random_string.postgresql_streaming_user_name.result}
    pass: ${data.external.db_streaming_password_md5.result.md5}
    encrypted: yes


postgresql_user_privileges:
  - name: ${random_string.db_user_name.result}
    db: ${random_string.db_db_name.result}
    role_attr_flags: "LOGIN,SUPERUSER"

postgresql_database_schemas:
  - database: ${random_string.db_db_name.result}
    state: present
    schema: acme
    owner: ${random_string.db_user_name.result}
postgresql_listen_addresses:
  - "*"

postgresql_wal_level: "logical"
postgresql_max_replication_slots: "5"
postgresql_max_wal_senders: "5"
#postgresql_database_extensions: [pgoutput]

postgresql_pg_hba_default:
  - { type: local, database: all, user: all, address: "",             method: "{{ postgresql_default_auth_method }}", comment: '"local" is for Unix domain socket connections only' }
  - { type: host,  database: all, user: all, address: "0.0.0.0/0", method: "{{ postgresql_default_auth_method_hosts }}", comment: "IPv4  connections:" }
  - { type: host,  database: all, user: all, address: "::1/128",      method: "{{ postgresql_default_auth_method_hosts }}", comment: "IPv6 local connections:" }
  - { type: local, database: all, user: "{{ postgresql_admin_user }}", address: "", method: "peer map=root_as_{{ postgresql_admin_user }}", comment: "Local root Unix user, passwordless access" }

EOF
}



resource "local_file" "vars_db_slave" {
  filename = "vars_db_slave.yaml"
  content = <<EOF
---

postgresql_version: ${var.postgresql_version}

postgresql_databases:
  - name: ${random_string.db_db_name.result}

postgresql_users:

  # postgresql >=10 does not accept unencrypted passwords
  - name: ${random_string.db_user_name.result}
    pass: ${data.external.db_user_password_md5.result.md5}
    encrypted: yes

  - name: ${random_string.postgresql_streaming_user_name.result}
    pass: ${data.external.db_streaming_password_md5.result.md5}
    encrypted: yes


postgresql_user_privileges:
  - name: ${random_string.db_user_name.result}
    db: ${random_string.db_db_name.result}

postgresql_database_schemas:
  - database: ${random_string.db_db_name.result}
    state: present
    schema: acme
    owner: ${random_string.db_user_name.result}
postgresql_listen_addresses:
  - "*"


postgresql_pg_hba_default:
  - { type: local, database: all, user: all, address: "",             method: "{{ postgresql_default_auth_method }}", comment: '"local" is for Unix domain socket connections only' }
  - { type: host,  database: all, user: all, address: "0.0.0.0/0", method: "{{ postgresql_default_auth_method_hosts }}", comment: "IPv4  connections:" }
  - { type: host,  database: all, user: all, address: "::1/128",      method: "{{ postgresql_default_auth_method_hosts }}", comment: "IPv6 local connections:" }
  - { type: local, database: all, user: "{{ postgresql_admin_user }}", address: "", method: "peer map=root_as_{{ postgresql_admin_user }}", comment: "Local root Unix user, passwordless access" }

EOF
}



