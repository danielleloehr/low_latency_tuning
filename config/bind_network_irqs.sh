#!/bin/bash

#
# set IRQ affinity for a network interface to CPU2 (mask = 0x4)
#

irqlist=$(cat /proc/interrupts | grep $1 | awk -F ' ' '{print $1}' | tr -d ":")

echo -e "Binding the following IRQs:"
echo "$irqlist"
echo

for irq in $irqlist
do
	echo 4 > /proc/irq/$irq/smp_affinity
done

# stop irqbalance
systemctl stop irqbalance.service

