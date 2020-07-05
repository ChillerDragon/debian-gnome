#!/bin/bash

function install_gpu_drivers() {
    if [ ! -f /etc/debian_version ]
    then
        echo "[!] Error: only debian systems are supported"
        return
    fi
    if [ "$UID" != "0" ]
    then
        echo "[!] Error: run as root to install GPU drivers"
        return
    fi

    cards="$(lspci -nn | grep -Ei "3d|display|vga")"
    if [ "$?" != "0" ]
    then
        echo "[!] Error: failed to detected GPU"
        return
    fi
    if echo "$cards" | grep -q NVIDIA
    then
        echo "[*] Found GPUs containing NVIDIA:"
        echo "$cards"
    else
        echo "[!] Error: no NVIDIA graphics card detected"
        return
    fi
    echo "do you want to install nvidia drivers? [y/N]"
    read -r -n 1 yn
    echo ""
    if [[ ! "$yn" =~ [yY] ]]
    then
        echo "[*] skipping nvidia drivers ..."
        return
    fi
    if ! grep -q '^deb .* non-free' /etc/apt/sources.list
    then
        echo "[!] Error: nvidia drivers are in non free repo"
        echo "           add 'non-free' to /etc/apt/sources.list"
        return
    fi
    arch="$(uname -r|sed 's/[^-]*-[^-]*-//')"
    echo "[*] installing linux kernel headers for $arch"
    apt-get update
    apt-get install linux-headers-"$arch"
    apt-get update
    apt-get install nvidia-driver 
    echo "[*] installation finished."
    echo "[*] check for errors and reboot your system"
}

