Paxful Infrastructure Test Assignment (option 1)
================================

# Requirements

### terrafrom  v0.14.xx
### linux make
### ansible v2.9.6+
### aws IAM user  + Access key  (or IAM role ) with  Admin privilege  form VPC, EC2  
### aws profile 


````
cat ~/.aws/credentials
[default]
aws_access_key_id = XXXXXXXXXXXX
aws_secret_access_key = YYYYYYYYYYYY
````

# Create Env
```
 make install

```
# Update Env (cloud )

```
 make aws_install

```

# Update Env (app )

```
 make setup_app

```


# Update Env (cloud  +  deploy)

````
 make install

````


# Destroy  Env 

````
 make destroy

````


# run tests

````
 make tests

````

# show env info

````
 make env_info

````

