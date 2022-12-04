#!/bin/bash

###############################################################################
# bootstrap_loadbalancer.sh
###############################################################################

# WE WILL HAVE TWO LOAD BALANCERS SO HOLD OFF ON PROVISIONING LOAD BALANCERS, and also we will have 3 masters instead of two

echo "[Set Up Load Balancers | loadbalancer1 & loadbalancer2)]"
##### Install Keepalived & Haproxy
echo "[TASK 1] Update and install keepalived haproxy"
apt update -qq >/dev/null 2>&1
apt install -qq -y keepalived >/dev/null 2>&1
apt install -qq -y haproxy >/dev/null 2>&1


##### configure keepalived
echo "[TASK 2] Configure keepalived"
##### On both nodes create the health check script /etc/keepalived/check_apiserver.sh
cat >> /etc/keepalived/check_apiserver.sh <<EOF
#!/bin/sh

errorExit() {
  echo "*** $@" 1>&2
  exit 1
}

curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
if ip addr | grep -q 172.16.16.100; then
  curl --silent --max-time 2 --insecure https://172.16.16.100:6443/ -o /dev/null || errorExit "Error GET https://172.16.16.100:6443/"
fi
EOF

chmod +x /etc/keepalived/check_apiserver.sh

##### Create keepalived config /etc/keepalived/keepalived.conf

cat >> /etc/keepalived/keepalived.conf <<EOF
vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  timeout 10
  fall 5
  rise 2
  weight -2
}

vrrp_instance VI_1 {
    state BACKUP
    interface eth1
    virtual_router_id 1
    priority 100
    advert_int 5
    authentication {
        auth_type PASS
        auth_pass mysecret
    }
    virtual_ipaddress {
        172.16.16.100
    }
    track_script {
        check_apiserver
    }
}
EOF

##### Enable & start keepalived service
systemctl enable --now keepalived


##### Configure haproxy
echo "[TASK 3] Configure haproxy"
cat >> /etc/haproxy/haproxy.cfg <<EOF

frontend kubernetes-frontend
  bind *:6443
  mode tcp
  option tcplog
  default_backend kubernetes-backend

backend kubernetes-backend
  option httpchk GET /healthz
  http-check expect status 200
  mode tcp
  option ssl-hello-chk
  balance roundrobin
    server kmaster1 172.16.16.101:6443 check fall 3 rise 2
    server kmaster2 172.16.16.102:6443 check fall 3 rise 2
    server kmaster3 172.16.16.103:6443 check fall 3 rise 2

EOF

##### Enable & restart haproxy service
systemctl enable haproxy && systemctl restart haproxy

# Enable ssh password authentication
echo "[TASK 8] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "[TASK 9] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
