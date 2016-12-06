#!/bin/bash
#
# install-ubuntu.sh - Tux4Ubuntu Installer
#                                                   
# Copyright (C) 2016 Tux4Ubuntu Initiative <http://tux4ubuntu.blogspot.com>
#
# Permission is hereby granted, free of charge, 
# to any person obtaining a copy of this software and 
# associated documentation files (the "Software"), to 
# deal in the Software without restriction, including 
# without limitation the rights to use, copy, modify, 
# merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom 
# the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice 
# shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
# ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# Written and designed by: Tuxedo Joe <http://github.com/tuxedojoe>
# for The Tux4Ubuntu Initiative <http://tux4ubuntu.blogspot.com>
#
# For CREDITS AND ATTRIBUTION see README 

# Change directory to same as script is running in
cd "$(dirname "$0")"
# Adds error handling by exiting at first error
set -e
# Cleans the screen
printf "\033c"
# Set global values
STEPCOUNTER=false # Sets to true if user choose to install Tux Everywhere

# Here we check if OS is supported
# More info on other OSes regarding plymouth: http://brej.org/blog/?p=158
if [[ `lsb_release -rs` == "16.04" ]]
then
    # The plymouth dir was moved in one update, therefore we have prepared for this one here
	plymouth_dir="/usr/share/plymouth"
elif [[ `lsb_release -rs` == "15.04" ]]
then
	plymouth_dir="/usr/share/plymouth"
else
	echo "Sorry! We haven't tried installing Tux4Ubuntu on your Linux distrubtion."
    echo "Make sure you have the latest version at http://tux4ubuntu.blogspot.com"	
    echo "(Or fork/edit our project/install-ubuntu.sh for your system, and then make a"
    echo "pull request/send it to us so that more people can use it)"
    echo ""
    echo "Want to go ahead anyway? (Can be a bumby ride, but it might work flawless)"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"            
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) printf "\033c"
                echo "Ahh, a brave one! Tux salutes you!"
                echo "(If you get any error message, copy/paste on our website/stackoverflow"
                echo "and if it works, please write a comment on our start page and let us know)"
                echo ""
                read -n1 -r -p "Press any key to continue..." key
               	
                # We set the 
                plymouth_dir="/usr/share/plymouth"

                break;;

            No ) printf "\033c"
                echo "Feel free to try when you're ready. Tux will be waiting."
                echo ""
                read -n1 -r -p "Press any key to continue..." key
                exit
                break;;
        esac
    done
fi

function change_boot_loader { 
    printf "\033c"
    header "Adding Tux to BOOT LOADER" "$1"
    echo "Do you understand that changing boot loader theme (and potentially the boot"
    echo "loader as well) is not without risk and that we can't be hold responsible if"  
    echo "you proceed? (Our website and internet can help but nothing is 100% safe)"
    echo ""
    echo "WARNING! Before you continue, we also strongly recommend to backup all your data"
    echo ""
    check_sudo
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) printf "\033c"
                if [ -d /sys/firmware/efi ]
                then 
                    if ! grep -q rodsmith/refind /etc/apt/sources.list /etc/apt/sources.list.d/*; then
                        # The rEFInd ppa is not registered. Ask if user wants it installed.
                        printf "\033c"
                        header "Adding Tux to BOOT LOADER" "$1"
                        echo "EFI bootloader detected";
                        echo ""
                        echo "Your system is new enough to boot using EFI, but you're not running the more graphical"
                        echo "bootloader rEFInd. Would you like to install it? Select No if:"
                        echo "    - You want to keep the standard (a bit more stable) GRUB2 boot loader"
                        echo "    - You want to theme GRUB2 instead (not as cool but it gets nicer)"
                        echo "    - You are not dual-booting (since the boot loader only let you choose between OSes)"
                        echo ""
                        echo "(Type 1 or 2, then press ENTER)"
                        select yn in "Yes" "No"; do
                            case $yn in
                                Yes ) printf "\033c"
                                    header "Adding Tux to BOOT LOADER" "$1"
                                    # Commands to add the ppa
                                    sudo apt-add-repository ppa:rodsmith/refind
                                    sudo apt-get update
                                    # Check if refind is installed
                                    install_if_not_found "refind"
                                    echo "Done";
                                    break;;
                                No ) printf "\033c"
                                    header "Adding Tux to BOOT LOADER" "$1"
                                    # Let the user choose if they want to install GRUB2 theme instead
                                    echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting..."
                                    echo ""
                                    echo "However, Tux can also customize your GRUB2 theme. Want to try?"
                                    select yn in "Yes" "No"; do
                                        case $yn in
                                            Yes ) printf "\033c"
                                                header "Adding Tux to BOOT LOADER" "$1"
                                                change_grub2_theme
                                                break;;
                                            No ) printf "\033c"
                                                header "Adding Tux to BOOT LOADER" "$1"
                                                echo "'Come back when you're ready, I'll be waiting here' says Tux."
                                                break;;
                                        esac
                                    done
                            esac
                        done
                    else
                        printf "\033c"
                        header "Adding Tux to BOOT LOADER" "$1"
                        echo "Seems like you have rEFInd installed."
                    fi
                    printf "\033c"
                    header "Adding Tux to BOOT LOADER" "$1"
                    echo "Initiating to copy folder tux-refind-theme."
                    sudo mkdir -p /boot/efi/EFI/refind/themes
                    sudo cp -r tux-refind-theme /boot/efi/EFI/refind/themes/tux-refind-theme
                    echo 'include themes/tux-refind-theme/theme.conf' | sudo tee -a /boot/efi/EFI/refind/refind.conf                        
                else 
                    header "Adding Tux to BOOT LOADER" "$1"
                    echo "BIOS boot noticed."
                    echo ""
                    echo "If you're running a newer system that support EFI, check your BIOS settings."
                    echo "Switching from Legacy to UEFI/EFI might do the trick and will enable a lot"
                    echo "more customization to your boot loader."
                    echo ""
                    echo "If you're running an older system (or maybe you're running a virtual machine)"
                    echo "Tux can customize the BIOS capable GRUB2 loader a little as well. Want to try?";
                    echo ""
                    select yn in "Yes" "No"; do
                        case $yn in
                            Yes ) printf "\033c"
                                header "Adding Tux to BOOT LOADER" "$1"
                                change_grub2_theme
                                echo ""
                                echo "Successfully themed your GRUB2 Boot Loader."
                                break;;
                            No ) printf "\033c"
                                header "Adding Tux to BOOT LOADER" "$1"
                                echo "Tux stares at you with a curious look... Then he smiles and says 'Ok'."
                                break;;
                        esac
                    done
                fi
                break;;
            No ) printf "\033c"
                header "Adding Tux to BOOT LOADER" "$1"
                echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting..."

                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function change_boot_logo {
    printf "\033c"
    header "Addding Tux as BOOT LOGO" "$1"
    echo "Do you understand that changing boot logo is not without risk and that we can't"  
    echo "be hold responsible if you proceed? (Our website and internet can help but"
    echo "nothing is 100% safe)"
    echo ""
    echo "And do you also agree that Tux can install apt-packages 'xclip' and plymouth-"
    echo "themes' if not found since they are needed for the installation?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"            
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "Addding Tux as BOOT LOGO" "$1"
                check_sudo
                # Workaround what we think is an Ubuntu Plymouth bug that doesn't seem to allow foreign plymouth themes
                # so instead of simply sudo cp -r tux-plymouth-theme/ $plymouth_dir/themes/tux-plymouth-theme we 
                # have to (6 steps):
                    
                # 1) Add other themes through the apt-get package 'plymouth-themes' that seem to work as well as 'xclip'
                # -package to successfully copy the internals of tux.script, tux.plymouth to a copy of the plymouth-themes's
                # 'script'-theme. To do this, we first check if xclip and plymouth-themes is installed, and if not, we ask the user if they
                # are okey with installing them. As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not
                install_if_not_found "plymouth-themes xclip"

                # 2) Copy one of these themes, the theme called script.
                sudo cp -r $plymouth_dir/themes/script $plymouth_dir/themes/tux-plymouth-theme;  
                
                # 3) Add tux-plymouth-theme files
                sudo cp -r tux-plymouth-theme/* $plymouth_dir/themes/tux-plymouth-theme;
                
                # 4) Copy the internals of our files to existing using xclip
                sudo xclip $plymouth_dir/themes/tux-plymouth-theme/tux.script;
                sudo bash -c '> '$plymouth_dir'/themes/tux-plymouth-theme/script.script';
                xclip -out | sudo tee -a $plymouth_dir/themes/tux-plymouth-theme/script.script;
                sudo xclip $plymouth_dir/themes/tux-plymouth-theme/tux.plymouth;
                sudo bash -c '> '$plymouth_dir'/themes/tux-plymouth-theme/script.plymouth';
                xclip -out | sudo tee -a $plymouth_dir/themes/tux-plymouth-theme/script.plymouth;                          
                
                # 5) Remove our own files
                sudo rm $plymouth_dir/themes/tux-plymouth-theme/tux.plymouth;
                sudo rm $plymouth_dir/themes/tux-plymouth-theme/tux.script;
                
                # 6) And rename the newly created copies
                sudo mv $plymouth_dir/themes/tux-plymouth-theme/script.script $plymouth_dir/themes/tux-plymouth-theme/tux.script
                sudo mv $plymouth_dir/themes/tux-plymouth-theme/script.plymouth $plymouth_dir/themes/tux-plymouth-theme/tux.plymouth

                # Then we can add it to default.plymouth and update update-initramfs accordingly
                sudo update-alternatives --install $plymouth_dir/themes/default.plymouth default.plymouth $plymouth_dir/themes/tux-plymouth-theme/tux.plymouth 100;
                printf "\033c"
                header "Addding Tux as BOOT LOGO" "$1"
                echo "Below you will see a list with all themes available to choose tux in the "
                echo "Plymouth menu next (if you want Tux that is ;)";
                echo ""
                read -n1 -r -p "Press any key to continue..." key
                sudo update-alternatives --config default.plymouth;
                echo "Updating initramfs. This could take a while."
                sudo update-initramfs -u;
                printf "\033c"
                header "Addding Tux as BOOT LOGO" "$1"
                echo "Tux successfully moved in as your new Boot Logo."
                break;;
            No )
                printf "\033c"
                header "Addding Tux as BOOT LOGO" "$1"
                echo "It's not that dangerous though! Feel free to try when you're ready. Tux will be waiting."
            break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function change_login_screen {
    printf "\033c"
    header "Adding tuxedo class to your LOGIN SCREEN" "$1"
    echo "This will disable the standard Ubuntu background and the grid with dots on your"
    echo "login screen. By doing this the background will stay black all the way from the"
    echo "boot loader to where the users background will load (which it does at the login" 
    echo "screen). Ready to do this?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                echo "Starting configure dconf login settings..."
                check_sudo
                # To configure dconf we need to run as su, and then lightdm. 
                # But first we put it in tmp for easier access
                sudo cp tux-login-cleanup/tux-login-gsettings.sh /tmp
                # Make it executable by all so that lightdm can run it
                sudo chmod 0755 /tmp/tux-login-gsettings.sh
                # As already mentioned, we need to do it as su, otherwise changes don't take effect
                sudo bash tux-login-cleanup/tux-login-script.sh 
                # Now we can remove the script from tmp
                sudo rm /tmp/tux-login-gsettings.sh
                printf "\033c"
                header "Adding tuxedo class to your LOGIN SCREEN" "$1"
                echo "Successfully tuxedoed up your Login Screen."
                break;;
            No ) printf "\033c"
                header "Adding tuxedo class to your LOGIN SCREEN" "$1"
                echo "Tux stares at you with a curious look... Then he smiles and says 'Ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function change_desktop {
    printf "\033c"
    header "Adding tuxedo class to your DESKTOP" "$1"
    echo "Tux has scanned the web for the best themes and he likes:"
    echo "   - Arc Theme by horst3180 <https://github.com/horst3180/arc-theme>"
    echo "   - Paper Icon Theme at snwh.org <https://snwh.org/paper>"
    echo "   - Roboto Font by Google <https://www.fontsquirrel.com/fonts/roboto>"
    echo ""
    echo "He plans to install these and 'Unity Tweak Tool' (if non of these are installed"
    echo "already). THEN, he plans to set himself as your 'Search your computer'-icon in"
    echo "the launcher (the icon furthest up or left depending on where your launcher is)."
    echo "Are you okay with that?"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "Adding tuxedo class to your DESKTOP" "$1"
                echo "Installing packages..."
                check_sudo
                # Check if ppa's exists, otherwise add them
                arc_ppa_added=false
                if grep -q Horst3180 /etc/apt/sources.list /etc/apt/sources.list.d/*; then
                    echo "Horst3180 already added to ppa."
                else
                    echo "Adding Horst3180/arc-theme to ppa."
                    sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/Horst3180/xUbuntu_16.04/ /' >> /etc/apt/sources.list.d/arc-theme.list"
                    arc_ppa_added=true
                fi
                if grep -q snwh/pulp /etc/apt/sources.list /etc/apt/sources.list.d/*; then
                    echo "snwh/pulp already added to ppa."
                else
                    echo "Adding snwh/pulp to ppa."
                    sudo add-apt-repository ppa:snwh/pulp
                fi
                # Update apt-get
                sudo apt-get update
                # Install packages
                install_if_not_found "arc-theme paper-icon-theme paper-gtk-theme paper-cursor-theme unity-tweak-tool"
                # Add release keys where apt-key support it
                if [ "$arc_ppa_added" = true ]; then
                    arc_temp_dir=$(mktemp -d)
                    wget -O $arc_temp_dir/Release.key http://download.opensuse.org/repositories/home:Horst3180/xUbuntu_16.04/Release.key
                    sudo apt-key add - < $arc_temp_dir/Release.key
                fi
                # Download and install Roboto Fonts (as described here: https://wiki.ubuntu.com/Fonts)
                if fc-list | grep -i roboto >/dev/null; then
                    echo "Roboto fonts already installed"
                else
                    echo "Installing Roboto fonts by Google"
                    roboto_temp_dir=$(mktemp -d)
                    wget -O $roboto_temp_dir/roboto.zip https://www.fontsquirrel.com/fonts/download/roboto
                    unzip $roboto_temp_dir/roboto.zip -d $roboto_temp_dir
                    sudo mkdir -p ~/.fonts
                    sudo cp $roboto_temp_dir/*.ttf ~/.fonts/
                    printf "Updating font cache (may take a while)"
                    fc-cache -f -v
                fi
                # Copy an image of Tux to be your default launcher icon
                sudo cp tux-icon-theme/launcher_bfb.png /usr/share/unity/icons/
                printf "\033c"
                echo "Successfully installed theme, icons and fonts (and Tux on your launcher)." 
                echo "We'll open Unity Tweak Tool for you and there you can choose"
                echo "(which is suggested by Tux):"
                echo ""
                echo "Under Themes      ->      Choose 'Arc'"
                echo "Under Icons       ->      Choose 'Paper'"
                echo "Under Fonts       ->      Default Font -> 'Roboto Regular'"
                echo "                          Window Title Font -> 'Roboto Black'"
                echo ""
                echo "IMPORTANT: Close Unity Tweak Tool to continue installation."
                read -n1 -r -p "Press any key to open Unity Tweak Tool..." key
                unity-tweak-tool -a
                printf "\033c"
                echo "Successfully added some theming options á la Tux."
                break;;
            No ) printf "\033c"
                header "Adding tuxedo class to your DESKTOP" "$1"
                echo "Tux stares at you with a curious look... Then he smiles and says 'Ok'."
                break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
}

function check_sudo {
    if sudo -n true 2>/dev/null; then 
        :
    else
        echo ""
        echo "Oh, and Tux will need sudo rights to copy and install everything, so he'll ask" 
        echo "about that below."
        echo ""
    fi
}

function install_if_not_found { 
    # As found here: http://askubuntu.com/questions/319307/reliably-check-if-a-package-is-installed-or-not
    for pkg in $1; do
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
}

function change_grub2_theme { 
    # Install grub2 theme
    echo "Copying tux-grub2-theme to /boot/grub/themes/"
    sudo cp -r tux-grub2-theme /boot/grub/themes/
    echo "Adding 'GRUB_THEME=/boot/grub/themes/tux-grub2-theme/theme.txt' to '/etc/default/grub'"
    sudo grep -q -F 'GRUB_THEME="' /etc/default/grub || sudo sh -c "echo 'GRUB_THEME="/boot/grub/themes/tux-grub2-theme/theme.txt"' >> /etc/default/grub"
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

function header {
    var_size=${#1}
    # 80 is a full width set by us (to work in the smallest standard terminal window)
    if [ $STEPCOUNTER = false ]; then
        # 80 - 2 - 1 = 77 to allow space for side lines and the first space after border.
        len=$(expr 77 - $var_size)
    else   
        # "Step X/X " is 9
        # 80 - 2 - 1 - 9 = 68 to allow space for side lines and the first space after border.
        len=$(expr 68 - $var_size)
    fi

    ch=' '
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    printf "║"
    printf " $1"
    printf '%*s' "$len" | tr ' ' "$ch"
    if [ $STEPCOUNTER = true ]; then
        printf "Step "$2
        printf "/7 "
    fi
    printf "║\n"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""

}

while :
do
    clear
    # Menu system as found here: http://stackoverflow.com/questions/20224862/bash-script-always-show-menu-after-loop-execution
    cat<<EOF    
╔══════════════════════════════════════════════════════════════════════════════╗
║ TUX 4 UBUNTU                                    © 2016 Tux4Ubuntu Initiative ║
║ Let's bring Tux to Ubuntu                     http://tux4ubuntu.blogspot.com ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║   Where do you want Tux? (Type in one of the following numbers)              ║
║                                                                              ║
║   1) Everywhere                                - Install all of the below    ║
║   ------------------------------------------------------------------------   ║
║   2) Boot Loader                               - Themes OS selection at boot ║
║   3) Boot Logo                                 - Install Plymouth theme      ║
║   4) Login Screen                              - Remove grid and wallpaper   ║
║   5) Desktop Theme/Icons/Fonts + Tux           - Some class to your desktop  ║
║   6) Wallpapers                                - Adds Tux favourite images   ║
║   7) Games                                     - Install games feat. Tux     ║
║   8) On my belly!                              - Buy the t-shirt             ║
║   ------------------------------------------------------------------------   ║
║   9) Uninstall Tux                             - Uninstall the above         ║
║   ------------------------------------------------------------------------   ║
║   Q) I'm done                                  - Quits installer             ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    read -n1 -s
    case "$REPLY" in
    "1")    # Install everything
            STEPCOUNTER=true
            i=1
            change_boot_loader $i
            ((i++))
            change_boot_logo $i
            ((i++))
            change_login_screen $i
            ((i++))
            change_desktop $i
            ;;
    "2")    change_boot_loader ;;
    "3")    change_boot_logo ;;
    "4")    change_login_screen ;;
    "5")    change_desktop ;;
    "6")    # Wallpaper 
            ;;
    "7")    # Games
            ;;
    "8")    # Buy the t-shirt
            ;;
    "9")    # Uninstall
            ;;
    "Q")    exit                      ;;
    "q")    exit                      ;;
     * )    echo "invalid option"     ;;
    esac
    sleep 1
done
x-www-browser http://tux4ubuntu.blogspot.se/2016/11/done.html;