#!/bin/bash 

#
# Setup interface e.g. ge3 for 1gbe, xe0 for 10gbe
#
ethtool -C $1 adaptive-rx off adaptive-tx off
ethtool -C $1 rx-usecs 0 
ethtool -C $1 tx-usecs 0
ethtool -G $1 rx 4096 tx 4096



