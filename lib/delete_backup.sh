#!/bin/bash
function delete_backup() {
  if [ $is_edit_grub != true ]; then
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
  mv $grub_backup /tmp
}

