#!/bin/bash
#
# Isolate a single CPU core
# 

cpucore=$1 
cpumask=f   

case $1 in
    "0")
        cpumask=e
        ;;
    "1")
        cpumask=d
        ;;
    "2")
        cpumask=b
        ;;
    "3")
        cpumask=7
        ;;
    *)
        echo $1: not a valid core
        exit 1
        ;;   
esac

# List of IRQs 
# Relocating IRQ 0 upsets someone. Leave him where he is
#
irqs=`cat /proc/interrupts | awk '{print $1}' | grep ^[1-9] |tr ':' ' '`

for i in $irqs 
do
    echo $cpumask > /proc/irq/$i/smp_affinity	 
done
