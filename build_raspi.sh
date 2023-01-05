#!/bin/bash

# ===========================================================================
#  This script *should* build and install YASDI on a Raspberry Pi           
#                                                                                            
#  The YASDI serial driver has been modified to allow use with an RS485 adapter. 
#  RE / DE signals are output via a GPIO pin
# ===========================================================================

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]
then
    echo 'Please run as root, e.g. "sudo ./build_raspi.sh"' 1>&2
    exit 1
fi

# Check for arguments
if [ $# -ne 1 ]
then
    echo "Build and install YASDI for Raspberry pi, using specified GPIO_PIN as DE / RE for RS485"
    echo "Usage: sudo ./build_rasp.sh [GPIO_PIN]"
    exit
fi

# Validate GPIO pin number
if ! [[ $1 =~ ^[0-9]+$ ]] || [ $1 -lt 0 ] || [ $1 -gt 26 ]
then
        echo "Specified GPIO pin number invalid"
        echo "Usage: sudo ./build_rasp.sh [GPIO_PIN]"
        exit
fi

apt-get install build-essential cmake libgpiod-dev
rm -rf ./build
mkdir build
cd build
cmake ../sdk/projects/generic-cmake/ -DPIN=$1
make
make install
ldconfig