#!/bin/bash
cd "$(dirname "$0")"
set -e
printf "\033c"
echo "################################################################################"
echo "# TUX PLYMOUTH THEME                                                           #" 
echo "################################################################################"
echo "Hi and thanks for bringing Tux to Ubuntu!"
echo ""
echo "Are you running Ubuntu 16.04 LTS?"

# TODO: Add to search on /lib/plymouth/themes. On other systems it is /usr/share/plymouth
#       More info on other OSes: http://brej.org/blog/?p=158

select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "Do you understand that changing bootlogo is not without risk? Internet can help, but nothing is 100% safe.";
              select yn in "Yes" "No"; do
                  case $yn in
                    Yes ) echo "Ok, here we go! Remember to choose tux in the Plymouth menu next (if you want Tux that is ;)";
                          read -n1 -r -p "Press any key to continue..." key
                          echo ""
                          echo "But first, Tux need your sudo allowance to add your theme to system folders:"
                          
                          PKG_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' plymouth-themes|grep "install ok installed")
                          echo Checking if plymouth-themes is installed: $PKG_INSTALLED
                          if [ "" == "$PKG_INSTALLED" ]; then
                            echo "plymouth-themes is not installed. Installing now."
                            sudo apt-get --force-yes --yes install plymouth-themes
                          fi
                          
                          # Workaround Ubuntu Plymouth bug that doesn't allow copied plymouth themes
                          sudo cp -r /usr/share/plymouth/themes/script /usr/share/plymouth/themes/tux-plymouth-theme;  
                          sudo cp -r tux-plymouth-theme/* /usr/share/plymouth/themes/tux-plymouth-theme;
                          sudo cat /usr/share/plymouth/themes/tux-plymouth-theme/tux.script >> /usr/share/plymouth/themes/tux-plymouth-theme/script.script
                          sudo cat /usr/share/plymouth/themes/tux-plymouth-theme/tux.plymouth >> /usr/share/plymouth/themes/tux-plymouth-theme/script.plymouth
                          sudo rm /usr/share/plymouth/themes/tux-plymouth-theme/tux.plymouth;
                          sudo rm /usr/share/plymouth/themes/tux-plymouth-theme/tux.script;
                          sudo mv /usr/share/plymouth/themes/tux-plymouth-theme/script.script /usr/share/plymouth/themes/tux-plymouth-theme/tux.script
                          sudo mv /usr/share/plymouth/themes/tux-plymouth-theme/script.plymouth /usr/share/plymouth/themes/tux-plymouth-theme/tux.plymouth


                          sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/tux-plymouth-theme/tux.plymouth 100;
                          sudo update-alternatives --config default.plymouth;
                          sudo update-initramfs -u;
                          x-www-browser http://tux4ubuntu.blogspot.se/2016/11/done.html;
                          break;;
                    No ) exit;;
                    esac
                done
              break;;
        No )  echo "Can't guarantee anything but just typing these commands and following instructions should do it:"
              echo ""
              echo "      Copy the theme (earlier Ubuntu versions had the themes in /lib/plymouth/themes/)"
              echo "          1) sudo cp -r tux/ /usr/share/plymouth/themes/"
              echo "      Add the theme to Plymouth (remember to change the folder adresses if needed)"
              echo "          2) sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/tux/tux.plymouth 100"
              echo "      Change the default theme, follow the instructions"
              echo "          3) sudo update-alternatives --config default.plymouth"
              echo "      Update initramfs"
              echo "          4) sudo update-initramfs -u"
              echo ""
              echo "Good luck!"
              exit;;
    esac
done