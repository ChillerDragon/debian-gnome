#!/bin/bash

function chiller_config() {
  echo "load chiller configs from github (vim etc)? [y/N]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "y" ]; then
    echo "Loading chiller configs from github..."
  elif [ "$inp" == "Y" ]; then
    echo "Loading chiller configs from github..."
  else
    echo "Skipping chiller configs..."
    return
  fi
  sudo apt install git
  cd /tmp
  rm -rf chiller-configs
  git clone https://github.com/ChillerDragon/chiller-configs
  cd chiller-configs
  chmod +x setup.sh
  ./setup.sh
}
