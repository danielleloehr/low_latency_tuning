#!/bin/bash
#
# Set interface
#

ifconfig $1 1.1.2.1 netmask 255.255.0.0
echo -e "$1 IP: 1.1.2.1 Netmask: 255.255.0.0"
