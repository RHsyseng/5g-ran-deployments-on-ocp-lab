#!/bin/bash

echo "Creating the stopped vms..."
kcli delete -y pool images
kcli create pool -p /var/lib/libvirt/images default
kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:01:01"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0101 hub-master0
kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:01:02"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0102 hub-master1 
kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:01:03"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0103 hub-master2
#kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:01:04"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0104 hub-worker0
#kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:01:05"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0105 hub-worker1

kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:02:01"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0201 sno1
kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:03:01"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0301 sno2

#echo "Setting up the hub.yml parameter file inspecting the id of the VMs"
#MASTER0=$(kcli info vm hub-master0 -f id -v)
#MASTER1=$(kcli info vm hub-master1 -f id -v)
#MASTER2=$(kcli info vm hub-master2 -f id -v)
#WORKER0=$(kcli info vm hub-worker0 -f id -v)
#WORKER1=$(kcli info vm hub-worker1 -f id -v)
#
#sed -i "s/MASTER0/${MASTER0}/g" /root/kcli-openshift4-baremetal/hub.yml
#sed -i "s/MASTER1/${MASTER1}/g" /root/kcli-openshift4-baremetal/hub.yml
#sed -i "s/MASTER2/${MASTER2}/g" /root/kcli-openshift4-baremetal/hub.yml
#sed -i "s/WORKER0/${WORKER0}/g" /root/kcli-openshift4-baremetal/hub.yml
#sed -i "s/WORKER1/${WORKER1}/g" /root/kcli-openshift4-baremetal/hub.yml
