#!/bin/sh

PASSFILE=/opt/deployment-scripts/config/master-luks-password.txt

DISK=$1  # ata-SanDisk_SD9SN8W2T00_19359H123456
PART=$2  # 3

LABEL=`/opt/deployment-scripts/drivebadger/get-label.sh $DISK`
PARTITION=`readlink -f /dev/disk/by-id/$DISK-part$PART |cut -d'/' -f3`

mountpoint=/mnt/${LABEL}_${PARTITION}
mkdir -p $mountpoint

if grep -q " $mountpoint " /proc/mounts; then
	echo "$mountpoint already mounted"
	exit 0
fi


if [ "`blkid /dev/$PARTITION |grep crypto_LUKS`" = "" ]; then
	mount /dev/$PARTITION $mountpoint
else
	cat $PASSFILE |cryptsetup -q luksOpen /dev/$PARTITION luks_$PARTITION
	if [ -e /dev/mapper/luks_$PARTITION ]; then
		mount /dev/mapper/luks_$PARTITION $mountpoint
		echo "mounted in $mountpoint"
	else
		exit 1
	fi
fi
