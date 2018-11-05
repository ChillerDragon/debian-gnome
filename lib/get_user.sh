#!/bin/bash
user_name=$USER

# i am a dependency function don't call me
function ask_for_custom_user() {
  echo "Enter exsisting username"
  printf "> "
  read -p "" name
  echo "Do you want to use '$name' for setup? [Y/n]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "n" ]; then
    ask_for_custom_user
  elif [ "$inp" == "N" ]; then
    ask_for_custom_user
  else
    user_name=$name
    echo "Using '$user_name' for setup..."
  fi
}

# i am a main (entry point) function call me
function ask_for_username() {
  echo "For the setup a specific user is used."
  echo "It should exsist and it gets sudo access."
  echo "We found the user '$user_name' do you want to use it? [Y/n]"
  read -n 1 -p "" inp
  echo ""
  if [ "$inp" == "n" ]; then
    ask_for_custom_user
  elif [ "$inp" == "N" ]; then
    ask_for_custom_user
  else
    echo "Using '$user_name' for setup..."
  fi
}

