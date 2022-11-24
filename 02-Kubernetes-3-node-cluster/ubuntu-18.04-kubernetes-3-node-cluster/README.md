# Kubernetes with Containerd on Ubuntu using Vagrant
Ubuntu 18.04.7 LTS

## Virtual Box
Virtual Box Latest Version From Orcale for your version of mac intel or m1 chips.

### Copy the Kubernetes Admin Configuration from the Master Node
mkdir ~/.kube
scp root@172.16.16.100:/etc/kubernetes/admin.conf ~/.kube/config
Password is `kubeadmin`

### You can check everything now with:
kubectl cluster-info
kubectl -n kube-system get all

### You can test the calico network by seeing if containers can talk to one another on worker nodes
kubectl run --rm -it --image=alpine alpine -- sh

command breakdown:
`--rm` "kills container once you exit out of it
`-it` is for interactive 
`--image` the image we are using for the container
` alpine ` the name of the pod
` sh ` we are going to launch a shell into that container.

# Open up three 3 terminals
If you haven't already install `watch` - brew install watch

terminal1: watch kubectl get pods -o wide
terminal2: kubectl run --rm -it --image=alpine alpine -- sh
terminal3: kubectl run --rm -it --image=alpine alpine2 -- sh

### now if you get kworker1 and kworker2 we can ping one another
/ # hostname -i
192.168.41.130
/ # ping 192.168.77.130

### Understanding Namespace in Kubernetes
Login to kworker1 - ssh root@172.16.16.101
password: kubeadmin

Now we don't have docker installed but we can user ctr, take a look at `ctr -h` it has commands similar to docker.

We know there are a bunch containers running, so when we do `ctr containers list` why is it that we don't see anything?  

This is because Kubernetes using namespacing.  The find out if we have any containers outside of kworker1's namespace we do `ctr namespaces list`

We must use the namespace to see the containers and we can do this with the name space flag followed by any command:
ctr --namespace k8s.io containers list

## Vagrant
Version 2.3.3 or use Brew to install the latest for mac https://formulae.brew.sh/cask/vagrant

## Vagrant - Boxes and Provisioning Development Stacks with LAMP/LEMP.
Before you start, make sure you either turn off the firewall or configure to open all the ports you are planning to be using.  Host computers and virtual machines share the same ip address but run on different ports.   This handle with a NAT network environment. 

#### Vagrant Box - hashicorp/bionic64
The people that provided [bionic64](https://app.vagrantup.com/hashicorp/boxes/bionic64) are the creators of Vagrant.  Pull this box if you want to set up your own LAMP/LEMP stack on it on `Ubuntu 18.04.7 LTS`.