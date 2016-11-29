#!/bin/bash
echo hi
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
echo "$USER"
xhost +SI:localuser:lightdm
su lightdm -s /tmp/tux-login-gsettings.sh