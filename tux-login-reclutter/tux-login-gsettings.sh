#!/bin/bash
# Can uncomment below to make sure we are running as lightdm
# echo "$USER"
gsettings set com.canonical.unity-greeter draw-grid true
gsettings set com.canonical.unity-greeter background-color “#2C001E”
gsettings set com.canonical.unity-greeter background "/usr/share/backgrounds/warty-final-ubuntu.png"