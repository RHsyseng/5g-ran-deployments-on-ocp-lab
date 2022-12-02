#!/bin/bash

INSTALL_PATH="/home/lab-user/success"

curl -sL https://raw.githubusercontent.com/RHsyseng/5g-ran-deployments-on-ocp-lab/main/lab-materials/lab-env-data/hub-cluster/hub.yml -o ${INSTALL_PATH}/kcli-openshift4-baremetal/hub.yml
cp ${INSTALL_PATH}/openshift_pull.json /home/lab-user/success/kcli-openshift4-baremetal/openshift_pull.json

cd ${INSTALL_PATH}/kcli-openshift4-baremetal/
kcli create plan --pf hub.yml --force
