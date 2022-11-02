# https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-ubuntu-18-04
sudo su 
apt update -y
# to use lsb_release -a tool to get the codename for the install, lsb_release -c spits out "bionic"
apt-get install lsb-core -y

# NGNX INSTALL, YES we want to install, NO we don't want to overite out etc/nginx/sites-available/default file.
apt install nginx -Y -N


# MYSQL
apt install mysql-server -y


# Note: Depending on your cloud provider, you may need to add Ubuntu’s universe repository, which 
# includes free and open-source software maintained by the Ubuntu community, before installing the 
# php-fpm package. You can do this by typing the following command:
add-apt-repository universe -y

# Install the php-fpm module along with an additional helper package, php-mysql, which will allow PHP 
# to communicate with your database backend. The installation will pull in the necessary PHP 
# core files. Do this by typing the following:
apt install php-fpm php-mysql -y

# Redis
apt install php-dev -y
pecl install redis

apt install redis-server -y
sed -i 's/^supervised no/supervised systemd/' /etc/redis/redis.conf
systemctl restart redis.service
systemctl status redis


service nginx start



# Note: You still need to Vagrant SSH to set tshis up manually and create the user with root privlleges since mysql requires sudo for root access
# https://phoenixnap.com/kb/how-to-create-new-mysql-user-account-grant-privileges
# sudo mysql_secure_installation


# Note: You still need to create the database and import the sql data from the SourceCode in MySql server.
# sudo mysql -u root -p
# EnterPassword: 123

    # define("DB_HOST","localhost");
    # define("DB_USER","ELEGANT_MVC_ROOT_USER");
    # define("DB_PASS","ELEGANT_MVC_ROOT_PASSWORD");
    # define("DB_NAME","ELEGANT_MVC_DB");

    
    
# CREATE USER 'ELEGANT_MVC_ROOT_USER'@'localhost' IDENTIFIED BY 'password';

# GRANT ALL PRIVILEGES ON ELEGANT_MVC_DB.* TO 'ELEGANT_MVC_ROOT_USER'@'localhost';

