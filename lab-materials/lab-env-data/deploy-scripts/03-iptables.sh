#!/bin/bash

systemctl disable firewalld
systemctl stop firewalld
iptables -F

#iptables-restore iptables.save
