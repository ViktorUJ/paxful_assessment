locals {
  commmon_tags = {
	Name = var.app_name
	ManagedBy = "terraform"
  }
  subnet_ids=[
  for id in aws_subnet.subnets_pub:
  id.id
  ]
  subnet_db_master=element(local.subnet_ids,0 )
  subnet_db_slave=element(local.subnet_ids,1 )
  subnet_app=element(local.subnet_ids,0 )
  ssh_key_name="${var.app_name}-key"
  ssh_key_pub="${local.ssh_key_name}.pub"

}