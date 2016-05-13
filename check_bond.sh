#!/bin/bash

ethtool_installed=1
if ! hash ethtool 2>/dev/null; then
	echo "No ethtool"
	ethtool_installed=0
fi


# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Using_Channel_Bonding.html
function mii_supported( ) {
	if [ $ethtool_installed = 0 ]; then
		return 0
	fi
	# Do the slaves support media-independent interface(MII)
	interface=$1
	ethtool $interface | grep "Link detected:"
}


if [ ! -e /sys/class/net/bonding_masters ]; then
	echo "No bonds!"
	exit 1
fi

# Variable used for exit code so 0 == Happy. Anything else is bad times
happy_with_bonds=0
can_mii_mon=0

bond_masters=$(cat /sys/class/net/bonding_masters)
for bond in $bond_masters
do
        #Need at least 2 slaves
        read -a slaves <<< `cat /sys/class/net/$bond/bonding/slaves`
        if [ ${#slaves[@]} -lt 2 ]; then
                echo "You only have ${slaves[0]} in ${bond}!"
		echo "You need at least 2, please add more interfaces."
                happy_with_bonds=1
        fi

	for slave in slaves;
	do
		mii_supported $slave 
		if [ $? -ne 0 ]; then
			can_mii_mon=0
			echo "Interface $slave seems to not support MII monitoring."
			happy_with_bonds=1
		fi
	done

        # Mode should be active-backup
        bond_mode=$(cat /sys/class/net/$bond/bonding/mode)
        if [ "$bond_mode" != "active-backup 1" ]; then
                echo "$bond is in $bond_mode mode not active-backup!"
                happy_with_bonds=1
        fi

        miimon=$(cat /sys/class/net/$bond/bonding/miimon)
        if [ $miimon -ne 100 ]; then
                echo "miimon is $miimon not 200!"
                happy_with_bonds=1
        fi

        #arp_interval=$(cat /sys/class/net/$bond/bonding/arp_interval)
        #use_carrier=$(cat /sys/class/net/$bond/bonding/use_carrier)

	downdelay=$(cat /sys/class/net/$bond/bonding/downdelay)
	if [ $downdelay -ne 200 ]; then
		echo "downdelay==$downdelay not 200 :("
		happy_with_bonds=1
	fi

	updelay=$(cat /sys/class/net/$bond/bonding/updelay)
	if [ $updelay -ne 200 ]; then
                echo "updelay==$updelay not 200 :("
                happy_with_bonds=1
        fi

	num_grat_arp=$(cat /sys/class/net/$bond/bonding/num_grat_arp)
	if [ $num_grat_arp -ne 25 ]; then
		echo "num_grat_arp==$num_grat_arp not 25 :("
		happy_with_bonds=1
	fi
	
done

exit $happy_with_bonds
