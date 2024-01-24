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
#           optimise_cpu.sh         Disables hyper-threading and changes scaling governors to performance mode



usage="$(basename "$0") [-h] [-c] [-a eth] -- Sets up ethernet interface for low latency networking and applies misc OS tuning parameters

where:
    -h  show this help text
    -x  set permissions for config scripts in CONFIG folder
    -a  optimise <eth> Ethernet interface
    
By default, CPU2 will be isolated!"


CONFIG_FOLDER="config"

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
        CONFIG_FILE=$(realpath $CONFIG_FOLDER/$file)
        chmod +x $CONFIG_FILE
    done
    echo "Done"
}


run_all()
{
    for file in ${files[@]}
    do
        CONFIG_FILE=$(realpath $CONFIG_FOLDER/$file)
    done
}


while getopts ":hxa:" option; do
    case $option in
        h) # display Help
            echo "$usage"
            echo
            exit;;
        x)  # call chmod on all
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

echo
# Setup driver
echo -e "--------------------------------------------------"
echo "Setup driver for interface $initial"
./config/setup_driver.sh $initial
echo "Done."
echo -e "--------------------------------------------------"


# Optimise CPU
echo "Disable hyper-threading and adjust scaling governor"
./config/optimise_cpu.sh
echo "Done."
echo -e "--------------------------------------------------"

# Isolate CPU 2
echo "Isolate CPU 2 for network operations"
./config/cpu_isolate.sh 2
echo "Done."
echo -e "--------------------------------------------------"

# Bind network IRQs to CPU2              
echo "Bind $initial interrupts to CPU2"
./config/bind_network_irqs.sh $initial
echo "Done."
echo -e "--------------------------------------------------"

# Assign IP address 
echo "Configure $initial with the correct IP address"
./config/set_ifconfig.sh $initial
echo "Done."
echo -e "--------------------------------------------------"

# Additional optimisation steps
echo "The final adjustments..."
./config/tweaks.sh
echo "Done."
echo -e "--------------------------------------------------"

echo "Please make sure IRQ binding was succesful!"
echo -e "--------------------------------------------------"
