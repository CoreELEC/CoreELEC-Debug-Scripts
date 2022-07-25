#!/bin/bash
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)
#
# Collect CoreELEC remote control configuration information
#
#####################################################
#
# Comand Line Arguments
# -l = Show local only
# -r = Remove items that are redundant between debug scripts, and show local only
#
#####################################################

OUTPUTFILE="/storage/remoteinfo.txt"

# source helper functions
. debug-scripts-helper.sh

printf "CoreELEC Remote Control Information...\n\n" > $OUTPUTFILE

if [ "$1" != "-r" ]; then
    fancycat "/etc/os-release" "Not Found!"
    fancycat "/proc/device-tree/coreelec-dt-id" "Not Found!"
    fancycat "/proc/device-tree/le-dt-id" "Not Found!"
    fancycat "/proc/cmdline" "Not Found!"
fi

fancycat "/proc/device-tree/meson-ir/status" "Not Found!"
fancycat "/proc/device-tree/meson-remote/status" "Not Found!"
fancychk "/storage/.config/remote.disable"
fancychk "/flash/remote.disable"
wildcat "/storage/.config/remote*.conf" "Unset by user!"
wildcat "/flash/remote*.conf" "Unset by user!"
fancycat "/storage/.config/lircd.conf" "Unset by user!"
fancycat "/storage/.config/lirc_options.conf" "Unset by user!"
fancycat "/storage/.config/rc_maps.cfg" "Unset by user!"
fancycatdir "/storage/.config/rc_keymaps" "*" "Unset by user!"
fancycat "/storage/.kodi/userdata/Lircmap.xml" "Unset by user!"
fancycat "/storage/.kodi/userdata/keyboard.xml" "Unset by user!"
fancycatdir "/storage/.kodi/userdata/keymaps" "*.xml" "Unset by user!"

header "BL301"
if [ -x /usr/sbin/checkbl301 ]; then
  printf "\n" >> $OUTPUTFILE
  /usr/sbin/checkbl301 -v >> $OUTPUTFILE
else
  printf "\ncheckbl301 not found!\n" >> $OUTPUTFILE
fi

if [ "$1" != "-r" ]; then
    fancycat "/flash/boot.ini" "Not Found!"
    fancycat "/flash/config.ini" "Not Found!"
    fancycat "/storage/.config/autostart.sh" "Unset by user!"
fi

if [ "$1" = "-l" ] || [ "$1" = "-r" ]; then
    cat $OUTPUTFILE
else
    paste $OUTPUTFILE
fi
