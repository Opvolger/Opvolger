---
date: 2023-02-05
author: Bas Magré
---
# StarFive VisionFive 2 - OpenSuse Tumbleweed with external GPU ATI Radeon R9 290

In addition to Ubuntu and Fedora, I had also run OpenSuse Tumbleweed on the StarFive VisionFive 2. I had never written a manual for this before. Hence this manual.
The entire manual works from 1 directory. In my case ~/OpenSuseTumbleweed

```bash
$ mkdir OpenSuseTumbleweed
$ cd OpenSuseTumbleweed/
```

## Downloads

We'll start with some downloads, we'll need:

- images from OpenSuse Tumbleweed [site](https://en.opensuse.org/HCL:VisionFive2)
- EFI-boot from Ubuntu [site](https://packages.ubuntu.com/mantic/cd-boot-images-riscv64)
- kernel/firmware from StarFive VisionFive 2 repo [site](https://github.com/starfive-tech/VisionFive2)

### Update firmware of the StarFive VisionFive 2

I have already described this in the Ubuntu 23.10 manual [here](UbuntuATIRadeonR9_290_2023_11_20.md).

But there is a newer version so here a short version:

```bash
# download firmware
$ wget https://github.com/starfive-tech/VisionFive2/releases/download/JH7110_VF2_515_v5.10.3/u-boot-spl.bin.normal.out
--2024-02-10 14:02:38--  https://github.com/starfive-tech/VisionFive2/releases/download/JH7110_VF2_515_v5.10.3/u-boot-spl.bin.normal.out
Resolving github.com (github.com)... 140.82.121.3
Connecting to github.com (github.com)|140.82.121.3|:443... connected.
...
...
...
Length: 148440 (145K) [application/octet-stream]
Saving to: ‘u-boot-spl.bin.normal.out’

u-boot-spl.bin.normal.out                                                    100%[===========================================================================================================================================================================================>] 144,96K  --.-KB/s    in 0,02s   

2024-02-10 14:02:39 (7,36 MB/s) - ‘u-boot-spl.bin.normal.out’ saved [148440/148440]

# download firmware
$ wget https://github.com/starfive-tech/VisionFive2/releases/download/JH7110_VF2_515_v5.10.3/visionfive2_fw_payload.img
--2024-02-10 14:03:29--  https://github.com/starfive-tech/VisionFive2/releases/download/JH7110_VF2_515_v5.10.3/visionfive2_fw_payload.img
Resolving github.com (github.com)... 140.82.121.4
Connecting to github.com (github.com)|140.82.121.4|:443... connected.
...
...
...
2024-02-10 14:03:30 (14,1 MB/s) - ‘visionfive2_fw_payload.img’ saved [3015045/3015045]

# take down your firewall (so port 69 can be used)
$ sudo systemctl stop firewalld.service 
[sudo] password for opvolger: 

# startup docker container with tftp of this directory
$ docker run -p 0.0.0.0:69:69/udp -v $(pwd):/var/tftpboot -i -t pghalliday/tftp
```

Do NOT hit Ctrl+C! We need this server until we are done flashing! Keep it running

Setup your VisionFive 2 without a SD-card and the USB to TTL connected (see [link](https://doc-en.rvspace.org/VisionFive2/PDF/VisionFive2_QSG.pdf) for more information)

My machine (with docker) has ip-address 192.168.2.29 and I give my VisionFive 2 the ip 192.168.2.222

Open a new terminal (keep docker running)

```bash
# This will open a serial screen to your VisionFive 2
screen -L /dev/ttyUSB0 115200
```

Boot up your VisionFive 2

```bash
...
...
...
Loading: *
ARP Retry count exceeded; starting again
StarFive #
```

This will be the commands (for the StarFive firmware):

```bash
# set the ip of the VisionFive 2, and of the server (where docker is running)
$ setenv ipaddr 192.168.2.222; setenv serverip 192.168.2.29
# test network
$ ping 192.168.2.29
# Initialize SPI Flash
$ sf probe
# Download and Update SPL binary
$ tftpboot 0xa0000000 ${serverip}:u-boot-spl.bin.normal.out
$ sf update 0xa0000000 0x0 $filesize
# Download and Update U-Boot binary
$ tftpboot 0xa0000000 ${serverip}:visionfive2_fw_payload.img
$ sf update 0xa0000000 0x100000 $filesize
# We will not need to reset to default now!
# Save your changes
$ env save
```

The output will be something like this:

```bash
StarFive # setenv ipaddr 192.168.2.222; setenv serverip 192.168.2.29
StarFive # ping 192.168.2.29
Using ethernet@16040000 device
host 192.168.2.29 is alive
StarFive # sf probe
SF: Detected gd25lq128 with page size 256 Bytes, erase size 4 KiB, total 16 MiB
StarFive # tftpboot 0xa0000000 ${serverip}:u-boot-spl.bin.normal.out
Using ethernet@16040000 device
TFTP from server 192.168.2.29; our IP address is 192.168.2.222
Filename 'u-boot-spl.bin.normal.out'.
Load address: 0xa0000000
Loading: ###########
         960 KiB/s
done
Bytes transferred = 148440 (243d8 hex)
StarFive # sf update 0xa0000000 0x0 $filesize
device 0 offset 0x0, size 0x243d8
148440 bytes written, 0 bytes skipped in 1.202s, speed 126143 B/s
StarFive # sf update 0xa0000000 0x0 $filesize
device 0 offset 0x0, size 0x243d8
148440 bytes written, 0 bytes skipped in 1.202s, speed 126143 B/s
StarFive # sf update 0xa0000000 0x0 $filesize
device 0 offset 0x0, size 0x243d8
0 bytes written, 148440 bytes skipped in 0.26s, speed 5241467 B/s
StarFive # tftpboot 0xa0000000 ${serverip}:visionfive2_fw_payload.img
Using ethernet@16040000 device
TFTP from server 192.168.2.29; our IP address is 192.168.2.222
Filename 'visionfive2_fw_payload.img'.
Load address: 0xa0000000
Loading: #################################################################
         #################################################################
         #################################################################
         ###########
         1 MiB/s
done
Bytes transferred = 3015045 (2e0185 hex)
StarFive # sf update 0xa0000000 0x100000 $filesize
device 0 offset 0x100000, size 0x2e0185
1970176 bytes written, 1044869 bytes skipped in 16.433s, speed 187844 B/s
StarFive # env save
Saving Environment to SPIFlash... Erasing SPI flash...Writing to SPI flash...done
OK
```

Done!

You can now hit Ctrl+C on your docker terminal and start your firewall again

```bash
$ sudo systemctl start firewalld.service
[sudo] password for opvolger:
```

You can turn off the VisionFive 2 again

### Images from OpenSuse Tumbleweed

Download the images from the OpenSuse Tumbleweed [site](https://en.opensuse.org/HCL:VisionFive2).

```bash
$ wget https://download.opensuse.org/repositories/devel:/RISCV:/Factory:/Contrib:/StarFive:/VisionFive2/images/openSUSE-Tumbleweed-RISC-V-JeOS-starfivevisionfive2.riscv64-2024.01.16-Build23.43.raw.xz
--2024-02-10 13:47:06--  https://download.opensuse.org/repositories/devel:/RISCV:/Factory:/Contrib:/StarFive:/VisionFive2/images/openSUSE-Tumbleweed-RISC-V-JeOS-starfivevisionfive2.riscv64-2024.01.16-Build23.43.raw.xz
...
...
...
2024-02-10 13:48:08 (14,3 MB/s) - ‘openSUSE-Tumbleweed-RISC-V-JeOS-starfivevisionfive2.riscv64-2024.01.16-Build23.43.raw.xz’ saved [928465828/928465828]
```

Now flash it to a SD-card. I use balenaEtcher for it. (on my machine it was /dev/sdb)

### Compile the 6.1.31+ kernel

I have installed Fedora linux and had to install some stuff to be able to cross compile

```bash
$ sudo dnf group install "Development Tools"
$ sudo dnf install git gcc-plugin-devel libmpc-devel gcc-c++ gcc-c++-riscv64-linux-gnu ncurses-devel libmpc-devel
```

We need to checkout the kernel of StarFive and make some changes

```bash
# we need the firmware for AMD / ATI cards, we do not need history so depth 1
$ git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git linux-firmware
Cloning into 'linux-firmware'...
remote: Enumerating objects: 3389, done.
remote: Counting objects: 100% (3389/3389), done.
remote: Compressing objects: 100% (2461/2461), done.
remote: Total 3389 (delta 1233), reused 2471 (delta 832), pack-reused 0
Receiving objects: 100% (3389/3389), 435.72 MiB | 13.27 MiB/s, done.
Resolving deltas: 100% (1233/1233), done.
Updating files: 100% (3554/3554), done.

# We need the kernel of StarFive, we do not need history so depth 1
$ git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git linux-firmware
Cloning into 'linux-firmware'...
remote: Enumerating objects: 3389, done.
remote: Counting objects: 100% (3389/3389), done.
remote: Compressing objects: 100% (2461/2461), done.
remote: Total 3389 (delta 1233), reused 2471 (delta 832), pack-reused 0
Receiving objects: 100% (3389/3389), 435.72 MiB | 13.27 MiB/s, done.
Resolving deltas: 100% (1233/1233), done.
Updating files: 100% (3554/3554), done.
opvolger@desktop:~/OpenSuseTumbleweed$ ^C
opvolger@desktop:~/OpenSuseTumbleweed$ git clone --branch VF2_6.1_v3.8.2 --depth 1 https://github.com/starfive-tech/linux.git
Cloning into 'linux'...
remote: Enumerating objects: 84693, done.
remote: Counting objects: 100% (84693/84693), done.
remote: Compressing objects: 100% (78851/78851), done.
remote: Total 84693 (delta 8228), reused 22621 (delta 4958), pack-reused 0
Receiving objects: 100% (84693/84693), 233.16 MiB | 7.86 MiB/s, done.
Resolving deltas: 100% (8228/8228), done.
Note: switching to '22e0315434b13cdde93ded101b567d5d1c4d5a2e'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

Updating files: 100% (79971/79971), done.

#Go to the kernel dir
$ cd linux

# create a "default" .config for the kernel compilation
$ make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- starfive_jh7110_defconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/confdata.o
  HOSTCC  scripts/kconfig/expr.o
  LEX     scripts/kconfig/lexer.lex.c
  YACC    scripts/kconfig/parser.tab.[ch]
  HOSTCC  scripts/kconfig/lexer.lex.o
  HOSTCC  scripts/kconfig/menu.o
  HOSTCC  scripts/kconfig/parser.tab.o
  HOSTCC  scripts/kconfig/preprocess.o
  HOSTCC  scripts/kconfig/symbol.o
  HOSTCC  scripts/kconfig/util.o
  HOSTLD  scripts/kconfig/conf
#
# configuration written to .config
#

# open the menu
$ make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv menuconfig
```

Now we have to add the ATI video-card and HDMI-audio.

```
Device Drivers ---> [HIT ENTER]
  Generic Driver Options ---> [HIT ENTER]
    Firmware loader ---> [HIT ENTER]
      () Build named firmware blobs into the kernel binary [HIT ENTER]
      (/lib/firmware) Firmware blobs root directory [change it to ../linux-firmware]
```

enter this in the line:

(radeon bins for ATI Radeon 5450, amdgpu/radeon bin files of AMD/ATI Hawaii PRO [Radeon R9 290/390] (has 2 drivers amd and ATI) and rt2870.bin for my wifi dongel)

```ini
radeon/CYPRESS_uvd.bin radeon/CEDAR_smc.bin radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin radeon/CEDAR_rlc.bin amdgpu/hawaii_k_smc.bin amdgpu/hawaii_smc.bin amdgpu/hawaii_uvd.bin amdgpu/hawaii_vce.bin amdgpu/hawaii_sdma.bin amdgpu/hawaii_sdma1.bin amdgpu/hawaii_pfp.bin amdgpu/hawaii_me.bin amdgpu/hawaii_ce.bin amdgpu/hawaii_rlc.bin amdgpu/hawaii_mec.bin amdgpu/hawaii_mc.bin radeon/hawaii_pfp.bin radeon/hawaii_me.bin radeon/hawaii_ce.bin radeon/hawaii_mec.bin radeon/hawaii_mc.bin radeon/hawaii_rlc.bin radeon/hawaii_sdma.bin radeon/hawaii_smc.bin radeon/hawaii_k_smc.bin radeon/HAWAII_pfp.bin radeon/HAWAII_me.bin radeon/HAWAII_ce.bin radeon/HAWAII_mec.bin radeon/HAWAII_mc.bin radeon/HAWAII_mc2.bin radeon/HAWAII_rlc.bin radeon/HAWAII_sdma.bin radeon/HAWAII_smc.bin rt2870.bin
```

Select Exit,Exit

We need some stuff for snapd:

```
Device Drivers -> 
    Block devices -> [HIT ENTER]
      <*> RAM block device support [HIT SPACE 2x]
```

Select Exit

I have a RaLink Wifi dongle

```
Device Drivers -> 
    Network device support ---> [HIT ENTER]
      Wireless LAN ---> [HIT ENTER]
        <*> Ralink driver support ---- [HIT SPACE 2x][HIT ENTER]
          <*> Ralink rt27xx/rt28xx/rt30xx (USB) [HIT SPACE 2x]
          [*] rt2800usb - Incl..... 6x [HIT SPACE 1x on 4 rows]
```

Select Exit,Exit,Exit

```
Device Drivers --->
  Graphics support ---> [HIT ENTER]
    <*> ATI GPU [HIT SPACE]
    <*> AMD GPU [HIT SPACE 2x]
    [*] Enable amdgpu support for SI parts [HIT SPACE]
    [*] Enable amdgpu support for CIK parts [HIT SPACE]
    ACP (Audio CoProcessor) Configuration ---> [HIT ENTER]
      [*] Enable AMD Audio CoProcessor IP support [HIT SPACE]
```

Select Exit,Exit

```
Device Drivers --->
  Sound card support ---> [HIT ENTER]
    Advanced Linux Sound Architecture ---> [HIT ENTER]
      HD-Audio ---> [HIT ENTER]
        <*> HD Audio PCI [HIT SPACE 2x]
        <*> Build HDMI/DisplayPort HD-audio codec support [HIT SPACE 2x]
```

Select Exit,Exit,Exit,Exit

We need more some stuff for snapd:

```
File systems  -> [HIT ENTER]
  Miscellaneous filesystems -> [HIT ENTER]
    <*> SquashFS 4.0 - Squased file system support [HIT SPACE 2x]
    [*] Squashfs XATTR support [HIT SPACE]
    [*] Include support for ZLIB compressed file systems
    [*] Include support for LZ4 compressed file systems [HIT SPACE]
    [*] Include support for LZO compressed file systems [HIT SPACE]
    [*] Include support for XZ compressed file systems [HIT SPACE]
    [*] Include support for ZSTD compressed file systems [HIT SPACE]
```

Select Exit,Exit

We need CONFIG_SECCOMP and CONFIG_SECCOMP_FILTER for the `epiphany` browser

```
General architecture-dependent options  ---> [HIT ENTER]
  [*] Enable seccomp to safely execute untrusted bytecode -> [HIT SPACE]
```

Select Exit,Exit

Yes You wish to save your new configuration!

If you use GCC 13 and up, you need to patch the kernel code see [this](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e6a71160cc145e18ab45195abf89884112e02dfb) patch.

```bash
# Download the patch
$ wget -O gcc13.patch https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=e6a71160cc145e18ab45195abf89884112e02dfb
--2024-02-10 14:59:30--  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/patch/?id=e6a71160cc145e18ab45195abf89884112e02dfb
Resolving git.kernel.org (git.kernel.org)... 2604:1380:4601:e00::1, 145.40.68.75
Connecting to git.kernel.org (git.kernel.org)|2604:1380:4601:e00::1|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/plain]
Saving to: ‘gcc13.patch’

gcc13.patch                                         [ <=>                                                                                                 ]   1,39K  --.-KB/s    in 0s      

2024-02-10 14:59:30 (46,7 MB/s) - ‘gcc13.patch’ saved [1419]

# apply the patch
$ git apply gcc13.patch
```

Compile the kernel, config is now ready!
I added -j 16 (i have 16 thread on my machine!)

```bash
$ make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j 16
  SYNC    include/config/auto.conf
  WRAP    arch/riscv/include/generated/uapi/asm/errno.h
  WRAP    arch/riscv/include/generated/uapi/asm/fcntl.h
  WRAP    arch/riscv/include/generated/uapi/asm/ioctl.h
  WRAP    arch/riscv/include/generated/uapi/asm/ioctls.h
  WRAP    arch/riscv/include/generated/uapi/asm/ipcbuf.h
  WRAP    arch/riscv/include/generated/uapi/asm/mman.h
...
...
# takes a long time!!!
...
...

```

The kernel is Done! Now copy it to the boot partition on the SD-card!

### EFI-boot from Ubuntu (cd-boot-images-riscv64_10_all.deb)

The OpenSuse Tumbleweed image uses a kernel that does not yet have the PCIe patches of the StarFive VisionFive 2. More information about what is and is not main-stream in the kernel can be found here: site

The boot chain of OpenSuse Tumbleweed (OpenSBI - U-Boot - EFI) would not work with my kernel (6.1.31+). That's why I chose NOT to boot from SD card and use StarFive VisionFive 2's OpenSBI and U-Boot. Unfortunately, OpenSuse's efi boot did not work with this. That's why I use the efi-boot from Ubuntu (it worked with my 6.1.31+ kernel).

Download
[cd-boot-images-riscv64_10_all.deb](http://mirrors.kernel.org/ubuntu/pool/main/c/cd-boot-images-riscv64/cd-boot-images-riscv64_10_all.deb)

```bash
$ wget http://mirrors.kernel.org/ubuntu/pool/main/c/cd-boot-images-riscv64/cd-boot-images-riscv64_10_all.deb
# I am running Fedora and needed to install dpkg
$ sudo yum install dpkg
# unpack the file
$ dpkg-deb -x cd-boot-images-riscv64_10_all.deb cd-boot-images-riscv64_10_all
# on my computer i flashed the OpenSuse Tumbleweed to /dev/sdb We need to copy bootriscv64.efi to the EFI-partition
$ mkdir -p sd/efi
$ sudo mount /dev/sdb1 ~/OpenSuseTumbleweed/sd/efi
# We will now replace the efi boot from OpenSuse Tumbleweed with the Ubuntu version
$ sudo cp cd-boot-images-riscv64_10_all/usr/share/cd-boot-images-riscv64/tree/EFI/boot/bootriscv64.efi sd/efi/EFI/BOOT/bootriscv64.efi
# unmount again
$ sudo umount ~/OpenSuseTumbleweed/sd/efi
```

cp vmlinuz-6.1.31+ System and dtb + libs

```bash
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/dtb-6.1.31+ /run/media/opvolger/ROOT/boot/
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/vmlinuz-6.1.31+ /run/media/opvolger/ROOT/boot/
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/System.map-6.1.31+ /run/media/opvolger/ROOT/boot/
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/initrd.img-6.1.31+ /run/media/opvolger/ROOT/boot/
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/initrd/usr/lib/modules/6.1.31+/ /run/media/opvolger/ROOT/usr/lib/modules -R
```

edit grub2.cfg

```bash
sudo nano /run/media/opvolger/ROOT/boot/grub2/grub.cfg
```

edit /etc/fstab

```bash
sudo nano /run/media/opvolger/ROOT/etc/fstab
```

```bash
sudo nano /run/media/opvolger/ROOT/etc/grub.d/40_custom
```

```ini
menuentry 'openSUSE Tumbleweed, with Linux 6.1.31+' {
                load_video
                set gfxpayload=keep
                insmod gzio
                insmod part_gpt
                insmod ext2
                search --no-floppy --fs-uuid --set=root 1a05dd52-4f43-495e-8de1-e6372d24d24d
                echo    'Loading Linux 6.1.31+'
                linux   /boot/vmlinuz-6.1.31+ root=/dev/mmcblk1p3  ro  efi=debug earlycon console=ttyS0,115200n8
                echo    'Loading devicetree 6.1.31+'
                devicetree      /boot/dtb-6.1.31+
}
```

Login root/linux

Update Grub + install kde + codecs

```bash
useradd opvolger
passwd opvolger
grub2-mkconfig -o /boot/grub2/grub.cfg
zypper install -t pattern kde kde_plasma
zypper install opi neofetch chromium nano
opi codecs
```
