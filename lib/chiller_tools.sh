#!/bin/bash

function setup_git() {
    git config --global user.email "ChillerDragon@gmail.com"
    git config --global user.name "ChillerDrgon"
    # TODO: check if ssh and firefox are installed
    if [ -d ~/.ssh/ ]
    then
        return
    fi
    ssh-keygen
    cat ~/.ssh/id_rsa.pub
    firefox https://github.com/settings/keys
}

function install_crools() {
    mkdir -p ~/Desktop/git
    cd ~/Desktop/git || exit 1
    if [ ! -d ~/Desktop/git/crools ]
    then
        git clone git@github.com:ChillerDragon/crools
    fi
    cd crools || exit 1
    crools
    if ! grep -q 'ChillerDragon/debian-setup crools' ~/.bashrc
    then
        echo "# ChillerDragon/debian-setup crools" >> ~/.bashrc
        echo "export PATH=\"\$HOME/Desktop/git/crools:\$PATH\"" >> ~/.bashrc
    fi
    cd "$SETUP_PATH" || exit 1
    shortcut_bin=./bin/set_customshortcut.py
    if [ ! -f "$shortcut_bin" ]
    then
        return
    fi
    if [ ! -x "$(command -v python3)" ]
    then
        return
    fi
    gnome_keybindings="$(gsettings get \
        org.gnome.settings-daemon.plugins.media-keys \
        custom-keybindings)"
    if [ "$gnome_keybindings" == "@as []" ]
    then
        eval "python3 $shortcut_bin 'crapshot screen' '/home/chiller/Desktop/git/crools/crapshot' '<Primary><Alt>3'"
        eval "python3 $shortcut_bin 'crapshot selection' '/home/chiller/Desktop/git/crools/crapshot --select' '<Primary><Alt>4'"
    fi
}

function install_ruby() {
    if [ -d ~/.rbenv ]
    then
        echo "[*] rbenv already installed."
        return
    fi
    echo "To install ruby copy that into another terminal:"
    echo ""
cat << EOF
sudo apt-get update
sudo apt-get install git-core \
    curl zlib1g-dev build-essential \
    libssl-dev libreadline-dev libyaml-dev \
    libsqlite3-dev sqlite3 libxml2-dev \
    libxslt1-dev libcurl4-openssl-dev \
    python-software-properties libffi-dev
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="\$HOME/.rbenv/bin:\$PATH"' >> ~/.bashrc
echo 'eval "\$(rbenv init -)"' >> ~/.bashrc
exec \$SHELL

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
echo 'export PATH="\$HOME/.rbenv/plugins/ruby-build/bin:\$PATH"' >> ~/.bashrc
exec \$SHELL

rbenv install 2.7.0
rbenv global 2.7.0
ruby -v
gem install bundler
rbenv rehash
EOF
    echo ""
    echo "PRESS ENTER TO CONTINUE"
    echo "it is recommended tho to kill the script and start again"
    read -r
}

function install_um() {
    if grep -q 'ChillerDragon/debian-setup um' ~/.bashrc
    then
        echo "[*] um is already installed."
        return
    fi
    mkdir -p ~/Desktop/git-extern
    cd ~/Desktop/git-extern || exit 1

    # build um
    # https://github.com/sinclairtarget/um/issues/26#issuecomment-554677155
    if [ ! -d um ]
    then
        git clone https://github.com/sinclairtarget/um
    fi
    cd um || exit 1
    gem build um.gemspec && gem install um*.gem

    # clone personal um pages
    mkdir -p ~/.um/
    if [ -d ~/.um/pages ]
    then
        rm -rf ~/.um/pages
    fi
    git clone git@github.com:ChillerData/um-pages.git ~/.um/pages

    echo "# ChillerDragon/debian-setup um" >> ~/.bashrc
    echo "export PATH=\"\$PATH:\$HOME/Desktop/git-extern/um/bin\"" >> ~/.bashrc
}

function ff_set() {
    # https://askubuntu.com/a/715465
    sed -i 's/user_pref("'$1'",.*);/user_pref("'$1'",'$2');/' user.js
    grep -q $1 user.js || echo "user_pref(\"$1\",$2);" >> user.js
}

function setup_firefox() {
    if [ ! -d ~/.mozilla/firefox ]
    then
        return
    fi
    cd ~/.mozilla/firefox || exit 1
    ffuser="$(ls -D | grep '.*\.default$' | head -n1)"
    if [ "$ffuser" == "" ]
    then
        return
    fi
    cd "$ffuser" || exit 1
    # ff_set browser.search.defaulturl '"https://duckduckgo.com/"'
    if [ ! -f user.js ]
    then
        echo "user_pref(\"browser.search.defaulturl\",\"https://duckduckgo.com/\");" > user.js
    fi
}

function install_honeylocker() {
    if [ -f /usr/local/bin/honeylocker.py ]
    then
        return
    fi
    sudo apt install python3 python3-pip ffmpeg
    python3 -m pip install pyxhook
    cd /usr/local/bin
    sudo wget https://raw.githubusercontent.com/ChillerDragon/HoneyLocker/master/honeylocker.py
    sudo chmod +x honeylocker.py
}

function install_keylogger() {
    mkdir -p "$HOME/Desktop/git"
    cd "$HOME/Desktop/git" || exit 1
    git clone git@github.com:ChillerDragon/keylogger
    cd keylogger
    git remote add upstream https://github.com/GiacomoLaw/Keylogger
}

function install_chillertools() {
    echo ""
    echo "If you are ChillerDragon press y"
    echo "otherwise press n"
    echo ""
    echo "This will configure your git and very personal tools"
    echo "to be very ChillerDragon"
    echo ""
    echo "do you want to install chillertools? [y/N]"
    read -r -n 1 yn
    echo ""
    if [[ ! "$yn" =~ [yY] ]]
    then
        echo "[*] skipping chillertools ..."
        return
    fi
    sudo apt install screen maim gnustep-gui-runtime pass python3
    # the firefox thingy is broken
    # setup_firefox
    install_crools
    install_ruby
    install_um
    install_honeylocker
    install_keylogger
}

