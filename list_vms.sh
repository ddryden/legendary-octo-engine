#!/bin/bash
# Connect to each Libvirt hypervisor and list VM's or server utilisation

FILEPATH="data/vmhosts"
if [ ! -f $FILEPATH ]; then
	echo "You need fill data/vmhosts with hostnames or IP address of the hypervisors."
	exit 1
fi

flag_all=0
flag_util=0

if [ "$1" == "--all" ]; then
	flag_all=1
fi
if [ "$1" == "--util" ]; then
        flag_util=1
fi

echoplus=figlet
if ! hash figlet 2>/dev/null; then
	echoplus=echo
fi

for hyper in `cat $FILEPATH`
do
	$echoplus $hyper
	if [ $flag_all -eq 1 ]; then
		ssh root@$hyper 'virsh list --all'
	elif [ $flag_util -eq 1 ]; then
		ssh root@$hyper 'echo -n "CPU# "; cat /proc/cpuinfo | grep processor | wc -l; uptime; free -h; vgs'
		#ssh root@$hyper 'uptime; free -h; lshw -class memory; vgs'
	else
		ssh root@$hyper 'virsh list'
	fi
done

