```` 
Using the automation tools of your choice prepare a FULLY provisioned cloud environment in AWS.
This automation should do:
Deploy 3 EC2 nodes (App, DB Master (PostgreSQL), DB Slave (PostgreSQL) based on the last stable Debian. Setup master-slave (replication) PostgreSQL between node 2 and 3.
Deploy a simple PHP application with requirements:
Prepare a solution that adds a special URL path “/blacklisted” with requirements:
It responds to the URL like 'http://host/?n=x' and returns n*n.
It responds to the URL 'http://host/blacklisted' with conditions:
return error code 444 to the visitor
block the IP of the visitor
send an email with IP address to "test@domain.com"
insert into PostgreSQL table information: path, IP address of the visitor and datetime when he got blocked
Tips:
Fully provisioned means that you run one command and deploy everything starting from the creation of VM, then provision and run tests.
For cloud environment deployment use Terraform.
Free Tier instance will be enough.
For provisioning, you can use popular automation tools like Ansible/Puppet/Chef.
For the testing environment, you can use tools like Vagrant, TestKitchen, Molecule, docker-compose with unit/integration tests based on rspec/serverspec/inspec.
Don’t forget about documentation
Time limit:
We expect you to do it in a week. Feel free to ask any questions.
We wish you good luck :)

````