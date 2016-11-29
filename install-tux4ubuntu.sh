#!/bin/sh

set -e

gh_repo="tux4ubuntu"
gh_desc="Tux 4 Ubuntu - Let's bring Tux to Ubuntu"

cat <<- EOF


     _____ _   ___  __  _  _     _   _ ____  _   _ _   _ _____ _   _ 
    |_   _| | | \ \/ / | || |   | | | | __ )| | | | \ | |_   _| | | |
      | | | | | |\  /  | || |_  | | | |  _ \| | | |  \| | | | | | | |
      | | | |_| |/  \  |__   _| | |_| | |_) | |_| | |\  | | | | |_| |
      |_|  \___//_/\_\    |_|    \___/|____/ \___/|_| \_| |_|  \___/ 
                                                                      

  $gh_desc
  https://github.com/tuxedojoe/$gh_repo


EOF

temp_dir=$(mktemp -d)

echo "=> Getting the latest version from GitHub ..."
wget -O "/tmp/$gh_repo.tar.gz" \
  https://github.com/tuxedojoe/$gh_repo/archive/master.tar.gz
echo "=> Unpacking archive ..."
tar -xzf "/tmp/$gh_repo.tar.gz" -C "$temp_dir"
echo "=> Launching installer..."
/tmp/$temp_dir/tux4ubuntu-master/install-ubuntu.sh