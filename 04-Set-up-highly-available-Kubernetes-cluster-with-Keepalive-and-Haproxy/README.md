# Set up a Highly Available Kubernetes Cluster using kubeadm
Follow this documentation to set up a highly available Kubernetes cluster using __Ubuntu 20.04 LTS__ with keepalived and haproxy

This documentation guides you in setting up a cluster with three master nodes, one worker node and two load balancer node using HAProxy and Keepalived.  This guide will correct the problem we had in previous documentaton guide, where it had a single load balancer.  This gave us a single point of failure.  As you can set in this photo we set up two load balancers.

## Vagrant Environment
|Role|FQDN|IP|OS|RAM|CPU|
|----|----|----|----|----|----|
|Load Balancer|loadbalancer1.example.com|172.16.16.51|Ubuntu 20.04|512M|1|
|Load Balancer|loadbalancer2.example.com|172.16.16.52|Ubuntu 20.04|512M|1|
|Master|kmaster1.example.com|172.16.16.101|Ubuntu 20.04|2G|2|
|Master|kmaster2.example.com|172.16.16.102|Ubuntu 20.04|2G|2|
|Master|kmaster3.example.com|172.16.16.103|Ubuntu 20.04|2G|2|
|Worker|kworker1.example.com|172.16.16.201|Ubuntu 20.04|2G|2|

> * Password for the **root** account on all these virtual machines is **kubeadmin**
> * Perform all the commands as root user unless otherwise specified

### Virtual IP managed by Keepalived on the load balancer nodes
|Virtual IP|
|----|
|172.16.16.100|

## Pre-requisites
If you want to try this in a virtualized environment on your workstation, this example was using 13gb/16gb total ram on my host machine.
* Virtualbox installed
* Vagrant installed
* Host machine has at least 2 cores
* Host machine has at least 16G memory

## Bring up all the virtual machines
To set up the architecture in the photo, this demo has been simplified to just run the following.
```
vagrant up
```

## Next Step
KUBERNETES - This is manually done, for you to get a hands on experience adding nodes to a load balancer.  This way you can add more nodes at any time manually.