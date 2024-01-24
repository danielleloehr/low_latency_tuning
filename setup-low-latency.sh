#!/bin/bash
#
# Test script, sets up a network interface (ge3 or xe0) for low latency packet collection
#
# Usage: 
#
# Calls
#           tweaks.sh               Change kernel parameters
#           setup_driver.sh         Apply network driver settings
#           cpu_isolate.sh          Isolate CPU <>
#           bind_network_irqs.sh    Bind network IRQs to CPU2
#           set_ifconfig.sh         Assign IP address 



usage="$(basename "$0") [-h] [-c] [-a eth] -- Sets up ethernet interface for low latency networking

where:
    -h  show this help text
    -c  set permissions for config scripts
    -a  optimise <eth> Ethernet interface"

files=( "tweaks.sh" 
        "setup_driver.sh" 
        "cpu_isolate.sh" 
        "bind_network_irqs.sh" 
        "set_ifconfig.sh" 
        "optimise_cpu.sh")


chmod_X()
{   
    echo "Set file permissions"
    for file in ${files[@]}
    do
        CONFIG_FILE=$(realpath $file)
        chmod +x $CONFIG_FILE
    done
    echo "Done"
}


run_all()
{
    for file in ${files[@]}
    do
        CONFIG_FILE=$(realpath $file)
    done
}


while getopts ":hca:" option; do
    case $option in
        h) # display Help
            echo "$usage"
            exit;;
        c)  # call chmod on all
            chmod_X
            exit;;
        a)  # run all
            initial+=("$OPTARG")
            ;;
        :)  printf "missing argument for -%s\n" "$OPTARG"
            echo "$usage"
            exit 1
             ;;
        \?) # incorrect option
            echo "Error: invalid option"
            echo "$usage"
            exit;;
    esac
done

    #echo $initial
    #echo "The whole list of values is '${initial[@]}'"


# Setup driver
echo "Setup driver for interface $initial"
./config/setup_driver.sh $initial

# Optimise CPU
echo "Disable hyper-threading and adjust scaling governor"
./config/optimise_cpu.sh

# Isolate CPU 2
echo "Isolate CPU 2 for network operations"
./config/cpu_isolate.sh 2

# Bind network IRQs to CPU2                
echo "Bind $initial interrupts to CPU2"
./config/bind_network_irqs.sh $initial

# Assign IP address 
echo "Configure $initial with the correct IP address"
./config/set_ifconfig.sh $initial

# Additional optimisation steps
echo "The last adjustments..."
./config/tweaks.sh

echo "Please make sure IRQ binding was succesful!"
