# debian-gnome
Tested on:
- razer blade stealth (2018) ( debian 9, debian 10 )
- razer blade 15 (2019) ( debian 10 )
- some old msi laptop ( debian 9, debian 10)


A guide for noobs by a noob to install debian and set it up the chiller way.

It is a mix between a script and a documentation.
So feel free to read the script and its comments and copy paste step by step.
Or execute it and decide what setup you want ( the script will ask you before it does something ).

The script is fully supporting razer blade stealth ( other hardware is probably fine aswell but untested ).
And it adds some personal customizations.
So make sure you like what i use or make changes in the debian-setup.sh before executing it.
Or simply press n on the special parts.

![Demo](img/preview.png)

# How to use?

You can either follow this readme and copy paste all the commands in your terminal.
Or you can use the ``debian-setup.sh`` script that guides you through the same process.

If you are ChillerDragon or want exactly his private setup then execute:
```
yes | ./debian-setup.sh
```
to go full chiller config (not recommended if you are not ChillerDragon).


Assuming you have a fresh installed debian with network connection.
More details on how to set it up and comments on all the following commands can be found in the comments of the debian-setup.sh script.

# GPU drivers

Sometimes it can get very tricky to even login into the graphical system because the GPU drivers are missing.
When you have like 1 fps in the login screen it is likley that you just have to install some drivers.
Press ``ctrl+alt+f2`` or ``ctrl+alt+f3`` to login into a non graphical terminal. There login as root and download the graphics script:

```
# latest version from github (long to type tho)
wget -O /tmp/gpu.sh https://github.com/ChillerDragon/debian-setup/raw/master/lib/nvidia.sh

# alternative that might be outdated or down
wget -O /tmp/gpu.sh https://paste.zillyhuhn.com/gpu

source /tmp/gpu.sh
install_cpu_drivers
```

# DEBIAN

### sudo and software

If used a CD image remove cdrom repos to connect to network.
```
sed '/^deb cdrom:.*/ s/deb cdrom:/# deb cdrom:/' /etc/apt/sources.list | sudo tee /etc/apt/sources.list
```
Check if the network connection is working. And update the system.
```
su root
apt-get update -y
apt-get upgrade -y
```
Then install sudo so you don't have to use the root user.
```
apt-get install sudo -y
```
replace chiller with your username of the account that is not root.
```
adduser chiller sudo
su chiller
sudo test
```

Then use sudo to install stuff
```
sudo apt install vim build-essential manpages-dev cmake git libcurl4-openssl-dev libfreetype6-dev libglew-dev libogg-dev libopus-dev libopusfile-dev libpnglite-dev libsdl2-dev libwavpack-dev python
```
### Installing vscode
```
wget -O /tmp/vscode.deb https://code.visualstudio.com/docs/?dv=linux64_deb
sudo dpkg -i /tmp/vscode.deb
sudo apt install -f
```

# GNOME SETTINGS

If you want to extend gnome settings execute this command and change settings in the UI
```
dconf watch /
```

### Activate Desktop

get this gnome extension https://extensions.gnome.org/extension/1465/desktop-icons/
```
gsettings set org.gnome.desktop.background show-desktop-icons true
```

### Gaming with touchpad

Don't ask

```
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
```

### dash to dock

Now fix the dash menu and add a nice bottom dock.
Install dash to dock extension either in browser at:
https://extensions.gnome.org/extension/307/dash-to-dock/
(You also want to allow the browser some stuff)
Or use gnome tweak tool and click:
extensions->Get more extensions

Then goto dash to dock settings and set the menu bar where you want
```
gnome-tweak-tool
```

### Privacy in search

By default when pressing superkey and searching things it searches in a bunch of places.

I prefer to only search software and terminal things and do not leak file information in gnome.

```
gsettings set org.gnome.desktop.search-providers disabled "['org.gnome.Contacts.desktop', 'org.gnome.Documents.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.Calendar.desktop', 'org.gnome.Characters.desktop', 'org.gnome.Boxes.desktop', 'org.gnome.clocks.desktop', 'seahorse.desktop', 'org.gnome.Photos.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Epiphany.desktop', 'firefox.desktop']"
```

### Look and feel
Flat remix icon and themes (make sure to select them in the gnome tweak tool)
```
cd /tmp && rm -rf flat-remix-gtk &&
git clone https://github.com/daniruiz/flat-remix-gtk &&
mkdir -p ~/.themes && cp -r flat-remix-gtk/Flat-Remix-GTK* ~/.themes/ &&
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Dark"

cd /tmp && rm -rf flat-remix &&
git clone https://github.com/daniruiz/flat-remix &&
mkdir -p ~/.icons && cp -r flat-remix/Flat-Remix* ~/.icons/ &&
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue"
```

# RAZER HARDWARE

Let's fix some crucial bugs related to the razer blade stealth.
They might occur on other razer laptops aswell.

Add the ``quiet button.lid_init_state=open`` kernel flag to your grub config by hand.
Or execute this command:
```
sed -i_$time_now.BACKUP -e '/^GRUB_CMDLINE_LINUX_DEFAULT=".*/ s/".*"/"quiet button.lid_init_state=open"/' /etc/default/grub
sudo update-grub
```


Installing curl and razer software
```
sudo apt-get install curl -y
curl https://download.opensuse.org/repositories/hardware:/razer/Debian_9.0/Release.key | sudo apt-key add -
echo 'deb http://download.opensuse.org/repositories/hardware:/razer/Debian_9.0/ /' | sudo tee /etc/apt/sources.list.d/hardware:razer.list
sudo apt-get update
sudo apt-get install openrazer-meta -y
```

Razer configs for X11
make sure the folder exsist
/usr/share/X11/xorg.conf.d
if not it might be the wrong place
try to execute a find command to find it
``sudo find / -name "*xorg.conf*"``
If you found the correct config folder execute this (you might want to change the path if your config folder is somewhere else):
```
echo '
Section "InputClass"

    Identifier "Disable built-in keyboard"
    MatchIsKeyboard "on" MatchProduct "AT Raw Set 2 keyboard" Option "Ignore" "true"

EndSection
' > sudo tee /usr/share/X11/xorg.conf.d/20-razer-kbd.conf
```
Another config in a different file:
```
echo '
#!/bin/sh
case $1 in
    suspend|suspend_hybrid|hibernate) # everything is fine ;;
    resume|thaw) xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
    ;;
esac
' > sudo tee /etc/pm/sleep.d/20_razer_kbd
chmod +x /etc/pm/sleep.d/20_razer_kbd
sudo apt-get install xinput -y
xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
```

