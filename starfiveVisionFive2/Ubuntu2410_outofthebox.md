# Ubuntu 24.10 on StarFive VisionFive 2 with AMDGPU

Ubuntu 24.10 is using the 6.11 kernel. This has the PCI-e controller of StarFive VisionFive 2 + AMDGPU drivers that are working with RISC-V.
So if you have a m2 to pci-e adapter you can now run Ubuntu with AMDGPU on RISC-V (without building your own kernel with patches etc.)

The only problem is now the u-boot that initialize the PCI-e controller to scan for m.2 drivers. Some of my AMDPGU do not like that (fan 100% and not detected anymore in the kernel).

So we need a u-boot (from Ubuntu) without the initialization of the PCI-e controller. I have build that and release the flash-files (u-boot + opensbi) on github.

So we can now just flash Ubuntu 24.10 to an eMMC, use the custom flash-files (u-boot + opensbi).

a lot of AMDGPU's worked on this setup:

- ATI Radeon HD 5450 (Cedar PRO)
- ATI Radeon HD 5850 (Cypress PRO)
- AMD Radeon R9 290 (Hawaii PRO)
- AMD Radeon R9 290X (Hawaii XT)

not working:

- AMD Radeon RX 6600 (Navi 23 XL)

It is booting, it gives screenoutput (black) and then the system hangs completely

## Flash Ubuntu 24.10 to eMMC

download from the [site](https://ubuntu.com/download/risc-v) the [image 24.10](https://cdimage.ubuntu.com/releases/24.10/release/ubuntu-24.10-preinstalled-server-riscv64+nezha.img.xz).

I used "balenaEtcher" to flash this to my eMMC (with an USB to eMMC adapter).

## Create/download u-boot without PCI-e initialization and flash to SD

We need a custom u-boot that will not try to initialize the PCI-e controller (scan for m.2 device). Some of the AMDGPU's don't like that (fan 100% and not detected anymore in the kernel)

So on build we need to set `CONFIG_PCI_INIT_R` and `CONFIG_CMD_PCI` to n (no).

I all ready create this builds and they can be found [here](https://github.com/Opvolger/ansible-riscv-sd-card-creater/releases):

Insert you SD-card in you computer

```bash
wget https://github.com/Opvolger/ansible-riscv-sd-card-creater/releases/download/0.1.0/release.tgz
tar -xvzf release.tgz
# check where your SD-card is with lsblk, in this example it is /dev/sdb
# delete MBR of SD-Card
sudo dd if=/dev/zero of=/dev/sdb bs=512 count=1 conv=notrunc
# we will create the needed partitions to boot from SD-card
sudo sgdisk --clear \
    --set-alignment=2 \
    --new=1:4096:8191 --change-name=1:spl --typecode=1:2E54B353-1271-4842-806F-E436D6AF6985 \
    --new=2:8192:16383 --change-name=2:uboot --typecode=2:BC13C2FF-59E6-4262-A352-B275FD6F7172 \
    /dev/sdb
# now "flash" the firmware on the sd-card
sudo dd if=release/ubuntu-24-10/u-boot-spl.bin.normal.out of=/dev/sdb1
sudo dd if=release/ubuntu-24-10/u-boot.itb of=/dev/sdb2
```

If booting ubuntu is not working (you can see it with serial-connection for example `screen -L /dev/ttyUSB0 115200`), go back to default settings in u-boot with:

how to set the default is explained also in the ubuntu [site](https://canonical-ubuntu-boards.readthedocs-hosted.com/en/latest/how-to/starfive-visionfive-2/). The only different is that I am using the sd-card and not the onboard flash.

StarFive #

```bash
env default -f -a
env save
```

Reboot you board (power off/on)

## First boot Ubuntu

login with ubuntu/ubuntu (you have to change the password!)

```bash
sudo timedatectl set-timezone Europe/Amsterdam
# check if the date is correct (now)!
date
sudo apt update
sudo apt upgrade
# add repo for firefox
sudo add-apt-repository ppa:mozillateam/ppa
# install what default stuff + install kde + firefox + some c dev tools (so you can compile some stuff)
sudo apt install software-properties-common cmake cabextract sddm sddm-theme-breeze kde-standard build-essential libxml2 libcurl4-gnutls-dev neofetch ubuntu-dev-tools libopenal-dev libpng-dev libjpeg-dev libfreetype6-dev libfontconfig1-dev libcurl4-gnutls-dev libsdl2-dev zlib1g-dev libbz2-dev libedit-dev python-is-python3 m4 clang sddm-theme-breeze firefox
```

I did get a configuration i had to fill in: `Please enter the default mirror you want to be used by pbuilder.`
I hit enter and get the question again, so i filled in: `http://archive.ubuntu.com/ubuntu` and it was installing again.

```bash
# now reboot
sudo reboot
```

## Done

You will now see a KDE desktop login! Good luck and have fun!
