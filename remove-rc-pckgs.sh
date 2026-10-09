#!/bin/bash

#rc_packages

x="$(dpkg -l |grep ^rc|cut -d' ' -f3)"
apt autopurge "$x"
