#!/bin/sh

ls /dev/disk/by-id/ata-* /dev/disk/by-id/usb-* 2>/dev/null \
	|grep -v -- -part \
	|grep -v VBOX \
	|grep -v QEMU \
	|grep -v VMware \
	|grep -v CF_CARD \
	|cut -d'/' -f 5 \
	|grep -vixFf /opt/deployment-scripts/config/drivebadger-devices.txt \
	|grep -vixFf /opt/deployment-scripts/config/local-drives.txt
