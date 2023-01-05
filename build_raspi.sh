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
    echo 'Please run as root, e.g. "sudo ./build_raspi.sh" [GPIO_PIN]' 1>&2
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

# Get to it then..
# ==================

apt-get install build-essential cmake libgpiod-dev
rm -rf ./build
mkdir build
cd build
cmake ../sdk/projects/generic-cmake/ -DPIN=$1
make
make install
ldconfig

# Prepare a completion dialog, to be called after UART config
# =============================================================
all_done() {
    COMPLETION1='You can test your connection with the provided default configuration file.\n'
    COMPLETION2='\n'
    COMPLETION3='"yasdishell ./Raspi_RS485.ini"'

    whiptail --title "Installation Complete" --msgbox "$COMPLETION1$COMPLETION2$COMPLETION3" 12 60
}


# Offer to configure the UART port, if required
# ==================================================

if [ $(raspi-config nonint get_serial) -ne  1 ] || [ $(raspi-config nonint get_serial_hw) -ne 0 ]
then

        # If the UART isn't set right

        UARTPROMPT1="To interface with your RS485 module, you will need to enable UART, and disable the UART login shell.\n"
        UARTPROMPT2="\n"
        UARTPROMPT3="Your Pi will be rebooted as part of this process. \n"
        UARTPROMPT4="Would you like to open raspi-config and do this now?"

        if (whiptail --title "Installation Complete" --yesno "$UARTPROMPT1$UARTPROMPT2$UARTPROMPT3$UARTPROMPT4" 12 60)
        then
            # Open raspi-config to the correct area
            prompt_serial() {
                INTERACTIVE=True
                do_serial
                all_done
                echo "(would reboot here)"
            }
            . raspi-config nonint prompt_serial
        else
            exit
        fi
fi

# Completion dialog, but without reboot
all_done
echo "(no reboot)"