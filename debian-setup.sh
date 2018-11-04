# A guide on how to install a customized debian on Razer Blade Stealth
# It is designed for this model and windows 10
# But i am sure it can also be helpfull on other operating systems or hardware.
# usefull video ressource https://www.youtube.com/watch?v=VP9yLn1dnQE
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
# The following steps are completly optional but strongly recommended.
#
# Check if the network connection is working. And update the system.
su root
apt-get update
apt-get upgrade
# Then install sudo so you don't have to use the root user
apt-get install sudo
# replace chiller with your username of the account that is not root
adduser chiller sudo
# switch to that account
su chiller
# test if sudo is working
sudo test
#
#
# Okay now first of all fix the ugly default look before we keep fixing actual bugs.
# Skip this step if you like the default look or dislike this design https://github.com/daniruiz/Flat-Remix-GTK
echo "installing flat-remix-gtk theme by daniruiz..."
cd /tmp && rm -rf flat-remix-gtk &&
git clone https://github.com/daniruiz/flat-remix-gtk &&
mkdir -p ~/.themes && cp -r flat-remix-gtk/Flat-Remix-GTK* ~/.themes/ &&
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK"
echo "installing flat-remix icon theme by daniruiz..."
cd /tmp && rm -rf flat-remix &&
git clone https://github.com/daniruiz/flat-remix &&
mkdir -p ~/.icons && cp -r flat-remix/Flat-Remix* ~/.icons/ &&
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix"

# I didn't find a command yet to change the terminal theme so it has to be done manually now.
# Open a terminal ( windowskey and then type terminal ):
# In the top menu bar click on Edit->Preferences->General->Theme variant: Dark
#
# Now fix the dash menu and add a nice bottom dock.
# Install dash to dock extension either in browser at:
# https://extensions.gnome.org/
# You also want to allow the browser some stuff
# and then search for dash to dock.
# or execute:
echo "Install dash to dock extension at extensions->Get more extensions"
echo "Then goto dash to dock settings and set the menu bar where you want"
gnome-tweak-tool

# This alias allows to launch the files browser from commandline
# in the windows style by typing 'start <path>'
# sadly the mac style 'open <path>' is not possible
# because open is a linux command already ._.
echo "create start alias for file system..."
echo "alias start='xdg-open'" >> ~/.bash_aliases

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
echo "Fixing the close laptop lit bug..."
echo "WARNING THIS IS EDITING YOUR GRUB CONFIG"
echo "IT IGHT OVERRIDE SOME NICE DEFAULTS OR EVEN YOUR CUSTOMIZATIONS"
echo "TODO: ask for user input y/N on this step"
time_now=`date +%Y-%m-%d_%H-%M-%S`
sed -i_$time_now.BACKUP -e '/^GRUB_CMDLINE_LINUX_DEFAULT=".*/ s/".*"/"quiet button.lid_init_state=open"/' /etc/default/grub
echo "an backup of your old grub config was saved to /etc/default/grub_$time_now.BACKUP"


# Installing curl and razer software
sudo apt-get install curl
curl https://download.opensuse.org/repositories/hardware:/razer/Debian_9.0/Release.key | sudo apt-key add -
echo 'deb http://download.opensuse.org/repositories/hardware:/razer/Debian_9.0/ /' | sudo tee /etc/apt/sources.list.d/hardware:razer.list
sudo apt-get update
sudo apt-get install openrazer-meta

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
' > sudo tee /usr/share/X11/xorg.conf.d/20-razer-kbd.conf



