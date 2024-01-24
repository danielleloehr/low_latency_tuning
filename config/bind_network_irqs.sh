#!/bin/bash

#
# set IRQ affinity for a network interface to CPU2 (mask = 0x4)
#

irqlist=$(cat /proc/interrupts | grep $1 | awk -F ' ' '{print $1}' | tr -d ":")

echo "Binding the following IRQs: $irqlist"

for irq in $irqlist
do
	echo 4 > /proc/irq/$irq/smp_affinity
done


# case $1 in
# ge3)
# 	echo 4 > /proc/irq/174/smp_affinity
# 	echo 4 > /proc/irq/175/smp_affinity
# 	echo 4 > /proc/irq/176/smp_affinity
# 	echo 4 > /proc/irq/177/smp_affinity
# 	echo 4 > /proc/irq/178/smp_affinity
# 	;;
# xe0)
# 	echo 4 > /proc/irq/130/smp_affinity
# 	echo 4 > /proc/irq/131/smp_affinity
# 	echo 4 > /proc/irq/132/smp_affinity
# 	echo 4 > /proc/irq/133/smp_affinity
# 	echo 4 > /proc/irq/134/smp_affinity
# 	;;
# esac

# stop irqbalance
systemctl stop irqbalance.service

