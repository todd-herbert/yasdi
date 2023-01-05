#!/bin/bash

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]
then
    echo 'Please run as root' 1>&2
    exit 1
fi

if [ ! -f "./build/install_manifest.txt" ]
then
	echo 'Not yet installed'
	exit 1
fi

xargs rm < ./build/install_manifest.txt
rm -rf ./build
ldconfig
