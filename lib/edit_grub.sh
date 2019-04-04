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
  sudo sed -i_$time_now.BACKUP -e '/^GRUB_CMDLINE_LINUX_DEFAULT=".*/ s/".*"/"quiet button.lid_init_state=open"/' /etc/default/grub
  sudo update-grub
  echo "an backup of your old grub config was saved to /etc/default/grub_$time_now.BACKUP"
}

function delete_backup() {
  if [ "$is_edit_grub" != "1" ]; then
    # skip backup deletion if no backup was made
    return
  fi

  echo ""
  echo "The script created a backup of your grub config"
  echo "You might want to delete that file"
  echo "The created backup file is:"
  echo "/etc/default/grub_$time_now.BACKUP"
  echo ""
  echo "Do you want to delete the grub backup? [y/N]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "y" ]; then
    test
  elif [ "$inp" == "Y" ]; then
    test
  else
    echo "Skipping grub backup deletion..."
    echo "Make sure you delete it after you are done."
    return
  fi

  grub_backup="/etc/default/grub_$time_now.BACKUP"
  echo "deleting grub cfg backup ($grub_backup)..."
  echo "can be restored from /tmp until system reboot."
  # soft delete c:
  sudo mv $grub_backup /tmp
}
