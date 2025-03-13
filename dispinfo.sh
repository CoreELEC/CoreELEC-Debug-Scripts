#!/bin/bash
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)
#
# Collect CoreELEC display information
#
#####################################################
#
# Comand Line Arguments
# -l = Show local only
# -r = Remove items that are redundant between debug scripts, and show local only
#
#####################################################

OUTPUTFILE="/storage/dispinfo.txt"

# source helper functions
. debug-scripts-helper.sh

printf "CoreELEC Display Information...\n\n" > $OUTPUTFILE

if [ "$1" != "-r" ]; then
    fancycat "/etc/os-release" "Not Found!"
    fancycat "/proc/device-tree/coreelec-dt-id" "Not Found!"
    fancycat "/proc/device-tree/le-dt-id" "Not Found!"
    fancycat "/proc/device-tree/amlogic-dt-id" "Not Found!"
    fancycat "/proc/cmdline" "Not Found!"
fi
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/edid" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/edid_parsing" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/rawedid" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/config" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/dc_cap" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/dv_cap" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/attr" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/disp_cap" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/vesa_cap" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/preferred_mode" "Not Found!"
fancycat "/sys/devices/virtual/amhdmitx/amhdmitx0/hdr_cap" "Not Found!"
fancycat "/sys/module/aml_media/parameters/hdr_mode" "Not Found!"
fancycat "/sys/module/aml_media/parameters/sdr_mode" "Not Found!"
fancycat "/sys/module/aml_media/parameters/video_process_status" "Not Found!"
fancycat "/sys/module/aml_media/parameters/hdr_policy" "Not Found!"
fancycat "/sys/class/display/vinfo" "Not Found!"

header "kodi display settings"
if [ -f /storage/.kodi/userdata/guisettings.xml ]; then
    printf "\n" >> $OUTPUTFILE
    for tag in "coreelec.amlogic.limitcd" \
               "coreelec.amlogic.forcecs" \
               "coreelec.amlogic.noisereduction" \
               "coreelec.amlogic.hdr2sdr" \
               "coreelec.amlogic.sdr2hdr" \
               "coreelec.amlogic.sdr2dv" \
               "coreelec.amlogic.hdr2dv" \
               "coreelec.amlogic.disabledolbyvision" \
               "coreelec.amlogic.dolbyvisionled" \
               "videoplayer.adjustrefreshrate" \
               "videoplayer.useamcodec" \
               "videoplayer.useamcodech264" \
               "videoplayer.useamcodecmpeg2" \
               "videoplayer.useamcodecmpeg4" \
               "videoplayer.usedisplayasclock" \
               "videoscreen.whitelist" \
               "lookandfeel.skin"
    do
        printf "$tag: " >> $OUTPUTFILE
        value=$(cat /storage/.kodi/userdata/guisettings.xml |grep "\"$tag\"" |grep -o '>.*<' |sed -E 's/[<>]//g')
        [ -n "$value" ] && printf "$value" >> $OUTPUTFILE
        printf "\n" >> $OUTPUTFILE
    done
else
    printf " Not Found!\n" >> $OUTPUTFILE
fi

if [ "$1" != "-r" ]; then
    fancycat "/flash/boot.ini"  "Not Found!"
    fancycat "/flash/config.ini"  "Not Found!"
    fancycat "/flash/resolution.ini"  "Not Found!"
    fancycat "/storage/.config/autostart.sh" "Unset by user!"
fi

if [ "$1" = "-l" ] || [ "$1" = "-r" ]; then
    cat $OUTPUTFILE
else
    paste $OUTPUTFILE
fi
