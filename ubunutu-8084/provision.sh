# https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-ubuntu-18-04
sudo su 
# Note: Depending on your cloud provider, you may need to add Ubuntu’s universe repository, which 
# includes free and open-source software maintained by the Ubuntu community, before installing the 
# php-fpm package. You can do this by typing the following command:
add-apt-repository universe
apt-get update -y
# to use lsb_release -a tool to get the codename for the install, lsb_release -c spits out "bionic"
apt-get -y install lsb-core

# remove these two since they are created on the install and we have no way of telling the terminal NO, we want our settings.
rm /etc/nginx/sites-available/default
rm /etc/redis/redis.conf

# ---------------------------------------------------------------------------- #
# --------------------------------- NGINX ------------------------------------ #
# ---------------------------------------------------------------------------- #

# Install
apt-get -y install nginx

# Copy my configuration into the default setting
cp /etc/nginx/sites-available/main /etc/nginx/sites-available/default

# Start
service nginx start

# mkdir /etc/systemd/system/nginx.service.d
# printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
# systemctl daemon-reload
# systemctl restart nginx 


# ---------------------------------------------------------------------------- #
# --------------------------------- MYSQL ------------------------------------ #
# ---------------------------------------------------------------------------- #

# Install
apt-get -y install mysql-server

# Create a user with root privileges
mysql -uroot -p123 -e "
CREATE USER 'ELEGANT_MVC_ROOT_USER'@'localhost' IDENTIFIED BY 'ELEGANT_MVC_ROOT_P@SSW0RD123!';
CREATE DATABASE ELEGANT_MVC_DB;
GRANT ALL PRIVILEGES ON *.* TO 'ELEGANT_MVC_ROOT_USER'@'localhost';
"

# Import the data for the database.
mysql -uroot -p123 ELEGANT_MVC_DB < /var/www/html/mysql/emvc.sql


# ---------------------------------------------------------------------------- #
# --------------------------------- Redis ------------------------------------ #
# ---------------------------------------------------------------------------- #

# no - to enabling igbinary serializer support
no | pecl install redis

apt-get -y install redis-server

chown -R redis:redis /var/log/redis
chmod -R u+rwX,g+rwX,u+rx /var/log/redis

chmod +r /etc/redis/main.conf
mkdir -p  /var/log/redis/ && sudo touch /var/log/redis/redis-server.log && sudo chown redis:redis /var/log/redis/redis-server.log

cp /etc/redis/main.conf /etc/redis/redis.conf

# sed -i 's/^supervised no/supervised systemd/' /etc/redis/redis.conf
#
#

# ---------------------------------------------------------------------------- #
# ---------------------------------- PHP ------------------------------------- #
# ---------------------------------------------------------------------------- #
# Install the php-fpm module along with an additional helper package, php-mysql, which will allow PHP 
# to communicate with your database backend. The installation will pull in the necessary PHP 
# core files. Do this by typing the following:
apt-get -y install php-fpm php-mysql php-dev php-redis



redis-server /etc/redis/redis.conf

# need to stop and restart redis.service, we need to make sure the process is killed that started the incorrect configurations
# systemctl stop redis.service # this failed out last time, don't think its needed.
lsof -i tcp:16383 | awk '/16383/{print $2}' | xargs kill

# systemctl enable /lib/systemd/system/redis-server.service
systemctl enable redis-server
systemctl daemon-reload

# systemctl status redis
# Start

systemctl restart redis.service
service php7.2-fpm restart
service nginx restart


########
