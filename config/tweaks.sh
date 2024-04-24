#!/bin/bash
#
# Tweak some kernel parameters
#
sysctl -w vm.stat_interval=120
sysctl -w net.core.rmem_default=10000000
sysctl -w net.core.wmem_default=10000000
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216


