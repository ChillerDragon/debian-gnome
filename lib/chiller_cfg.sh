#!/bin/bash

function chiller_config() {
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
  rm -rf chiller-configs
  git clone https://github.com/ChillerDragon/chiller-configs
  save_cd chiller-configs
  chmod +x setup.sh
  ./setup.sh
}
