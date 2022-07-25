#!/bin/bash
#
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2022-present Team CoreELEC (https://coreelec.org)

header()
{
  line='+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  printf "%s++\n+ %s +\n%s++" "${line:0:${#1}+2}" "$1" "${line:0:${#1}+2}" >> $OUTPUTFILE
}

fancycat()
{
# $1 = file $2 = message if file not found
    header "$1"
    if [ -f $1 ]; then
        printf "\n" >> $OUTPUTFILE
        printf "%s\n" "$(tr -d '\0' < $1)" >> $OUTPUTFILE
    else
        printf "\n%s\n" "$2" >> $OUTPUTFILE
    fi
}

fancycattail()
{
# $1 = file $2 = options $3 = message if file not found
    header "$1"
    if [ -f $1 ]; then
        printf "\n" >> $OUTPUTFILE
        printf "%s\n" "$(tail $2 $1)" >> $OUTPUTFILE
    else
        printf "\n%s\n" "$3" >> $OUTPUTFILE
    fi
}

fancychk()
{
   header "$1"
    if [ -f $1 ]; then
        printf "\nSet by user!\n" >> $OUTPUTFILE
    else
        printf "\nUnset by user!\n" >> $OUTPUTFILE
    fi
}

fancycatdir()
{
# $1 = directory $2 = filename pattern $3 = message if file not found
    header "$1"
    if [ -d $1 ]; then
        printf "\n" >> $OUTPUTFILE
        for filename in $1/$2
        do
            [ -e $filename ] || continue
            if [ -f $filename ]; then
                fancycat $filename $3
            fi
        done
    else
        printf "\nDirectory Not Found!\n"
    fi
}

wildcat()
{
# $1 = filename pattern $2 = message if file not found
    header "$1"
    if [ -e $1 ]; then
        printf "\n" >> $OUTPUTFILE
        for filename in $1
        do
            [ -e $filename ] || continue
            if [ -f $filename ]; then
                fancycat $filename $2
            fi
        done
    else
        printf "\n%s\n" "$2" >> $OUTPUTFILE
    fi
}
