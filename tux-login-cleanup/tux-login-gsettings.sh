#!/bin/bash
# Can uncomment below to make sure we are running as lightdm
# echo "$USER"
gsettings set com.canonical.unity-greeter draw-grid false
gsettings set com.canonical.unity-greeter background-color “#000000”
gsettings set com.canonical.unity-greeter background ""