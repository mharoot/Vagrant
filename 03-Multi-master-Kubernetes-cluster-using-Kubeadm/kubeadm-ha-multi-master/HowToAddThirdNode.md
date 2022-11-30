# How to add a third node
`kubeadm token --help`

`kubeadm token create --help`

`--certificate-key string` - When used together with '--print-join-command', print the full 'kubeadm join' flag needed to join the cluster as a control-plane. To create a new certificate key you must use 'kubeadm init phase upload-certs --upload-certs'.

`--print-join-command` - Instead of printing only the token, print the full 'kubeadm join' flag needed to join the cluster using the token.

## Step1
`kubeadm init phase upload-certs --upload-certs`

output:
```
I1130 05:27:13.756306   13610 version.go:255] remote version is much newer: v1.25.4; falling back to: stable-1.24
[upload-certs] Storing the certificates in Secret "kubeadm-certs" in the "kube-system" Namespace
[upload-certs] Using certificate key:
7b175e2cfc6db8d9d75f581aa94549d4d982e2e7395c93503be6625042b28c3c
```
## Step 2
In the kmaster1 node run:

`kubeadm token create --certificate-key 7b175e2cfc6db8d9d75f581aa94549d4d982e2e7395c93503be6625042b28c3c --print-join-command`

The output is what we need for additional master nodes, we need to add the --apiserver-advertise-address also with the ip address for that master node:

```
kubeadm join 172.16.16.100:6443 --token hhi7ya.c1twpnn0xkf4m93m --discovery-token-ca-cert-hash sha256:ffc05f0fb28a2667fb704970604f74482d1cf5f872158d4234190f8bc06134c2 --control-plane --certificate-key 7b175e2cfc6db8d9d75f581aa94549d4d982e2e7395c93503be6625042b28c3c --apiserver-advertise-address=172.16.16.103
```

we can modify the output and this could be used for a worker node, by removing --control-plane & --certificate-key:

```
kubeadm join 172.16.16.100:6443 --token hhi7ya.c1twpnn0xkf4m93m --discovery-token-ca-cert-hash sha256:ffc05f0fb28a2667fb704970604f74482d1cf5f872158d4234190f8bc06134c2 
```