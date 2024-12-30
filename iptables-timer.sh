#!/bin/bash

# TODO: run in screen/check if in screen
# TODO: drop current iptables config or check in exists rules == rules in memory

if [ $UID != 0 ]; then
    echo "[-] Run program as root"
    exit 1
fi

FLAG_FILE="/tmp/iptables-restore.txt"
RESTORE_TIME=$((60 * 5)) #seconds x N

touch $FLAG_FILE
echo "[ ] After $RESTORE_TIME sec. iptables will be restored if $FLAG_FILE still exists"

sleep $RESTORE_TIME

if [ -f "$FLAG_FILE" ]; then
    printf "[ ] Times up...\n Restoring iptables"
    iptables-restore </etc/iptables/rules.v4
    echo "[+] Iptables restored"
else
    echo "[-] Restoring iptables canceled - $FLAG_FILE not exists"
fi

rm -f $FLAG_FILE

echo "[+] DONE"
