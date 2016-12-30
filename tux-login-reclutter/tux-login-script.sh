#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi
# Can uncomment below to make sure we are running as lightdm
# echo "$USER"
xhost +SI:localuser:lightdm
su lightdm -s /tmp/reclutter/tux-login-gsettings.sh