#!/bin/bash
# dependencys if run as script
# skip to 'START READING HERE' section if you copy paste manually
source lib/save_cd.sh
source lib/get_user.sh
source lib/edit_grub.sh
source lib/check_razer.sh
source lib/chiller_cfg.sh
source lib/git_repos.sh
source lib/chiller_tools.sh
source lib/nvidia.sh

user_name=$USER # overwritten by get_user.sh
is_razer=false  # overwritten by check_razer.sh
ask_for_username
ask_for_razer
setup_git # add ssh key to github

##############################################
#                                            #
#  START READING HERE IF YOU DO IT MANUALLY  #
#                                            #
##############################################
# Doing it manually disclaimer:
# This can also run as script so don't get confused by function calls
# Or by if branches. Make sure to read and understand what is going on and don't copy paste blind
# If you want to lay back and be lazy just execute the script.
# -- manually disclaimer end --

# A guide on how to install a customized debian on Razer Blade Stealth
# It is designed for this model and windows 10
# But i am sure it can also be helpful on other operating systems or hardware.
# useful video ressource https://www.youtube.com/watch?v=VP9yLn1dnQE
#
# This guide is made by an complete noob who has no idea what he is doing.
# And it is designed for people who have no idea how to use an computer.
#
# I used the ~4GB DVD image iso so it makes less trouble on not detecting the wifi card.
# I realized some non-free firmware fixed the wifi card and therefore should allow an netinstall aswell.
# Anyways i choose this exact ISO:
# https://cdimage.debian.org/debian-cd/current/amd64/iso-dvd/debian-9.5.0-amd64-DVD-1.iso
# Feel free to pick a different image from:
# https://www.debian.org/distrib/
#
# Prepare an usb stick with the ISO. I used the open source rufus tool for that.
# Feel free to follow the annoyingly long video for a step by step instruction (suggested to start at 171sec):
# https://youtu.be/T_KZ_b18hKU?t=171
#
# Then follow the youtube video (mentioned in the beginning).
# In case everything breaks and it lacks some firmware.
# Or the installer is not able to establish a network connection.
# This can probably fixed by adding some non-free firmware inside the installer iso.
# I downloaded this firmware:
# http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/stretch/20180714/
# and put the extracted content firmware.zip folder inside the /firmware folder of the boot usb iso
# If you are not using debian 9 (stretch) you should probably choose a better fitting firmware here:
# http://cdimage.debian.org/cdimage/unofficial/non-free/firmware/
#
#
#
# You should now have an debian system running. It should work somehow already.
# feel free to check if the network connection is working and upgrade the system:
# The following steps are completly optional but recommended.

# Add sbin to path
if ! echo $PATH | grep -q sbin
then
	if grep -q "ChillerDragon (debian-setup.sh)" ~/.bashrc
	then
		echo "warning sbin not in path found..."
	else
		echo "adding sbin to path..."
		echo "" >> ~/.bashrc
		echo "PATH=\$PATH:/usr/sbin # ChillerDragon (debian-setup.sh)" >> ~/.bashrc
		source ~/.bashrc
	fi
fi

if [ "$EDITOR" != "vim" ]
then
    echo "setting EDITOR to vim ..."
    echo "" >> ~/.bashrc
    echo "EDITOR=vim # ChillerDragon (debian-setup.sh)" >> ~/.bashrc
fi

# Check if the network connection is working. And update the system.
read -r -d '' cmd << EOM
    apt-get update -y
    apt-get upgrade -y
    # Then install sudo so you don't have to use the root user
    apt-get install sudo -y
    # replace $user_name with your username of the account that is not root
    /usr/sbin/adduser $user_name sudo
    if grep -q "$user_name" /etc/sudoers
    then
        echo "[*] user '$user_name' in sudoers already"
    else
        echo "[*] adding '$user_name' to /etc/sudoers"
        echo "$user_name ALL=(ALL)   ALL" >> /etc/sudoers
    fi
    exit;
EOM

res=1
while [ "$res" == "1" ]
do
    echo "please enter admin password to install sudo :)"
    su -c "$cmd";
    res=$?
done
# test if sudo is working
sudo touch /tmp/sudo-test
if [ ! -f /tmp/sudo-test ]
then
    echo "failed to use sudo"
    exit 1
fi

# If you used the CD rom image the sources.list has to be updated
# comment out the cdrom repos by hand or execute following command:
sed '/^deb cdrom:.*/ s/deb cdrom:/# deb cdrom:/' /etc/apt/sources.list | sudo tee /etc/apt/sources.list

echo "Installing compiler and dev libs..."
sudo apt install \
    vim build-essential manpages-dev cmake git \
    libcurl4-openssl-dev libfreetype6-dev libglew-dev \
    libogg-dev libopus-dev libopusfile-dev libpnglite-dev \
    libsdl2-dev libwavpack-dev python gdb libreadline-dev
chiller_dotfiles

# Okay now first of all fix the ugly default look before we keep fixing actual bugs.
# Skip this step if you like the default look or dislike this design https://github.com/daniruiz/Flat-Remix-GTK
if [ ! -d ~/.themes/Flat-Remix-GTK-Blue ] # if guard for script not installing it twice
then
  echo "installing flat-remix-gtk theme by daniruiz..."
  cd /tmp && rm -rf flat-remix-gtk &&
  git clone https://github.com/daniruiz/flat-remix-gtk &&
  mkdir -p ~/.themes && cp -r flat-remix-gtk/Flat-Remix-GTK* ~/.themes/ &&
  gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark"
fi
if [ ! -d ~/.icons/Flat-Remix-Blue ]
then
  echo "installing flat-remix icon theme by daniruiz..."
  cd /tmp && rm -rf flat-remix &&
  git clone https://github.com/daniruiz/flat-remix &&
  mkdir -p ~/.icons && cp -r flat-remix/Flat-Remix* ~/.icons/ &&
  gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue"
fi

# Most important for the look! The background and login screen:
gsettings set org.gnome.desktop.background picture-uri 'file:////usr/share/desktop-base/joy-inksplat-theme/wallpaper/gnome-background.xml'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/desktop-base/joy-theme/wallpaper/gnome-background.xml'

# Invert touchpad scroll direction
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Now fix the dash menu and add a nice bottom dock.
# Install dash to dock extension either in browser at:
# https://extensions.gnome.org/
# You also want to allow the browser some stuff
# and then search for dash to dock.
# or execute:
echo "Install dash to dock extension at extensions->Get more extensions"
echo "Then goto dash to dock settings and set the menu bar where you want"

# commands to start gnome tweak tool
# commented out in script becuase it is annoying
# gnome-tweak-tool # debian 9
# gnome-tweaks     # debian 10

# activate desktop icons
# on debian 10 you need a gnome extension called "Desktop Icons"
gsettings set org.gnome.desktop.background show-desktop-icons true

# I (ChillerDragon) personally used gnome for some time now and never used all these search results
# when pressing the super key and entering a search term
# gnome by default searches in all kind of places
# this can lead to information leak about files you have on your system when searching a application
# so i PERSONALLY like to keep that off
gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Contacts.desktop', 'org.gnome.Documents.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Characters.desktop', 'org.gnome.Boxes.desktop', 'org.gnome.clocks.desktop', 'seahorse.desktop']"

# some GNOME version introduced a emoji shortcut like wtf?
# it trapped ctrl+shift+e
# so your fav export hotkey or opening teeworlds editor does not work anymore
# thats why turning this weird feature off is a big win
gsettings set org.freedesktop.ibus.panel.emoji hotkey []

if [ $is_razer == true ]
then
  # Let's fix some crucial bugs related to the razer blade stealth
  # They might occur on other razer laptops aswell.
  # They might not occur on your hardware.
  # Bugs i encountered and fixed:
  # - When closing the laptop lit it went randomly to inactive after opening it agian
  # - When releasing CAPSLOCK key everything crashed and i had to hardreset my laptop

  # Super usefull ressources can be found at:
  # https://wiki.archlinux.org/index.php/Razer_Blade
  # https://www.reddit.com/r/razer/comments/447vrn/razer_blade_stealth_linux/
  #
  update_grub # fixes the close laptop lit bug

  # Installing curl and razer software
  sudo apt-get install curl -y
  curl https://download.opensuse.org/repositories/hardware:/razer/Debian_9.0/Release.key | sudo apt-key add -
  echo 'deb http://download.opensuse.org/repositories/hardware:/razer/Debian_9.0/ /' | sudo tee /etc/apt/sources.list.d/hardware:razer.list
  sudo apt-get update
  sudo apt-get install openrazer-meta -y

  # Razer configs for X11
  # make sure the folder exsist
  # /usr/share/X11/xorg.conf.d
  # if not it might be the wrong place
  # try to execute a find command to find it
  # sudo find / -name "*xorg.conf*"
  echo "Add some razer specific config..."
  echo '
  Section "InputClass"

      Identifier "Disable built-in keyboard"
      MatchIsKeyboard "on" MatchProduct "AT Raw Set 2 keyboard" Option "Ignore" "true"

  EndSection
  ' | sudo tee /usr/share/X11/xorg.conf.d/20-razer-kbd.conf
  echo '
  #!/bin/sh
  case $1 in
      suspend|suspend_hybrid|hibernate) # everything is fine ;;
      resume|thaw) xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
      ;;
  esac
  ' | sudo tee /etc/pm/sleep.d/20_razer_kbd
  # I am not sure if this chmod is really required but i guess it doesn't harm
  sudo chmod +x /etc/pm/sleep.d/20_razer_kbd
  sudo apt-get install xinput -y
  #TODO: rework the following echo because currently i am not sure how to describe whats going on here.
  echo "Enable xinput keyboard device"
  xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
fi # end is_razer true branch

git_repos
install_chillertools

# installing usefull tools
sudo apt install htop nload

install_gpu_drivers

echo ""
echo "Done."
echo ""
echo ""
echo "PLEASE READ THE FOLLOWING TEXT!"
echo ""
echo "ChillerDragon's debian setup script is done."
echo "Have a look at the output and check for errors."
echo "The comments in the script might help troubleshooting."
echo "If everything worked fine reboot your device."
if [ $is_razer == true ]
then
    echo "After reboot pressing CAPSLOCK and closing the laptop lit should work (on razer)."
fi
delete_backup
