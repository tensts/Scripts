#!/bin/bash

BLKID=""
MOUNT_POINT=""

CUUID=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 32 | head -n 1)

cryptsetup open /dev/disk/by-uuid/"$BLKID" "$CUUID"
mount /dev/mapper/"$CUUID" "$MOUNT_POINT"
echo "DONE"
