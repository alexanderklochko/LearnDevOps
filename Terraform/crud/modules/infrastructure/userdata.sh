#!/bin/bash -xe
# Install all necessary packages
set -xe
sudo yum update -y
sudo yum install -y gcc-c++ zlib-devel 
sudo amazon-linux-extras enable -y php8.1
sudo yum clean -y metadata
sudo yum install -y php php-devel
sudo yum install -y php-{pear,cgi,pdo,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip}
sudo yum install -y httpd
sudo yum install -y mysql
# Copy applications' code from S3
sudo aws s3 cp ${s3_bucket} /var/www/html --recursive
# Give appropriate rights
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
# Substitude environment variables to db.php file
sudo sed -i -e "s/'localhost'/'${db_hostname}'/" /var/www/html/db.php
sudo sed -i -e "s/'php_mysql_crud'/'${db_name}'/" /var/www/html/db.php
sudo sed -i -e "s/'root'/'${db_user}'/" /var/www/html/db.php
sudo sed -i -e "s/'password123'/'${db_pass}'/" /var/www/html/db.php
# Start the web server
sudo systemctl start httpd
sudo systemctl enable httpd
# Configure connection to RDS
RESULT_VARIABLE=$(mysql -u ${db_root_user} -p${db_root_pass} -h ${db_hostname} -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${db_user}');")
sudo touch /var/www/html/file.txt
if [ "$RESULT_VARIABLE" == 1 ];
    then
    echo "user had already created $RESULT_VARIABLE" > /var/www/html/file.txt
else
    sudo mysql -u ${db_root_user} -p${db_root_pass} -h ${db_hostname}\
               -e "CREATE USER '${db_user}'@'%' IDENTIFIED BY '${db_pass}';GRANT ALL ON ${db_name}.* TO '${db_user}'@'%';FLUSH PRIVILEGES;"
    sudo mysql -u ${db_user} -p${db_pass} -h ${db_hostname} ${db_name} < /var/www/html/database/script.sql        
    sudo systemctl restart httpd
fi
    
