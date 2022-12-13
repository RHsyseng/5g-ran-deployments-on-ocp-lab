#!/bin/bash

echo "Creating the stopped vms..."
kcli delete -y pool images
kcli create pool -p /var/lib/libvirt/images default

kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:01:01"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0101 hub-master0
kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:01:02"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0102 hub-master1
kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=48000 -P numcpus=16 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:01:03"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0103 hub-master2

kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=24000 -P numcpus=12 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:02:01"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0201 sno1
kcli create vm -P start=False -P uefi_legacy=true -P plan=hub -P memory=24000 -P numcpus=12 -P disks=[200,200] -P nets=['{"name": "5gdeploymentlab", "mac": "aa:aa:aa:aa:03:01"}'] -P uuid=aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaa0301 sno2
