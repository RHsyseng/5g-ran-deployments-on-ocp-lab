#!/bin/bash

dnf install haproxy -y
semanage port -a -t http_port_t -p tcp 6443
curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/haproxy/haproxy.cfg -o /etc/haproxy/haproxy.cfg
systemctl enable haproxy --now

echo "flushing iptables..."
iptables -F
