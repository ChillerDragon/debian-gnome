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
  save_cd /tmp
  rm -rf dotfiles
  git clone https://github.com/ChillerDragon/dotfiles
  save_cd dotfiles
  chmod +x setup.sh
  ./setup.sh
}
