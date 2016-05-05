#!/bin/bash
VERSION=59
DOMAIN=openbsd$VERSION
CDROM=~/Downloads/cd$VERSION.iso
IMAGEFILE=~/$DOMAIN.qcow2
NETWORKOPS="user,model=virtio"
#NETWORKOPS="bridge=br0,model=virtio"

virt-install \
        --connect=qemu:///system \
        --name="${DOMAIN}" \
        --ram=2048 \
        --vcpus=4 \
        --description 'OpenBSD virt-install with serial' \
        --os-type=unix \
        --os-variant=openbsd4 \
        --cdrom=${CDROM} \
        --disk path=${IMAGEFILE},size=1,bus=virtio \
        --network ${NETWORKOPS} \
        --graphics vnc \
        --serial dev,path=/dev/ttyS0

