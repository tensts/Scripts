#!/bin/bash

if [ $EUID -ne 0 ]; then
	echo "You have to be root to execute"
	exit 1
fi

BLKID=$1
MOUNT_POINT=$2

FORCE=0
for i in "$@"; do
	case $i in
	--force)
		FORCE=1
		shift
		;;
	esac
done

CUUID=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 32 | head -n 1)

if [ ! "$BLKID" ]; then
	echo "BLKID not provided"
	exit 1
fi

if [ ! "$MOUNT_POINT" ]; then
	echo "mount point not provided"
	exit 1
fi

if [ ! -d "$MOUNT_POINT" ]; then
	mkdir "$MOUNT_POINT"
fi

if [ "$(ls -A "$MOUNT_POINT")" ] && [ $FORCE = "0" ]; then
	echo "$MOUNT_POINT path is not empty, use --force to mount"
	exit 1
fi
if [ "$(ls -A "$MOUNT_POINT")" ] && [ $FORCE = "1" ]; then
	rm -rfv "$MOUNT_POINT"
	mkdir "$MOUNT_POINT"
fi

cryptsetup open /dev/disk/by-uuid/"$BLKID" "$CUUID"
mount /dev/mapper/"$CUUID" "$MOUNT_POINT"
sudo chmod 700 "$MOUNT_POINT"
sudo chown "$USER": "$MOUNT_POINT"
echo "DONE"
