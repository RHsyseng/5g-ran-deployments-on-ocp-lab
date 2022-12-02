#!/bin/bash

systemctl disable firewalld
systemctl stop firewalld

iptables -A LIBVIRT_INP -i 5gdeploymentlab -p tcp -m tcp --dport 8443 -j ACCEPT
iptables -A LIBVIRT_INP -i 5gdeploymentlab -p tcp -m tcp --dport 9000 -j ACCEPT
iptables -A LIBVIRT_INP -i 5gdeploymentlab -p tcp -m tcp --dport 3000 -j ACCEPT

echo "haproxy ports..."
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT


#iptables-restore iptables.save
