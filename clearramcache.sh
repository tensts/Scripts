#!/bin/sh
free && sync && echo 3 >/proc/sys/vm/drop_caches && swapoff -a && swapon -a && free
