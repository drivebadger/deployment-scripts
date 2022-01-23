#!/bin/sh

DEVLIST=/opt/deployment-scripts/config/drivebadger-devices.txt

for D in `cat $DEVLIST`; do
	if [ -e /dev/disk/by-id/$D ]; then
		echo $D
	fi
done
