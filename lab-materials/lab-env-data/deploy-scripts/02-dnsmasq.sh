#!/bin/bash

curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/hypervisor/forcedns -o /etc/NetworkManager/dispatcher.d/forcedns
chmod +x /etc/NetworkManager/dispatcher.d/forcedns
systemctl restart NetworkManager
/etc/NetworkManager/dispatcher.d/forcedns

rm -f /var/lib/libvirt/dnsmasq/ocp4*
kcli create network -c 192.168.125.0/24 --nodhcp --domain 5g-deployment.lab 5gdeploymentlab

sudo dnf -y install dnsmasq
mkdir -p /opt/dnsmasq/include.d/

curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/dnsmasq.conf -o /opt/dnsmasq/dnsmasq.conf
curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/upstream-resolv.conf -o /opt/dnsmasq/upstream-resolv.conf
curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/hub.ipv4 -o /opt/dnsmasq/include.d/hub.ipv4
curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/sno1.ipv4 -o /opt/dnsmasq/include.d/sno1.ipv4
curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/sno2.ipv4 -o /opt/dnsmasq/include.d/sno2.ipv4
curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/infrastructure-host.ipv4 -o /opt/dnsmasq/include.d/infrastructure-host.ipv4
curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/dnsmasq-virt.service -o /etc/systemd/system/dnsmasq-virt.service

echo "systemd restart and reload"
dnf install policycoreutils-python-utils -y
touch /opt/dnsmasq/hosts.leases
semanage fcontext -a -t dnsmasq_lease_t /opt/dnsmasq/hosts.leases
restorecon /opt/dnsmasq/hosts.leases
systemctl daemon-reload
systemctl enable --now dnsmasq-virt
systemctl mask dnsmasq

