#!/bin/bash



# ----Installing PHP ----


sudo apt-get install php libapache2-mod-php php-mcrypt
sudo apt-get install php-mysql


# ----Installing mysql database----

sudo apt-get install mysql-server
sudo /usr/bin/mysql_secure_installation

#Starting mysql service

sudo service mysql restart
sudo chkconfig mysql on



# ----Making entry inside /etc/hosts

echo "Please enter your domain name:"
read varname
HOST_ENTRY=$varname

sudo sh -c "echo 127.0.0.1 $HOST_ENTRY >> /etc/hosts"

domainname=echo $HOST_NAME | awk -F. '{print $1}';

#----Creating Database for wordpress

echo "------Execute following steps"

echo "1 - Enter the Mysql Password and press Enter"
echo
echo "2 - Execute Command: SET PASSWORD=PASSWORD('');"
echo
echo "3 - CREATE DATBASE yourdomainname_db; Exp: CREATE DATABASE example_db"
echo "Exit from mysql"

mysql -u root -p

sudo service mysql restart
# ----Downloading wordpress latest version

cd ~/Downloads/
sudo apt-get install unzip

sudo wget http://wordpress.org/latest.zip
unzip latest.zip

sudo mkdir -p /var/www

sudo mv ~/Downlods/wordpress/ /var/www/


# ----Installing NGINX ---

sudo apt-get install nginx

sudo touch /etc/nginx/sites-available/$HOST_ENTRY.conf

sudo tee "/etc/nginx/sites-available/$HOST_ENTRY.conf" > /dev/null <<EOF
server {      
        listen   80;

	root /var/www/wordpress;
	index index.php index.html index.htm;

	server_name $HOST_ENTRY;

	location / {
		try_files $uri $uri/ /index.php?q=$uri&$args;
	}

	error_page 404 /404.html;

	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root /usr/share/nginx/www;
	}
    
    client_max_body_size 10M;

	# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
	location ~ \.php$ {
		try_files $uri = 404;
		#fastcgi_pass 127.0.0.1:9000;
		# With php5-fpm:
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}
}

EOF

sudo ln -s /etc/nginx/sites-available/$HOST_ENTRY.conf /etc/nginx/sites-enabled/$HOST_ENTRY.conf

sudo service nginx restart

#----Creating database into mysql 
db='_db'
echo "Creating database Hostname_db" 
echo 
mysql -hlocalhost -uroot --execute="CREATE DATABASE $domainname$db;"

echo "Database has been created.."

cd /var/www/wordpress/

sudo cp wp-config-sample.php wp-config.php


# ----Configuring wp-config 

sudo sh -c "" >> wp-config-sample.php

sudo tee "/etc/nginx/sites-available/wp-config-sample.php" > /dev/null <<EOF
"define('DB_NAME', '$domainname$db');

define('DB_USER', 'root');

define('DB_PASSWORD', '');
"
EOF

