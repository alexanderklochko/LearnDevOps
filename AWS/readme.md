## Cloud_task_AWS 
---------------------------------------------------------------------------------------

#### Network configurations

1) Create VPC;
2) Create 1 public subnet for future nat configuration, 1 public subnet for
   autoscaling group which will be replace to the private subnet in the future,
   private subnet for RDS.
3) Create internat gateway, attached to VPC. Create route table, add 
   '0.0.0.0/0 - IG' rule to route table and assigned it with created public
   subnet.
4) Amazon RDS -> Subnet Groups -> create subnet group.


#### Creating autoscaling group and launch template

1) User data script, which prepare EC2 instance for deploying application,
   use it in Userdata, wen created Launchtamplate:

```sh
      #!/bin/bash
      # Declare environment variables
      DB_HOSTNAME=db-mysql-crud.cemtf9kzp91w.eu-north-1.rds.amazonaws.com
      DB_NAME=crud
      DB_USERNAME="aleks"
      DB_PASSWORD="passwd123"
      # Install all necessary packages
      yum update -y
      sudo yum install -y gcc-c++ zlib-devel 
      sudo amazon-linux-extras enable -y php8.1
      sudo yum clean -y metadata
      sudo yum install -y php php-devel
      sudo yum install -y php-{pear,cgi,pdo,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip}
      sudo yum install -y httpd
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      # Copy applications' code from S3
      sudo aws s3 cp s3://crud770796886575/php-mysql-crud/ /var/www/html --recursive
      # Give appropriate rights
      sudo usermod -a -G apache ec2-user
      sudo chown -R ec2-user:apache /var/www
      sudo chmod 2775 /var/www
      find /var/www -type d -exec sudo chmod 2775 {} \;
      find /var/www -type f -exec sudo chmod 0664 {} \;
      # Substitude environment variables to db.php file
      sudo sed -i -e "s/'localhost'/$DB_HOSTNAME/" /var/www/html/db.php
      sudo sed -i -e "s/'php_mysql_crud'/$DB_NAME/" /var/www/html/db.php
      sudo sed -i -e "s/'admin'/$DB_USERNAME/" /var/www/html/db.php
      sudo sed -i -e "s/'password123'/$DB_PASSWORD/" /var/www/html/db.php
      # Start the web server
      sudo systemctl start httpd
      sudo systemctl enable httpd

```   
2) Create Launch template;
3) Create Load Balancer;
4) Create Autoscaling group
   Attach S3 policy to WHAT????
   
#### Create private S3 bucket

1) Put php-mysql-crud to the bucket;
2) Allow EC2 copy code from private S3:
   - [link](https://aws.amazon.com/ru/premiumsupport/knowledge-center/ec2-instance-access-s3-bucket/);
   - [link](https://kloudle.com/academy/how-to-transfer-files-between-aws-s3-and-aws-ec2/).
  with command: `aws s3 cp s3://crud770796886575/php-mysql-crud/ /var/www --recursive`
3) 

#### Create and configure RDS

1) Choose created VPC and subnet group;
2) Create and attach security group, which allows only connect from EC2
   (specify EC2 security group as a source for RDS securoty group).
3) Configure RDS (mysql):
  - `mysql -u admin -p -h <endpoint>` from EC2 which is in allowed security group;
  - create user `CREATE USER 'user'@'%' IDENTIFIED BY 'password';`
  - `CREATE DATABASE dadtabase`
  - `GRANT ALL ON database.* TO 'user'@'%';`
  - `FLUSH PRIVILEGES`
4) Import script.sql by following command:
  `sudo mysql -u aleks -p -h db-mysql-crud.cemtf9kzp91w.eu-north-1.rds.amazonaws.com < crud/database/script.sql`

