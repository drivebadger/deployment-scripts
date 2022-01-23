#!/bin/sh

PASSFILE=/opt/deployment-scripts/config/master-luks-password.txt
DEVLIST=/opt/deployment-scripts/config/drivebadger-devices.txt
LOCAL=/opt/deployment-scripts/config/local-drives.txt

DISK=$1  # eg. ata-SanDisk_SD9SN8W2T00_19359H123456
ARCH=$2  # eg. amd64
IMAGE=/opt/deployment-scripts/iso/kali-linux-2021.4a-live-$ARCH.iso

if [ "$2" = "" ]; then
	echo "USAGE: $0 <disk> <architecture> [--plain]"
	exit 1
elif [ ! -f $IMAGE ]; then
	echo "ERROR: $IMAGE not found (you need to download image for chosen architecture: $2)"
	exit 1
elif [ ! -e /dev/disk/by-id/$DISK ]; then
	echo "ERROR: $DISK not found"
	exit 1
elif grep -qxF $DISK $DEVLIST; then
	echo "ERROR: disk $DISK already configured"
	exit 1
elif grep -qxF $DISK $LOCAL; then
	echo "ERROR: disk $DISK is a local drive"
	exit 1
fi

DEVICE=`readlink -f /dev/disk/by-id/$DISK |cut -d'/' -f3`

if grep -q "$DEVICE " /proc/mounts; then
	echo "ERROR: disk $DISK is mounted (as device $DEVICE)"
	exit 1
fi

echo "copying image $IMAGE"
echo "to device /dev/$DEVICE"
dd if=$IMAGE of=/dev/$DEVICE status=progress

echo "adding new partition"
parted /dev/$DEVICE --script -- mkpart primary 10GB 100%
mkdir -p /mnt/drivebadger_setup

if [ "$3" = "--plain" ]; then
	mkfs.ext4 -m 0 -L persistence /dev/${DEVICE}3
	mount /dev/${DEVICE}3 /mnt/drivebadger_setup
else
	echo "configuring LUKS encryption"
	cat $PASSFILE |cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 luksFormat /dev/${DEVICE}3
	cat $PASSFILE |cryptsetup luksOpen /dev/${DEVICE}3 drivebadger_setup
	mkfs.ext4 -m 0 -L persistence /dev/mapper/drivebadger_setup
	mount /dev/mapper/drivebadger_setup /mnt/drivebadger_setup
fi

echo "setting up persistent filesystem contents"
/opt/deployment-scripts/drivebadger/install.sh /mnt/drivebadger_setup
umount /mnt/drivebadger_setup

if [ "$3" != "--plain" ]; then
	cryptsetup luksClose drivebadger_setup
fi

echo "adding $DISK to device list $DEVLIST"
echo $DISK >>$DEVLIST
