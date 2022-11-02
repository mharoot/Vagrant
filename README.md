# Vagrant
## Vagrant - Boxes and Provisioning Development Stacks with LAMP/LEMP.

#### Vagrant Box - hashicorp/bionic64
The people that provided [bionic64](https://app.vagrantup.com/hashicorp/boxes/bionic64) are the creators of Vagrant.  Pull this box if you want to set up your own LAMP/LEMP stack on it on `Ubuntu 18.04.7 LTS`.

Note: 
##### Be aware that sometimes hackers release boxes with intent to attack or snoop on users.  Use these sorts of boxes with caution, cause they could provision any malware they want into your virtual box.  It is best to pull the hashicorp/bionic43 and provision the machine with your own scripts or SSH into them.

---
---

# Set Up - Host Machine

# Redis - Redis Cluster does not support NAT environments. [(Learn more here!)](https://redis.io/docs/management/scaling/)

Currently, Redis Cluster does not support NATted environments and in general environments where IP addresses or TCP ports are remapped.
Sorry guys, but to do this we need actual phyiscal or cloud computers.
```php
// ini_set('session.save_handler', 'redis');
// ini_set('session.save_path', 'tcp://127.0.0.1:6379, tcp://127.0.0.1:6379');
// session_name('ElegantMVC');
```

To experience the full power of redis clusters w/o using multiple physical/cloud computers - use container technology like Docker, and only deploy one redis container needed to handle all your services.  The application in its current state is monolithic.  You can spin up multiple instances on different physical/cloud nodes, managed by one master node.

# enp0s3 is the network interface name on Ubuntu
![enp0s3 is the network interface name on Ubuntu](https://raw.githubusercontent.com/mharoot/Vagrant/master/hashicorp-bionic64/Nat%20Illustration%20with%20Host%20and%203%20Virtual%20machines.png)


---
---

# Set Up - MySQL Create User with ROOT privelleges
SSH into your virtual machine and create the new user with the password and All Privilleges granted.  Once you create the database and are using it via mysql command line.  Copy and paste the `SourceCode/mysql/emvc.sql` into mysql command to populate the database with the records.

---
---

# Set Up - SourceCode
This is fairly easy, just find `Elegant/dbconfig.php`, adjust the params as needed to connect to the db.


---
---

# Set Up - NGINX on Host Computer
In order to have our requests forward to the virtual box that is using NGINX our host needs to have nginx also, and it needs to run on a different port other than 8080.  We do this for simplicity since the default is 8080 on our virtual machine.  So once you install nginx, it starts automatically, stop the process, or kill the processs running on port 8080.  Set up the config in your host computer to use a different port like 3000.  Restart nginx, and you should be able to visit this instance of NGINX on your host computer like this `https://localhost:3000`.  The port forwarding has been set up for you to route from 8080 host to our 8000 virtual machine.
