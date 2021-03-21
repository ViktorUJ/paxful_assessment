aws_install:
	terraform init
	terraform apply -auto-approve
ansible_add_role:
	sudo ansible-galaxy install ANXS.postgresql
	sudo ansible-galaxy collection install community.postgresql
setup_db:
	ansible-playbook role_db_master.yaml
	ansible-playbook role_db_slave.yaml

setup_app:
	@echo '***** setup app'
	ansible-playbook app_server_setup.yaml

install: aws_install ansible_add_role  setup_db setup_app  wait_mail_dev tests env_info

destroy:
	terraform destroy -auto-approve

info:
	terraform --version
	ansible --version

env_info:
	@echo '****   env info'
	terraform output
tests:
	./tests.sh

wait_mail_dev:
	@echo '***** wait 10 sec'
	sleep 10

