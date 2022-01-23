#!/bin/sh

DISK=$1  # ata-SanDisk_SD9SN8W2T00_19359H123456
PART=$2  # 3

LABEL=`/opt/deployment-scripts/drivebadger/get-label.sh $DISK`
PARTITION=`readlink -f /dev/disk/by-id/$DISK-part$PART |cut -d'/' -f3`

mountpoint=/mnt/${LABEL}_${PARTITION}

if ! grep -q " $mountpoint " /proc/mounts; then
	echo "$mountpoint not mounted"
	exit 0
fi

umount $mountpoint

if [ -e /dev/mapper/luks_$PARTITION ]; then
	cryptsetup luksClose luks_$PARTITION
fi
