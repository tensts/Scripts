#!/bin/bash

style=("1"  "4")
color=("30" "32" "34" "35" "36" "91" "92" "93" "94" "95" "96" "97")
background=("49" "41" "42" "43" "44" "45" "46" "100" "101" "102" "104" "105")

rand_style=${style[$RANDOM % ${#style[@]}]}
rand_color=${color[$RANDOM % ${#color[@]}]}
rand_background=${background[$RANDOM % ${#background[@]}]}


PS="\${debian_chroot:+(\$debian_chroot)}\[\033[$rand_style;$rand_color;${rand_background}m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ "
PS_vis="\\e[$rand_style;$rand_color;${rand_background}mroot@localhost\\e[00m:\\e[01;34m/tmp\\e[00m$"

echo $PS
echo ""
echo -e $PS_vis


