#!/bin/bash

curl -L http://infra.5g-deployment.lab:3000/student/5g-ran-deployments-on-ocp-lab/raw/branch/main/lab-materials/lab-env-data/hypervisor/ssh-key -o /root/.ssh/snokey
chmod 400 /root/.ssh/snokey
oc apply -f https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/hub-cluster/sno1-argoapp.yaml
