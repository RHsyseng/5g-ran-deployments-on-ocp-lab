#!/bin/bash

dnf -y copr enable karmab/kcli
dnf -y install kcli vim jq

curl -L https://github.com/karmab/tasty/releases/download/v0.9.0/tasty-linux-amd64 -o /usr/bin/tasty
chmod +x /usr/bin/tasty

curl -L https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest-4.11/openshift-client-linux.tar.gz -o openshift-client-linux.tar.gz
tar xvfz openshift-client-linux.tar.gz
mv kubectl oc /usr/bin/
rm -f openshift-client-linux.tar.gz README.md

kcli delete vm -y ocp4-bastion ocp4-master1 ocp4-master2 ocp4-master3 ocp4-worker2 ocp4-worker1 ocp4-worker3
