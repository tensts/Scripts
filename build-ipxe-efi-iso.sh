#!/bin/bash

needed_soft=("genisoimage" "mtools" "syslinux")
check_if_exists() {
    exists="$(dpkg -l | grep ii | grep $1)"
    if [[ -z $exists ]]; then
        echo 0
    else
        echo 1
    fi
}

for item in "${needed_soft[@]}"; do
    if [[ $(check_if_exists "$item") -eq 0 ]]; then
        echo "[-] $item not found, installing"
        read -p "Press Enter to continue..."
        sudo apt -y install "$item"
    fi
done

cd /tmp
if [[ -d "ipxe" ]]; then
    rm -rf "ipxe"
fi

mkdir ipxe
git clone git://git.ipxe.org/ipxe.git
cd ipxe/src/
make -j4 bin-x86_64-efi/ipxe.efi
make -j4 bin-x86_64-efi/ipxe.usb
mkdir iso
cp -avf bin-x86_64-efi/ipxe.usb iso
mkisofs -e ipxe.usb -o /tmp/ipxe/ipxe.efi.iso iso/
echo "[+] ISO created at /tmp/ipxe/ipxe.efi.iso"
