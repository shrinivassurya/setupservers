Quick guide to setup nginx server for wordpress

Following service need to be installed

NGINX
PHP
MYSQL

Upadate apt-get 

	sudo apt-get install update

Install PHP and additional packages

	sudo apt-get install php libapache2-mod-php php-mcrypt
	sudo apt-get install php-mysql

Install MySQL database

	sudo apt-get install mysql-server
	sudo /usr/bin/mysql_secure_installation
	
	Complete all instruction during installation of mysql
	
	execute mysql -uroot -p and set password null.
	restart mysql service

Make domain entry inside '/etc/hosts'
	after asking the domain name
	sudo sh -c "echo 127.0.0.1 $HOST_ENTRY >> /etc/hosts"	

Download and extract wordpress and additional packages
	sudo apt-get install unzip

	sudo wget http://wordpress.org/latest.zip
	unzip wordpress-*.zip

	Moving wordpress into another location document directory
	sudo mv ~/Download/wordpress/wordpress /var/www/

Install NGINX and additional packages

	sudo apt-get install nginx

	create domain name cofiguration for NGINX conf
	
	sudo touch /etc/nginx/sites-available/$HOST_ENTRY.conf
	
	Append following code into conf file
	
	server {    
		listen   80;

		root /var/www/wordpress;
		index index.php index.html index.htm;

		server_name $HOST_ENTRY;
	}
    
	}">> /etc/nginx/sites-available/$HOST_ENTRY.conf

	sudo ln -s /etc/nginx/sites-available/$HOST_ENTRY.conf /etc/nginx/sites-enabled/$HOST_ENTRY.conf
	sudo service nginx restart


Create wordpress database host into mysql

	mysql -hlocalhost -uroot --execute="CREATE DATABASE $HOST_ENTRY_db;"

	echo "Database has been created.."

Create another wp config file as existing wp-config file 	
	
	cd /var/www/wordpress/

	sudo cp wp-config-sample.php wp-config.php

	We can add following lines into wp-config-sample.php

	define('DB_NAME', '$HOST_ENTRY_db');

	define('DB_USER', 'root');

	define('DB_PASSWORD', '');


# setupservers
