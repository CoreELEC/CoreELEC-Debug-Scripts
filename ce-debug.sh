#!/bin/bash
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)
#
# Collect output from all CoreELEC Debug Scripts
#
#####################################################
#
# Comand Line Arguments
# -l = Show local only
#
#####################################################

OUTPUTFILE="/storage/ce-debug_info.txt"

# source helper functions
. debug-scripts-helper.sh

printf "CoreELEC Debug Information...\n\n" > $OUTPUTFILE

fancycat "/etc/os-release" "Not Found!"
fancycat "/proc/device-tree/coreelec-dt-id" "Not Found!"
fancycat "/proc/device-tree/le-dt-id" "Not Found!"
fancycat "/proc/cmdline" "Not Found!"
fancycat "/storage/.config/boot.hint" "Not Found!"
fancycat "/storage/.config/boot.status" "Not Found!"
fancycat "/flash/boot.ini"  "Not Found!"
fancycat "/flash/config.ini"  "Not Found!"
fancycat "/flash/dtb.xml"  "Not Found!"
fancycattail "/flash/cfgload" "-c +73" "Not Found!"
fancycattail "/flash/aml_autoscript" "-c +73" "Not Found!"
fancycat "/storage/.config/autostart.sh" "Unset by user!"
fancycat "/storage/init-previous.log" "Not Found!"

header "fw_printenv"
if [ -e /dev/env ]; then
    printf "\n" >> $OUTPUTFILE
    fw_printenv >> $OUTPUTFILE
else
    printf "Not found! || Not a TV Box?\n" >> $OUTPUTFILE
fi

header "lsmod"
printf "\n" >> $OUTPUTFILE
lsmod >> $OUTPUTFILE
header "lsusb"
printf "\n" >> $OUTPUTFILE
lsusb >> $OUTPUTFILE

printf "\n" >> $OUTPUTFILE
if [ -x ./dispinfo.sh ]; then
    ./dispinfo.sh -r >> $OUTPUTFILE
else
    dispinfo -r >> $OUTPUTFILE
fi

printf "\n" >> $OUTPUTFILE
if [ -x ./remoteinfo.sh ]; then
    ./remoteinfo.sh -r >> $OUTPUTFILE
else
    remoteinfo -r >> $OUTPUTFILE
fi

printf "\n" >> $OUTPUTFILE
if [ -x ./audinfo.sh ]; then
    ./audinfo.sh -r >> $OUTPUTFILE
else
    audinfo -r >> $OUTPUTFILE
fi

if [ "$1" = "-l" ]; then
    cat $OUTPUTFILE
else
    paste $OUTPUTFILE
fi
