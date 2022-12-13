#!/bin/bash

kcli create network -c 192.168.125.0/24 --nodhcp --domain 5g-deployment.lab 5gdeploymentlab

echo "clean up..."
rm -f /var/lib/libvirt/dnsmasq/ocp4*

dnf -y install dnsmasq policycoreutils-python-utils
mkdir -p /opt/dnsmasq/include.d/
curl -sL https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/dnsmasq.conf -o /opt/dnsmasq/dnsmasq.conf
curl -sL https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/upstream-resolv.conf -o /opt/dnsmasq/upstream-resolv.conf
curl -sL https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/hub.ipv4 -o /opt/dnsmasq/include.d/hub.ipv4
curl -sL https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/sno1.ipv4 -o /opt/dnsmasq/include.d/sno1.ipv4
curl -sL https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/sno2.ipv4 -o /opt/dnsmasq/include.d/sno2.ipv4
curl -sL https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/infrastructure-host.ipv4 -o /opt/dnsmasq/include.d/infrastructure-host.ipv4
curl -sL https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/dnsmasq/dnsmasq-virt.service -o /etc/systemd/system/dnsmasq-virt.service
touch /opt/dnsmasq/hosts.leases
semanage fcontext -a -t dnsmasq_lease_t /opt/dnsmasq/hosts.leases
restorecon /opt/dnsmasq/hosts.leases
systemctl daemon-reload
systemctl enable --now dnsmasq-virt
systemctl mask dnsmasq

curl -L https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/hypervisor/forcedns -o /etc/NetworkManager/dispatcher.d/forcedns
chmod +x /etc/NetworkManager/dispatcher.d/forcedns
systemctl restart NetworkManager
sleep 10
/etc/NetworkManager/dispatcher.d/forcedns
