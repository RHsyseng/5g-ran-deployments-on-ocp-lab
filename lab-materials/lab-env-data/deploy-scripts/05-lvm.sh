#!/bin/bash

pvcreate /dev/sdb /dev/sdc
vgextend vg.libvirt /dev/sdb /dev/sdc
lvextend -l +100%FREE /dev/vg.libvirt/lvimages
resize2fs /dev/mapper/vg.libvirt-lvimages
rm -rf /var/lib/libvirt/images/*
