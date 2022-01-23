#!/bin/sh

for D in `/opt/deployment-scripts/drivebadger/list-connected-devices.sh`; do
	echo "### attempting to mount $D"
	/opt/deployment-scripts/drivebadger/mount.sh $D 3
done
