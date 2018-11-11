#!/bin/bash

function ask_for_razer() {
  echo "Is this a razer laptop? [y/N]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "y" ]; then
    is_razer=true
  elif [ "$inp" == "Y" ]; then
    is_razer=true
  else
    echo "Skipping razer optimization..."
  fi
}
