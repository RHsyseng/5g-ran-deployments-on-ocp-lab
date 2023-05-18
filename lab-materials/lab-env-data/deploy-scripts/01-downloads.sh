#!/bin/bash

dnf -y copr enable karmab/kcli
dnf -y install kcli bash-completion vim jq tar

curl -L https://github.com/karmab/tasty/releases/download/v0.9.0/tasty-linux-amd64 -o /usr/bin/tasty
chmod +x /usr/bin/tasty

kcli download oc -P version=stable -P tag='4.11'
kcli download kubectl -P version=stable -P tag='4.11'
mv kubectl oc /usr/bin/

curl -L https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest-4.13/openshift-client-linux.tar.gz -o openshift-client-linux.tar.gz
tar xvfz openshift-client-linux.tar.gz
mv kubectl oc /usr/bin/
rm -f openshift-client-linux.tar.gz README.md

echo "clean up.."
kcli delete vm -y ocp4-bastion ocp4-master1 ocp4-master2 ocp4-master3 ocp4-worker2 ocp4-worker1 ocp4-worker3
