#!/bin/sh

# well tested version
FILE=2021-05-07-raspios-buster-armhf-lite.zip
wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/$FILE
unzip -b $FILE
rm -f $FILE

# latest available version
FILE=2021-10-30-raspios-bullseye-armhf-lite.zip
wget https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-11-08/$FILE
unzip -b $FILE
rm -f $FILE
