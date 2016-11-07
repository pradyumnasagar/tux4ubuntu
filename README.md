# tux4ubuntu-plymouth-theme
Let's bring Tux to Ubuntu!

Ubuntu is nice but it needs a little Tux. Here he is, the man himself in the bootscreen, xsplash or as a Plymouth theme (whatever you would call it.

Written and designed by Tuxedo Joe <http://github.com/tuxedojoe> for The Tux4Ubuntu Initiative <http://tux4ubuntu.blogspot.com>. Based on the Plymouth example provided with the "script plugin" written by Charlie Brej <cbrej@cs.man.ac.uk> Original Tux illustration by Larry Ewing <http://isc.tamu.edu/~lewing/linux/>, redrawn in Inkscape by Garrett LeSage <https://github.com/garrett/Tux>.

Either run the install.sh script (write "./install.sh" when in this folder using the terminal), or just type the following commands:

      Copy the theme (earlier Ubuntu versions had the themes in /lib/plymouth/themes/)
          1) sudo cp -r tux4ubuntu/ /usr/share/plymouth/themes/
      Add the theme to Plymouth (remember to change the folder adresses if needed)
          2) sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/tux4ubuntu/tux4ubuntu.plymouth 100
      Change the default theme, follow the instructions
          3) sudo update-alternatives --config default.plymouth
      Update initramfs"
          4) sudo update-initramfs -update

Let us know what you think!