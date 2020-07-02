#!/bin/bash

function chiller_dotfiles() {
    echo "load chiller configs from github (vim etc)? [y/N]"
    read -rn 1 -p "" inp
    echo ""
    if [ "$inp" == "y" ]; then
        echo "Loading chiller configs from github..."
    elif [ "$inp" == "Y" ]; then
        echo "Loading chiller configs from github..."
    else
        echo "Skipping chiller configs..."
        return
    fi
    mkdir -p "$HOME/Desktop/git"
    save_cd "$HOME/Desktop/git"
    if [ ! -d dotfiles ]
    then
        git clone git@github.com:ChillerDragon/dotfiles
    fi
    save_cd dotfiles
    git pull
    chmod +x setup.sh
    ./setup.sh
}

