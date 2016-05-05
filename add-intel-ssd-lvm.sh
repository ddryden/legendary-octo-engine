#!/bin/bash
# Intel 910 800GB SSD's actualy present 4x200GB drives.

if [ $# -lt 4 ]; then
        echo "This script will overwrite the partition table on the devices"
        echo "listed."
        echo "If you wanted to partion an Intel 910 that presented its 4 disks"
        echo "as sdb, sdc, sdd and sde you would follow the example:"
        echo ""
        echo "    $0 b c d e"
        exit 1
fi


function partition_disk() {
        parted -a optimal /dev/sd$1 mklabel gpt;
        parted -a optimal -- /dev/sd$1 mkpart primary 1 -1;
        parted -a optimal /dev/sd$1 set 1 lvm on;
        pvcreate /dev/sd${1}1;
}


for i in $1 $2 $3 $4;
do
        partition_disk $i;
done

vgcreate pciessd /dev/sd${1}1 /dev/sd${2}1 /dev/sd${3}1 /dev/sd${4}1

#  Now you just need to make a logical volume (or twelve) and formate with your
#  chosen file system.
# e.g.
# maxsize=$(vgs | grep pciessd | awk '{print $7}')
# lvcreate -L$maxsize -i 4 -n postgres pciessd /dev/sd${1}1 /dev/sd${2}1 /dev/sd${3}1 /dev/sd${4}1
# mkfs.xfs /dev/pciessd/postgres

