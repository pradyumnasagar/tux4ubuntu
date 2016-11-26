#!/bin/bash
cd "$(dirname "$0")"
set -e
printf "\033c"
echo "################################################################################"
echo "# TUX                                                           #" 
echo "################################################################################"
echo "Hi and thanks for bringing Tux to Ubuntu!"

# TODO: Add to search on /lib/plymouth/themes. On other systems it is /usr/share/plymouth
#       More info on other OSes: http://brej.org/blog/?p=158

# Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
while :
do
    clear
    cat<<EOF
    ==============================
    Menusystem experiment
    ------------------------------
    Please enter your choice:

    Option (1)
    Option (2)
    Option (3)
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "1")  echo "you chose choice 1" ;;
    "2")  echo "you chose choice 2" ;;



    "3")  echo "you chose choice 3" ;
            printf "\033c"
            echo "Are you running Ubuntu 16.04?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) printf "\033c"
                        echo "Do you understand that changing bootlogo is not without risk? And we can't be ";
                        echo "hold responsible if you proceed. Internet can help, but nothing is 100% safe.";
                        select yn in "Yes" "No"; do
                            case $yn in
                                Yes ) echo "Ok, here we go!"
                                    echo "PS. Tux needs to use apt-get packages 'plymouth-theme' and 'xclip', if not installed you will be asked to install them. And sudo rights will also be asked for so Tux can copy the theme to your plymouth folder."
                                    read -n1 -r -p "Press any key to continue..." key

                                    # Workaround what we think is an Ubuntu Plymouth bug that doesn't seem to allow foreign plymouth themes
                                    # so instead of simply sudo cp -r tux-plymouth-theme/ /usr/share/plymouth/themes/tux-plymouth-theme we 
                                    # have to (6 steps):
                                     
                                    # 1) Add other themes through the apt-get package 'plymouth-themes' that seem to work as well as 'xclip'
                                    # -package to successfully copy the internals of tux.script, tux.plymouth to a copy of the plymouth-themes's
                                    # 'script'-theme. To do this, we first check if xclip and plymouth-themes is installed, and if not, we ask the user if they
                                    # are okey with installing them. As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not

                                    MISC="xclip plymouth-themes"

                                    for pkg in $MISC; do
                                        if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; then
                                            echo -e "$pkg is already installed"
                                        else
                                            if sudo apt-get -qq install $pkg; then
                                                echo "Successfully installed $pkg"
                                            else
                                                echo "Error installing $pkg"
                                            fi        
                                        fi
                                    done

                                    # 2) Copy one of these themes, the theme called script.
                                    sudo cp -r /usr/share/plymouth/themes/script /usr/share/plymouth/themes/tux-plymouth-theme;  
                                   
                                    # 3) Add tux-plymouth-theme files
                                    sudo cp -r tux-plymouth-theme/* /usr/share/plymouth/themes/tux-plymouth-theme;
                                   
                                    # 4) Copy the internals of our files to existing using xclip
                                    xclip /usr/share/plymouth/themes/tux-plymouth-theme/tux.script;
                                    sudo bash -c '> /usr/share/plymouth/themes/tux-plymouth-theme/script.script';
                                    xclip -out | sudo tee -a /usr/share/plymouth/themes/tux-plymouth-theme/script.script;
                                    xclip /usr/share/plymouth/themes/tux-plymouth-theme/tux.plymouth;
                                    sudo bash -c '> /usr/share/plymouth/themes/tux-plymouth-theme/script.plymouth';
                                    xclip -out | sudo tee -a /usr/share/plymouth/themes/tux-plymouth-theme/script.plymouth;                          
                                    
                                    # 5) Remove our own files
                                    sudo rm /usr/share/plymouth/themes/tux-plymouth-theme/tux.plymouth;
                                    sudo rm /usr/share/plymouth/themes/tux-plymouth-theme/tux.script;
                                    
                                    # 6) And rename the newly created copies
                                    sudo mv /usr/share/plymouth/themes/tux-plymouth-theme/script.script /usr/share/plymouth/themes/tux-plymouth-theme/tux.script
                                    sudo mv /usr/share/plymouth/themes/tux-plymouth-theme/script.plymouth /usr/share/plymouth/themes/tux-plymouth-theme/tux.plymouth

                                    # Then we can add it to default.plymouth and update update-initramfs accordingly
                                    sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/tux-plymouth-theme/tux.plymouth 100;
                                    printf "\033c"
                                    #echo "Soon you will see a list with all themes available to choose tux in the Plymouth menu next (if you want Tux that is ;)";
                                    #read -n1 -r -p "Press any key to continue..." key
                                    sudo update-alternatives --config default.plymouth;
                                    printf "\033c"
                                    echo "Updating initramfs. This could take a while."
                                    sudo update-initramfs -u;


                                    break;;
                                No ) printf "\033c"
                                    echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting..."
                                    exit;;
                                esac
                            done
                        break;;
                    No )  printf "\033c"
                        echo "We're working on adding support for other Linux distributions and Ubuntu versions. So hang tight. Or edit this .sh file and give it a try. Let us know what happens! Tux will be happy for your contributions."
                        exit;;
                esac
            done
            ;;

    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done
x-www-browser http://tux4ubuntu.blogspot.se/2016/11/done.html;