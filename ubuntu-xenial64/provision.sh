
# Nginx
# On Ubuntu 16.04, Nginx is configured to start running upon installation.
sudo apt-get update
sudo apt-get install -y nginx

# Firewall stopped and disabled on system startup
sudo ufw disable

# ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'


# Mysql - so this need user interaction not sure how to automate this...  We have to set up root and password,
# I just used root and password, like i did in my microservices project
# <?php
#     define("DB_HOST","customerdb");
#     define("DB_USER","root");
#     define("DB_PASS","password");
#     define("DB_NAME","emvc");
# ?>
sudo apt-get install -y mysql-server