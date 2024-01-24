#!/bin/bash

# Disable all hyper-threading

echo -e "Disabling CPU4, CPU5, CPU6, CPU7"
echo 0 > /sys/devices/system/cpu/cpu4/online
echo 0 > /sys/devices/system/cpu/cpu5/online
echo 0 > /sys/devices/system/cpu/cpu6/online
echo 0 > /sys/devices/system/cpu/cpu7/online

# Run all CPUs at maximum frequency

echo -e "Setting governor for CPU0, CPU1, CPU2, CPU3 to PERFORMANCE mode"
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
