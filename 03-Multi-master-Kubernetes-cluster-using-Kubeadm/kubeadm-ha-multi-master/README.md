## On any one of the Kubernetes master node (Eg: kmaster1) - i get stuck here. why? should bootsraping all 4 nodes fix this? why does he not boostrap the load blanacer the same way?
##### Initialize Kubernetes Cluster
```
kubeadm init --control-plane-endpoint="172.16.16.100:6443" --upload-certs --apiserver-advertise-address=172.16.16.101 --pod-network-cidr=192.168.0.0/16
```
Copy the commands to join other master nodes and worker nodes.

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join 172.16.16.100:6443 --token 089s4t.o103tbxrl5nyxkaq \
        --discovery-token-ca-cert-hash sha256:ffc05f0fb28a2667fb704970604f74482d1cf5f872158d4234190f8bc06134c2 \
        --control-plane --certificate-key d29104fc60e08a27acec1d21408a7f8a69fa2ebd249007e8079a9f4eb1ee70b9 --apiserver-advertise-address=172.16.16.102

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.16.16.100:6443 --token 089s4t.o103tbxrl5nyxkaq \
        --discovery-token-ca-cert-hash sha256:ffc05f0fb28a2667fb704970604f74482d1cf5f872158d4234190f8bc06134c


##### Deploy Calico network
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

Have Fun!!
