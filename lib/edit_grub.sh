#!/bin/bash

function update_grub() {
  echo "----------------------------------"
  echo "Fixing the close laptop lit bug..."
  echo "WARNING THIS IS EDITING YOUR GRUB CONFIG"
  echo "IT MIGHT OVERRIDE SOME NICE DEFAULTS OR EVEN YOUR CUSTOMIZATIONS"
  echo "Do you want to edit the grub config? [y/N]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "y" ]; then
    test
  elif [ "$inp" == "Y" ]; then
    test
  else
    echo "Skipping grub edit..."
    echo "I highly recommend to edit the grub config manually then:"
    echo "add the 'button.lid_init_state=open' kernel flag to your grub cfg"
    is_edit_grub=0
    return
  fi
  is_edit_grub=1

  time_now=`date +%Y-%m-%d_%H-%M-%S`
  sed -i_$time_now.BACKUP -e '/^GRUB_CMDLINE_LINUX_DEFAULT=".*/ s/".*"/"quiet button.lid_init_state=open"/' /etc/default/grub
  echo "an backup of your old grub config was saved to /etc/default/grub_$time_now.BACKUP"
}
