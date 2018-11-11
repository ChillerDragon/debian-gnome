#!/bin/bash

function chiller_repos() {
  echo "------[git teeworlds repos]------"
  echo "This step will clone teeworlds and other repos"
  echo "If you are no ChillerDragon this step is not recommended"
  echo "load some git repos to $HOME/Desktop/git? [y/N]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "y" ]; then
    echo "Loading some git repos from github..."
  elif [ "$inp" == "Y" ]; then
    echo "Loading some git repos from github..."
  else
    echo "Skipping git repos..."
    return
  fi
  cd ~/Desktop
  mkdir -p git
  cd git
  git clone https://github.com/ddnet/ddnet
  git clone https://github.com/ChillerDragon/DDNetPP
  git clone https://github.com/TwChilli/chilli-server
  git clone https://github.com/teeworlds/teeworlds
  git clone https://github.com/matricks/bam
  cd bam
  ./make_unix.sh

  # TODO: https://github.com/ChillerDragon/GitSettings
  # clone and set it up
  # i think the problem it that the ~/.teeworlds folder doesn't exsist yet
  # it only gets created on launching tw
  # maybe create it your self or something like that (needs good testing)
}

function extern_blender() {
  echo "------[blender]------"
  echo "-------- WARNING ------------"
  echo "you have to type 'yes' not just 'y' this time"
  echo "This prevents brain afk users"
  echo "and the yes | ./debian-setup.sh arg to accidentally build blender"
  echo "do you want to clone and build blender (takes very long)? [yes/NO]"
  read -p "" inp
  echo ""
  if [ "$inp" == "yes" ]; then
    echo "Building blender (can take much longer than 30 min)..."
  elif [ "$inp" == "Yes" ]; then
    echo "Building blender (can take much longer than 30 min)..."
  elif [ "$inp" == "YES" ]; then
    echo "Building blender (can take much longer than 30 min)..."
  elif [ "$inp" == "YEs" ]; then
    echo "Building blender (can take much longer than 30 min)..."
  elif [ "$inp" == "YeS" ]; then
    echo "Building blender (can take much longer than 30 min)..."
  else
    echo "Skipping blender..."
    return
  fi
  cd ~/Desktop
  mkdir -p git-extern
  cd git-extern
  mkdir blender-git
  cd blender-git
  git clone https://git.blender.org/blender.git
  cd blender
  git submodule update --init --recursive
  git submodule foreach git checkout master
  git submodule foreach git pull --rebase origin master
  make update
  cd ~/Desktop/git-extern/blender-git
  ./blender/build_files/build_environment/install_deps.sh
  cd ~/Desktop/git-extern/blender-git/blender
  make
  cd ~/Desktop/git-extern/blender-git/blender/build
  make
  make install
}

function extern_aircrack() {
  echo "------[aircrack]------"
  echo "Do you want to build aircrack from source? [y/N]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "y" ]; then
    echo "Building aircrack..."
  elif [ "$inp" == "Y" ]; then
    echo "Building aircrack..."
  else
    echo "Skipping aircrack..."
    return
  fi
  cd ~/Desktop
  mkdir -p git-extern
  cd git-extern
  sudo apt install dh-autoreconf autotools-dev
  git clone https://github.com/aircrack-ng/aircrack-ng
  cd aircrack-ng
  autoreconf -i
  ./configure --with-experimental
  make
  sudo make install
  sudo apt upgrade aircrack-ng
}

function extern_repos() {
  echo "------[extern git repos]------"
  echo "Do you want some extern repos like blender and aircrack"
  echo "with automatic build. This can take a while."
  echo "load some git repos to $HOME/Desktop/git-extern? [y/N]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "y" ]; then
    echo "Loading some git-extern repos from github..."
  elif [ "$inp" == "Y" ]; then
    echo "Loading some git-extern repos from github..."
  else
    echo "Skipping git-extern repos..."
    return
  fi
  extern_blender
  extern_aircrack
}

function git_repos() {
  echo "------[git repos]------"
  echo "Do you want some git repos at your desktop? [y/N]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "y" ]; then
    echo "Loading some git repos from github..."
  elif [ "$inp" == "Y" ]; then
    echo "Loading some git repos from github..."
  else
    echo "Skipping git repos..."
    return
  fi
  chiller_repos
  extern_repos
}

