#!/bin/bash

function install_gpu_drivers() {
    if [ "$UID" != "0" ]
    then
        echo "[!] run as root to install GPU drivers"
        return
    fi

    cards="$(lspci -nn | grep -Ei "3d|display|vga")"
    if [ "$?" != "0" ]
    then
        echo "[!] failed to detected GPU"
        return
    fi
    if echo "$cards" | grep -q NVIDIA
    then
        echo "[*] Found GPUs containing NVIDIA:"
        echo "$cards"
    else
        echo "[!] no NVIDIA graphics card detected"
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
    if grep -q '^deb http://deb.debian.org/debian buster main contrib non-free' /etc/apt/sources.list
    then
        echo "[*] found non-free in apt sources already"
    else
        if grep -q '^deb http://deb.debian.org/debian buster main$' /etc/apt/sources.list
        then
            echo "[*] found buster main in apt sources already"
            nonfree="deb http://deb.debian.org/debian buster contrib non-free"
            echo "$nonfree" >> /etc/apt/sources.list
        else
            echo "[*] adding non-free apt sources"
            nonfree="deb http://deb.debian.org/debian buster main contrib non-free"
            echo "$nonfree" >> /etc/apt/sources.list
        fi
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

