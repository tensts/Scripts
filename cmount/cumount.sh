#!/bin/bash

MOUNT_POINT=$1

if [ ! $MOUNT_POINT ]; then
echo "nie podales punktu montowania"
exit 1
fi

if [ $EUID -ne 0 ]; then
echo "musisz uruchomic jako root"
exit 1
fi

echo "syncing..."
sync
echo "done"
umount $MOUNT_POINT
if [ ! $? -eq 0 ]; then
echo "nie udalo sie odmontowac"
#exit 1
fi


CUUID=$(mount | grep $MOUNT_POINT | cut -d " " -f1 | cut -d "/" -f4)
echo $CUUID
echo "close luks"
cryptsetup close $CUUID
echo "done"
