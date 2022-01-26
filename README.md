# Overview

This repository provides some scripts useful for deploying a large number of Drive Badger / Mobile Badger devices, having a similar configuration.

It may be useful, when preparing an attack on bigger company:

https://drivebadger.com/planning-the-big-attack.html


Note that these scripts don't arm the devices. It needs to be done manually, after first boot. It allows you to customize each device separately,
eg. load encryption keys assigned to particular device and its operator.

https://drivebadger.com/installing.html#arming-the-device

https://drivebadger.com/configuring-encryption-keys.html


# Configuration

## `drivebadger-devices.txt`

Contains `udev` aliases (as shown inside `/dev/disk/by-id` directory) of your already configured Drive Badger devices.
One alias per line, no empty lines and comments allowed. Example aliases:

```
ata-PNY_ELITE_PSSD_DC4ABCDEF1234567890A
ata-SanDisk_SD9SN8W2T00_19359H123456
usb-WD_My_Passport_264F_32303333312D345678901234-0:0
```

## `local-drives.txt`

Contains `udev` aliases (as shown inside `/dev/disk/by-id` directory) of your local drives, not related to Drive Badger - eg. boot drive.
These drives are protected from being accidentally formatted by scripts from this repository.

If you don't know, what is your boot drive, just disconnect all USB drives and check `/dev/disk/by-id` directory contents. Just add
all drives you see there to this file.

## `master-luks-password.txt`

This is your main LUKS password. It will be used to setup all devices (except these unencrypted, created with `--plain` argument).
It is a good practice, that you have 2 or even 3 separate passwords, just for yourself:

- first for quick, automatic deployment of new devices (stored in this file)
- second, your primary password per attack - configured for all drives assigned to a particular attack, and only there
- third, optional, your individual password for each drive, or group of drives (the smaller the better) - in case when you're forced to reveal the password, you should reveal this one

## ISO images

In `iso` directory you will find some scripts that will download ISO images, mainly for Kali Linux and Raspbian.

Before you start creating devices, you need to download these images (only once).

# Scripts for Drive Badger

## `configure-new-device.sh`

This is the main script. It writes ISO image to given drive, creates Kali persistent partition (encrypted or not), and uses `install.sh`
to preconfigure filesystem contents (all Drive Badger repositories etc.). Finally it adds the drive alias to `drivebadger-devices.txt` file.

It takes 3 arguments:
- drive alias - see examples above in `drivebadger-devices.txt` file description
- architecture - one of: `amd64`, `i386` or `arm64` (for Mac M1 devices)
- optional `--plain` - create device with unencrypted persistent partition (required to exfiltrate old hardware, see https://drivebadger.com/luks-performance.html#problematic-hardware)

If you leave 3rd argument empty, it will create LUKS-encrypted device(s) by default.

## `install.sh`

Create minimal set of files and directories to allow using given filesystem as Kali persistent partition.
Then, clone all Drive Badger Git repositories.

You can use this script separately from `configure-new-device.sh`, when you want to cleanup your Drive Badger
device without rewriting the ISO image - so:
- when you want to use a non-standard image and write it manually
- when you use a quickly degrading pen drive and don't want to reduce its lifetime

## `list-*-devices.sh`

There are 3 scripts, showing which Drive Badger devices (or other drives) are connected, and which are not:

- `list-connected-devices.sh` - lists `udev` aliases of all Drive Badger devices, that are registered in `drivebadger-devices.txt` file, currently connected to the computer and properly recognized by `udev`
- `list-disconnected-devices.sh` - lists `udev` aliases of all Drive Badger devices, that are registered in `drivebadger-devices.txt` file, but are not connected to the computer at the moment
- `list-unregistered-devices.sh` - lists `udev` aliases of currently connected drives, that:
   - are not (yet?) registered in `drivebadger-devices.txt` file (as Drive Badger devices)
   - are not registered in `local-drives.txt` file (as local drives)

## `mount-all-connected-devices.sh`

Mount all currently connected Drive Badger devices in `/mnt`, as subdirectories named eg. `/mnt/sandisk_sdb3`.
This includes also encrypted devices, assuming that they were encrypted using the same LUKS password, as found in `master-luks-password.txt` file.

## `mount.sh` and `umount.sh`

Respectively mount and unmount Drive Badger persistent partition. Both scripts take 2 arguments: drive `udev` alias and partition number (usually 3).


# More information

- [Drive Badger main repository](https://github.com/drivebadger/drivebadger)
- [Drive Badger wiki](https://github.com/drivebadger/drivebadger/wiki)
