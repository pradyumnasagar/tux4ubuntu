#!/bin/bash
cd "$(dirname "$0")"
set -e
#printf "\033c"

# TODO: Add to search on /lib/plymouth/themes. On other systems it is /usr/share/plymouth
#       More info on other OSes: http://brej.org/blog/?p=158

# Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
# Tux as ASCII found here: http://www.chris.com/ascii/index.php?art=logos%20and%20insignias/linux

while :
do
    clear
    cat<<EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║ Tux4Ubuntu - Let's bring Tux to Ubuntu          © 2016 Tux4Ubuntu Initiative ║
║ http://tux4ubuntu.blogspot.com                                               ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   Where do you want Tux?                                                     ║
║                                                                              ║
║   1) Everywhere                                - Installs all of the below   ║
║   ------------------------------------------------------------------------   ║
║   2) Boot Loader                               - Installs rEFInd theme       ║
║   3) Boot Logo                                 - Installs Plymouth theme     ║
║   4) Login Screen                              - Updates icons and colors    ║
║   5) Desktop theme & icons                     - Specialized unity theme     ║
║   6) Wallpapers                                - Adds Tux favourite images   ║
║   7) Games                                     - Installs games feat. Tux    ║
║   8) On my belly!                              - Buy the t-shirt             ║
║   ------------------------------------------------------------------------   ║
║   Q) I'm done                                  - Quits installer             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    read -n1 -s
    case "$REPLY" in
    "1")    echo "you chose choice 1" ;;
    "2")    # Boot Loader

            # As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not
            echo "Do you understand that changing bootloader is not without risk? And we can't be ";
            echo "hold responsible if you proceed. Internet can help, but nothing is 100% safe.";
                        
            select yn in "Yes" "No"; do
            case $yn in
                Yes ) #printf "\033c"
                    echo "Ok, here we go!"
                    if [ -d /sys/firmware/efi ]
                    then 
                        echo "EFI bootloader detected";
                        if ! grep -q rodsmith/refind /etc/apt/sources.list /etc/apt/sources.list.d/*; then
                            # The rEFInd ppa is not registered. Ask if user wants it installed.
                            echo "Your system is new enough to boot using EFI, but it seems like you're using the"
                            echo "standard GRUB boot loader (which is okay it can't be customized very nicely)."
                            echo "Therefore (and because of other reasons as well) Tux recommend using"
                            echo "rEFInd Bootloader."  
                            echo ""
                            echo "Want to install it?"
                            
                            select yn in "Yes" "No"; do
                            case $yn in
                                Yes ) #printf "\033c"

                                    echo "test";

                                    break;;
                                No ) #printf "\033c"
                                    echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting..."
                                    exit;;
                                esac
                            done

                            # Commands to add the ppa ...
                            sudo apt-add-repository ppa:rodsmith/refind
                            sudo apt-get update
                            MISC="refind"

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
                        else
                            #printf "\033c"
                            echo "Seems like you have rEFInd installed."
                        fi
                            echo "Starting to copy rEFInd theme."
                            sudo mkdir -p /boot/efi/EFI/refind/themes
                            sudo cp -r tux-refind-theme /boot/efi/EFI/refind/themes/tux-refind-theme

                    else 
                        echo "BIOS boot noticed. ";




                    fi

                    read -n1 -r -p "Press any key to continue..." key

                    break;;
                No ) #printf "\033c"
                    echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting..."
                    exit;;
                esac
            done ;;



    "3")    # Boot Logo
            #printf "\033c"
            echo "Are you running Ubuntu 16.04?"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) #printf "\033c"
                        echo "Do you understand that changing bootlogo is not without risk? And we can't be ";
                        echo "hold responsible if you proceed. Internet can help, but nothing is 100% safe.";
                        select yn in "Yes" "No"; do
                            case $yn in
                                Yes ) #printf "\033c"
                                    echo "Ok, here we go!"
                                    echo "PS. Tux needs to use apt-get packages 'plymouth-theme' and 'xclip', if not" 
                                    echo "installed you will be asked to install them. And sudo rights will also be asked" 
                                    echo "for, so that Tux can copy the theme to your plymouth folder."
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
                                    #printf "\033c"
                                    #echo "Soon you will see a list with all themes available to choose tux in the Plymouth menu next (if you want Tux that is ;)";
                                    #read -n1 -r -p "Press any key to continue..." key
                                    sudo update-alternatives --config default.plymouth;
                                    #printf "\033c"
                                    echo "Updating initramfs. This could take a while."
                                    sudo update-initramfs -u;


                                    break;;
                                No ) #printf "\033c"
                                    echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting..."
                                    exit;;
                                esac
                            done
                        break;;
                    No )  #printf "\033c"
                        echo "We're working on adding support for other Linux distributions and Ubuntu versions. So hang tight. Or edit this .sh file and give it a try. Let us know what happens! Tux will be happy for your contributions."
                        exit;;
                esac
            done
            ;;

    "Q")    exit                      ;;
    "q")    echo "case sensitive!!"   ;; 
     * )    echo "invalid option"     ;;
    esac
    sleep 1
done
x-www-browser http://tux4ubuntu.blogspot.se/2016/11/done.html;