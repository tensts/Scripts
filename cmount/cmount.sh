#!/bin/bash

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

CUUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

if [ ! $BLKID ]; then
	echo "nie podales BLKID"
	exit 1
fi

if [ ! $MOUNT_POINT ]; then
	echo "nie podales punktu montowania"
	exit 1
fi

if [ $EUID -ne 0 ]; then
	echo "musisz uruchomic jako root"
	exit 1
fi

if [ ! -d $MOUNT_POINT ]; then
	mkdir $MOUNT_POINT
fi

if [ "$(ls -A $MOUNT_POINT)" ] && [ $FORCE="0" ]; then
	echo "Sciezka $MOUNT_POINT nie jest pusta uzyj --force zeby nadpisac katalog"
	exit 1
fi
if [ "$(ls -A $MOUNT_POINT)" ] && [ $FORCE="1" ]; then
	rm -rfv $MOUNT_POINT
	mkdir $MOUNT_POINT
fi

cryptsetup open /dev/disk/by-uuid/$BLKID $CUUID
mount /dev/mapper/$CUUID $MOUNT_POINT
sudo chmod 700 $MOUNT_POINT
sudo chown krystian: $MOUNT_POINT
echo "DONE"
