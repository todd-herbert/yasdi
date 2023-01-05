# YASDI SDK - With RS485 support on Raspberry Pi


In this fork, the YASDI serial driver has been modified so that the *DE / RE* signal for RS485 communication is output to a GPIO pin of a Raspberry Pi. 

This *should* enable RS485 communication, using a cheap RS485 module.

![RS485 Module](/docs/module.jpg)



### Disclaimer

This repository is fork of a mirror for the [SDK sources provided by SMA](https://www.sma.de/en/products/apps-software/yasdi.html) found in the [sdk](sdk) directory of this repository to make things more convenient, which is not actively developed.

### Building

Clone the repo and run the `build_raspi.sh` script. All going well, it should grab the dependencies, build the software, and configure the UART port. You will need to specify the GPIO port you wish to use for the DE / RE signal. GPIO18 is located conveniently below the UART pins.

```
sudo ./build_raspi.sh 18
```

### Suported Platforms
Tested working on RaspiOS Bullseye, on a Pi Zero 1.3.