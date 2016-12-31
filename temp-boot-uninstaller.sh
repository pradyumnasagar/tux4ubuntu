# GRUB2 theme
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

# Bootloader Uninstaller   
   
    header "Adding Tux to BOOT LOADER" "$1"
    echo "Are you sure you really want to remove Tux from your boot logo?"
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
                    if grep -q rodsmith/refind /etc/apt/sources.list /etc/apt/sources.list.d/*; then
                        # The rEFInd ppa is not registered. Ask if user wants it installed.
                        printf "\033c"
                        header "Adding Tux to BOOT LOADER" "$1"
                        echo "EFI bootloader detected";
                        echo ""
                        echo "Your system is using EFI and you have rEFInd installed, do you want to remove"
                        echo "that as well when removing Tux?"
                        echo ""
                        echo "(Type 1 or 2, then press ENTER)"
                        select yn in "Yes" "No"; do
                            case $yn in
                                Yes ) printf "\033c"
                                    header "Removing Tux in BOOT LOADER" "$1"
                                    # BEGIN HERE
                                    # sudo grep -q -F 'include themes/tux-refind-theme/theme.conf' /boot/efi/EFI/refind/refind.conf || sed '/pattern to match/d' ./infile
                                    echo 'include themes/tux-refind-theme/theme.conf' | sudo tee -a /boot/efi/EFI/refind/refind.conf
                                    # 
                                    sudo rm -r /efi/EFI/boot/refind/themes/tux-refind-theme
                                    uninstall_if_found "refind"
                                    # Commands to remove the ppa
                                    sudo add-apt-repository --remove ppa:rodsmith/refind
                                    break;;
                                No ) printf "\033c"
                                    header "Removing Tux to BOOT LOADER" "$1"
                                    # Let the user choose if they want to install GRUB2 theme instead
                                    echo "Ok, rEFInd will be spared but Tux removed."
                                    sudo rm -r /efi/EFI/boot/refind/themes/tux-refind-theme                                    
                            esac
                        done
                    else
                        printf "\033c"
                        header "Adding Tux to BOOT LOADER" "$1"
                        echo "Seems like you don't have rEFInd. Trying to remove Tux from GRUB2 if found."
                        uninstall_grub2_theme
                    fi

                    printf "\033c"
                    header "Adding Tux to BOOT LOADER" "$1"
                    echo "Initiating to copy folder tux-refind-theme."
                    echo ""
                    check_sudo
                    sudo mkdir -p /boot/efi/EFI/refind/themes
                    sudo cp -r tux-refind-theme /boot/efi/EFI/refind/themes/tux-refind-theme
                    echo 'include themes/tux-refind-theme/theme.conf' | sudo tee -a /boot/efi/EFI/refind/refind.conf                        
                    echo ""
                    printf "\033c"
                    header "Adding Tux to BOOT LOADER" "$1"
                    echo "Successfully copied 'tux-refind-theme' to your rEFInd themes folder."
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
