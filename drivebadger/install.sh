#!/bin/sh

BASE=$1

if [ "$BASE" = "" ] || [ ! -d $BASE ]; then
	echo "usage: $0 <directory>"
	exit 0
fi

echo "/ union" >$BASE/persistence.conf
touch $BASE/.nobackup
mkdir -p $BASE/.files/.data $BASE/rw/opt

git clone https://github.com/pisecurity/mc-black           $BASE/rw/opt/mc-black
git clone https://github.com/drivebadger/drivebadger       $BASE/rw/opt/drivebadger
git clone https://github.com/drivebadger/hook-wcxftp       $BASE/rw/opt/drivebadger/hooks/hook-wcxftp
git clone https://github.com/drivebadger/hook-fstab        $BASE/rw/opt/drivebadger/hooks/hook-fstab
git clone https://github.com/drivebadger/exclude-windows   $BASE/rw/opt/drivebadger/config/exclude-windows
git clone https://github.com/drivebadger/exclude-macos     $BASE/rw/opt/drivebadger/config/exclude-macos
git clone https://github.com/drivebadger/exclude-linux     $BASE/rw/opt/drivebadger/config/exclude-linux
git clone https://github.com/drivebadger/exclude-antivirus $BASE/rw/opt/drivebadger/config/exclude-antivirus
git clone https://github.com/drivebadger/exclude-software  $BASE/rw/opt/drivebadger/config/exclude-software
git clone https://github.com/drivebadger/exclude-devel     $BASE/rw/opt/drivebadger/config/exclude-devel
git clone https://github.com/drivebadger/exclude-user      $BASE/rw/opt/drivebadger/config/exclude-user
git clone https://github.com/drivebadger/exclude-erp       $BASE/rw/opt/drivebadger/config/exclude-erp
git clone https://github.com/drivebadger/compat            $BASE/rw/opt/drivebadger/external/compat
git clone https://github.com/drivebadger/ext-veracrypt     $BASE/rw/opt/drivebadger/external/ext-veracrypt


# Here you should add your own repositories:
# - lists of drive encryption keys; example: https://github.com/drivebadger/keys-bitlocker-demo
# - any custom hooks, injectors and other functional extensions (if you have any)
#
# See https://drivebadger.com/installing.html for more details.


# This command should be executed after first start of Kali Linux Live:
#
# cd /opt/drivebadger/setup/2020.3 && ./install.sh
