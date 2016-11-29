#!/bin/bash
echo hi, im tmp/gsettings
echo "$USER"
gsettings set com.canonical.unity-greeter draw-grid false
gsettings set com.canonical.unity-greeter background-color “#000000”
gsettings set com.canonical.unity-greeter background-logo "/usr/share/unity-greeter/cof_tux.png"
gsettings set com.canonical.unity-greeter background ""
read -n1 -r -p "Press any key to continue..." key