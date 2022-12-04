#!/bin/bash

###############################################################################
# bootstrap_loadbalancer.sh
###############################################################################
echo "[TASK 1] Update and install haproxy"
apt update -qq >/dev/null 2>&1
apt install -qq -y haproxy >/dev/null 2>&1

echo "[TASK 2] Append the below lines to /etc/haproxy/haproxy.cfg"
cat >>/etc/haproxy/haproxy.cfg<<EOF
frontend kubernetes-frontend
    bind 172.16.16.100:6443
    mode tcp
    option tcplog
    default_backend kubernetes-backend

backend kubernetes-backend
    mode tcp
    option tcp-check
    balance roundrobin
    server kmaster1 172.16.16.101:6443 check fall 3 rise 2
    server kmaster2 172.16.16.102:6443 check fall 3 rise 2
EOF

echo "[TASK 3] Restart haproxy service"
systemctl restart haproxy

# Enable ssh password authentication
echo "[TASK 8] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 9] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
