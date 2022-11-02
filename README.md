# Vagrant
Vagrant - Boxes and Provisioning Development Stacks with LAMP/LEMP.

### Ubuntu Offical Vagrant Box 16.04.7 LTS Xenial
Codename [xenial](https://app.vagrantup.com/ubuntu/boxes/xenial64), is in the folder `ubuntu-xenial64`.  Pull this box if you want to set up your own LAMP/LEMP stack on it.

---


### Ubuntu 16.04 with brownell/xenial64lemp - Unoffical
This box comes with the LEMP stack, [brownell/xenial64lemp](https://app.vagrantup.com/brownell/boxes/xenial64lemp)

#### Note:
Be aware that sometimes hackers release boxes with intent to attack or snoop on users.  Use these sorts of boxes with caution, cause they could provision any malware they want into your virtual box.






# Redis - Redis Cluster does not support NATted environments. [(Learn more here!)](https://redis.io/docs/management/scaling/)

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