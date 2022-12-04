# KUBERNETES
Everything here is manually done.  This is attended to be an exercise to get you to remember how to do this.  Pay attention to the flags we use in this guide.  If you haven't already run.  Note my mac os uses kubectl 1.25.4 but my containers are using 1.24 and it is still compatible.  Install the latest on your Mac OS to not have any problems.
```
vagrant up
```

## On any one of the Kubernetes master node (Eg: kmaster1)
SSH into the kmaster1, the password is `kubeadmin`.
```
ssh root@172.16.16.101
```

##### Initialize Kubernetes Cluster
```
kubeadm init --control-plane-endpoint="172.16.16.100:6443" --upload-certs --apiserver-advertise-address=172.16.16.101 --pod-network-cidr=192.168.0.0/16
```

##### You can now join any number of the control-plane node running the following command on each as root:
Copy the commands to join other master nodes and worker nodes that gets outputed after the command above is ran and modify according like I have done below with the `--apiserver-advertise-address=MASTER_NODE_IP`.  The example below is doing kmaster2.

```
kubeadm join 172.16.16.100:6443 --token 58065o.8a931gh6f6vjtlor \
        --discovery-token-ca-cert-hash sha256:1ebcc5ed4dfb8a223a557ecd116f2efb40398330bb3fc8c3a5fa63c93518a2c2 \
        --control-plane --certificate-key a54e5f4067247a4f5dc08dc0ab618ceb77be125bf8298643300cec0d56f9a9ad --apiserver-advertise-address=172.16.16.102
```

##### Please note that the certificate-key gives access to cluster sensitive data, keep it secret! As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

##### Join any number of worker nodes by running the following on each as root:
SSH into the kworker1, the password is `kubeadmin`.  Be careful not to add a space at the end of the `--discovery-token-ca-cert-hash sha256:`

```
kubeadm join 172.16.16.100:6443 --token 58065o.8a931gh6f6vjtlor \
        --discovery-token-ca-cert-hash sha256:1ebcc5ed4dfb8a223a557ecd116f2efb40398330bb3fc8c3a5fa63c93518a2c2
```


##### Deploy Calico network
Do this last after connected all master and worker nodes above in the above step.
```
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.15/manifests/calico.yaml
```

## Join other nodes to the cluster (kmaster2 & kworker1)
> Use the respective kubeadm join commands you copied from the output of kubeadm init command on the first master.

> IMPORTANT: You also need to pass --apiserver-advertise-address to the join command when you join the other master node.

## Downloading kube config to your local machine
On your host machine
```
mkdir ~/.kube
scp root@172.16.16.101:/etc/kubernetes/admin.conf ~/.kube/config
```
Password for root account is kubeadmin (if you used my Vagrant setup)

## Verifying the cluster
```
kubectl cluster-info
kubectl get nodes
kubectl get cs
```

# Testing what we have done.
Lets look at the beauty of keepalived.  Right now we have 1 load balancer sitting and waiting doing nothing.  If that loadbalancer1 dies or gets rebooted, keepalived will assign a new loadbalancer2.
If they both die at the same time we are screwed, the site will go down.

# SSH into loadbalancer1 & loadbalancer2
Open up two terminal windows and ssh into the load balancers the password is `kubeadmin`.
```
ssh root@172.16.16.51
ssh root@172.16.16.52
```

In both type in the following command and inspect the output carefully.
```
ip a s eth1
```

`root@loadbalancer1:~# ip a s eth1`
```
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:07:76:61 brd ff:ff:ff:ff:ff:ff
    inet 172.16.16.51/24 brd 172.16.16.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet 172.16.16.100/32 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe07:7661/64 scope link 
       valid_lft forever preferred_lft forever
```

`root@loadbalancer2:~# ip a s eth1`
```
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:58:b2:99 brd ff:ff:ff:ff:ff:ff
    inet 172.16.16.52/24 brd 172.16.16.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe58:b299/64 scope link 
       valid_lft forever preferred_lft forever
```

Now `reboot` either loadalancer 1 or 2 based on whichever gets assigned first.  The load balancer that is assigned has an extra line.  They will switch and the new one gets assigned by keepalived.
```
    inet 172.16.16.100/32 scope global eth1
       valid_lft forever preferred_lft forever
```