#!/bin/sh

DISK=$1  # ata-SanDisk_SD9SN8W2T00_19359H123456

echo $DISK |cut -d'-' -f2- |cut -d'_' -f1 |tr '[:upper:]' '[:lower:]'
