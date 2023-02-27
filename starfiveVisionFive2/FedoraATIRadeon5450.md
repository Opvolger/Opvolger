# Fedora with ATI Radeon 5450, running Quake2

I wanted to compile and test a few programs on a RISC-V. I only ran into the problem of minimal support of the onboard GPU and custom build Debian from the StarFive Team.

So below you can see my "solution".

## Hardware

- StarFive VisionFive 2
- BEYIMEI PCIE Riser-Ver010X GPU Riser, 1X tot 16X (4PIN/6PIN/MOLEX) PCIE-verlengkabel, M.2 naar PCI-E Riser Card Bitcoin Litecoin Ethereum.
This is about 11 EURO on amazon, so no big deal... [amazon-link](https://www.amazon.nl/dp/B0BF4PH83Y?ref_=pe_28126711_487767311_302_E_DDE_dt_1)
- ATI Radeon 5450, Bought on a Dutch second-hand website, for 10 EURO.
- An ATX power supply (was still lying around in the house)
- For debugging a USB to TTL (was still lying around in the house), is about 5 EURO.

![img](FedoraATIRadeon5450/setup.png)

My first setup was with a too light power supply for the video card, you can still see it in the background (no longer connected). I always used this to connect a hard disk externally.
If this also happens to you, you will see that the video card is recognized by the kernel, but that you see a lot of errors. `[  817.910347] pcie_plda 2c000000.pcie: AXI fetch error`

## Debugging

The longest I spent trying to get a working kernel that had the ATI video card and audio over HDMI working.

I have spent a lot of hours to get `Kernel driver in use: radeon` and `Kernel driver in use: snd_hda_intel` in my screen :)

```bash
$ lspci -k
0000:00:00.0 PCI bridge: PLDA XpressRich-AXI Ref Design (rev 02)
lspci: Unable to load libkmod resources: error -2
0000:01:00.0 USB controller: VIA Technologies, Inc. VL805/806 xHCI USB 3.0 Controller (rev 01)
        Subsystem: VIA Technologies, Inc. VL805/806 xHCI USB 3.0 Controller
        Kernel driver in use: xhci_hcd
0001:00:00.0 PCI bridge: PLDA XpressRich-AXI Ref Design (rev 02)
0001:01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cedar [Radeon HD 5000/6000/7350/8350 Series]
        Subsystem: ASUSTeK Computer Inc. Device 0366
        Kernel driver in use: radeon
0001:01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Cedar HDMI Audio [Radeon HD 5400/6300/7300 Series]
        Subsystem: ASUSTeK Computer Inc. Device aa68
        Kernel driver in use: snd_hda_intel
# or for Audio
$ inxi -aA
Audio:
  Device-1: AMD Cedar HDMI Audio [Radeon HD 5400/6300/7300 Series] vendor: ASUSTeK
    driver: snd_hda_intel v: kernel bus-ID: 0001:01:00.1 chip-ID: 1002:aa68 class-ID: 0403
  Device-2: jh7110-pwmdac driver: starfive_pwmdac bus-ID: N/A chip-ID: starfive:100b0000
    class-ID: pwmdac
  Device-3: jh7110-hdmi driver: innohdmi_starfive bus-ID: N/A chip-ID: starfive:29590000
    class-ID: hdmi
  Device-4: simple-audio-card driver: N/A bus-ID: N/A chip-ID: simple-audio-card:soc
    class-ID: snd-card0
  Device-5: simple-audio-card driver: asoc_simple_card bus-ID: N/A
    chip-ID: simple-audio-card:soc class-ID: snd-card1
  Device-6: simple-audio-card driver: N/A bus-ID: N/A chip-ID: simple-audio-card:soc
    class-ID: snd-card2
  Device-7: simple-audio-card driver: asoc_simple_card bus-ID: N/A
    chip-ID: simple-audio-card:soc class-ID: snd-card3
  Device-8: simple-audio-card driver: N/A bus-ID: N/A chip-ID: simple-audio-card:soc
    class-ID: snd-card4
  Device-9: simple-audio-card driver: N/A bus-ID: N/A chip-ID: simple-audio-card:soc
    class-ID: snd-card5
  Device-10: simple-audio-card driver: N/A bus-ID: N/A chip-ID: simple-audio-card:soc
    class-ID: snd-card6
  Sound API: ALSA v: k5.15.0-dirty running: yes
  Sound Server-1: PulseAudio v: 16.1 running: no
  Sound Server-2: PipeWire v: 0.3.59 running: yes
```

The longest it take to findout I had to add firmwares to the kernel. I got the error's with:

```bash
$ journalctl | grep radeon
```

After this it was only getting the Fedora root partition on my SD-card. The "Frankenstein" Debian-build-69 is fun if you want to see the board working with the onboard GPU, but those drivers are really unfinished and X11 was as fast as I could see completely custom build for this GPU. (No OpenGL, OpenGL ES 3 only).

## DIY Step by step

### Create SD-card

My machine has a SD-card reader on `/dev/mmcblk0` this can of course be difference on your machine.

Download the Debian-Image-69 from StarFive VisionFive 2 Support page (I used the torrent in the google drive).
Download the Fedora RISC-V image `Fedora-Developer-37-20221130.n.0-sda.raw.xz` [link](https://fedoraproject.org/wiki/Architectures/RISC-V/Installing#Download_manually) and extract it to Fedora-Developer-37-20221130.n.0-sda.raw

```bash
# create a loop device of image
$ sudo losetup -f -P ~/Downloads/Image-69/starfive-jh7110-VF2_515_v2.5.0-69.img
$ sudo losetup -f -P ~/Downloads/Fedora-Developer-37-20221130.n.0-nvme.raw.img
# find your loop device
$ losetup -l
NAME        SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE                                                               DIO LOG-SEC
/dev/loop1          0      0         1  1 /var/lib/snapd/snaps/gnome-3-28-1804_161.snap                             0     512
/dev/loop8          0      0         1  1 /var/lib/snapd/snaps/gtk-common-themes_1534.snap                          0     512
/dev/loop15         0      0         0  0 /home/opvolger/Downloads/Fedora-Developer-37-20221130.n.0-nvme.raw.img    0     512
/dev/loop6          0      0         1  1 /var/lib/snapd/snaps/core18_2679.snap                                     0     512
/dev/loop13         0      0         1  1 /var/lib/snapd/snaps/wine-platform-runtime_335.snap                       0     512
/dev/loop4          0      0         1  1 /var/lib/snapd/snaps/bare_5.snap                                          0     512
/dev/loop11         0      0         1  1 /var/lib/snapd/snaps/wine-platform-5-stable_18.snap                       0     512
/dev/loop2          0      0         1  1 /var/lib/snapd/snaps/core18_2697.snap                                     0     512
/dev/loop0          0      0         1  1 /var/lib/snapd/snaps/gtk-common-themes_1535.snap                          0     512
/dev/loop9          0      0         1  1 /var/lib/snapd/snaps/snapd_18357.snap                                     0     512
/dev/loop7          0      0         1  1 /var/lib/snapd/snaps/snapd_17950.snap                                     0     512
/dev/loop14         0      0         0  0 /home/opvolger/Downloads/Image-69/starfive-jh7110-VF2_515_v2.5.0-69.img   0     512
/dev/loop5          0      0         1  1 /var/lib/snapd/snaps/cncra_63.snap                                        0     512
/dev/loop12         0      0         1  1 /var/lib/snapd/snaps/wine-platform-runtime_334.snap                       0     512
/dev/loop3          0      0         1  1 /var/lib/snapd/snaps/cncra_76.snap                                        0     512
/dev/loop10         0      0         1  1 /var/lib/snapd/snaps/wine-platform-5-stable_16.snap                       0     512
# in my case it is loop14 and loop15

# insert your SD-card and delete all partitions (I had 3)
$ sudo fdisk /dev/mmcblk0
[sudo] password for opvolger: 

Welcome to fdisk (util-linux 2.38.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): d
Partition number (1-3, default 3): 1

Partition 1 has been deleted.

Command (m for help): d
Partition number (2,3, default 3): 2

Partition 2 has been deleted.

Command (m for help): d
Selected partition 3
Partition 3 has been deleted.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

# add all 3 partitions of the Debain-Image-69 to the SD-card
$ sudo dd if=/dev/loop14 of=/dev/mmcblk0 status=progress
# the Fedora img has only 2 partitions, 2nd is the root partition. We need to (re)place the root partition of the Debain-Image-69 (3th partition now on the SD-card)
$ 
```

### Building the Linux Kernel

I built this on my own machine, otherwise it will take a very long time. so cross compile!
Everything is neatly explained if you click through to the "linux" repo of all (yet) custom code for the SBC. [link](https://github.com/starfive-tech/VisionFive2)

```bash
$ mkdir ~/visionfive2
$ cd visionfive2
$ git clone https://github.com/starfive-tech/linux.git
Cloning into 'linux'...
remote: Enumerating objects: 9350943, done.
remote: Counting objects: 100% (1061/1061), done.
remote: Compressing objects: 100% (425/425), done.
Receiving objects:   1% (160706/9350943), 77.16 MiB | 14.26 MiB/s
Done
$ cd linux
$ git checkout JH7110_VisionFive2_devel
Updating files: 100% (20490/20490), done.
Switched to branch 'JH7110_VisionFive2_devel'
Your branch is up to date with 'origin/JH7110_VisionFive2_devel'.
```

Now we have the modified kernel 5.15 that workes with VisionFive 2.
We can use the instructions of the other branch [link](https://github.com/starfive-tech/linux/tree/JH7110_VisionFive2_upstream). Here and there I deviated a little from it

I am running Manjaro on got an error. I fixxed it in `arch/riscv/Makefile` on line +/- 56 (find this online).

```Makefile
...
...
...
# ISA string setting
riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c

# Newer binutils versions default to ISA spec version 20191213 which moves some
# instructions from the I extension to the Zicsr and Zifencei extensions.
toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei

KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
KBUILD_AFLAGS += -march=$(riscv-march-y)
...
...
...
```

```bash
# create the .config with all you need for only the StarFive VisionFive 2
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- starfive_visionfive2_defconfig

# open the menu
make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv menuconfig
```

Now we have to add the ATI video-card and HDMI-audio.

Device Drivers ---> [HIT ENTER]
  Generic Driver Options ---> [HIT ENTER]
    Firmware loader ---> [HIT ENTER]
      () Build named firmware blobs into the kernel binary [HIT ENTER]
enter this in the line:

```ini
radeon/CYPRESS_uvd.bin radeon/CEDAR_smc.bin radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin radeon/CEDAR_rlc.bin
```

Select Exit,Exit,Exit

Device Drivers --->
  Graphics support ---> [HIT ENTER]
    <*> ATI Radeon [hit space twice]
Select Exit

Device Drivers --->
  Sound card support ---> [HIT ENTER]
    Advanced Linux Sound Architecture ---> [HIT ENTER]
      HD-Audio --->
        Build HDMI/DisplayPort HD-audio codec support [hit space twice]
Select Exit,Exit,Exit,Exit

Now save your changes! as .config and Exit

We can compile the kernel, I have 8 cores in my machine... so I added -j 8

```bash
$ make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j 8
  SYNC    include/config/auto.conf
  CALL    scripts/atomic/check-atomics.sh
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      sound/core/sound.o
  CC      sound/core/init.o
  CC      sound/core/control.o
  UPD     kernel/config_data
  AR      sound/pci/ac97/built-in.a
  CC      sound/pci/hda/hda_bind.o
  CC      sound/pci/hda/hda_codec.o
  GZIP    kernel/config_data.gz
  CC      kernel/configs.o
  CC      drivers/tty/vt/keyboard.o
  AR      kernel/built-in.a
  CC      sound/core/vmaster.o
  CC      sound/usb/card.o
  CC      sound/pci/hda/hda_jack.o
  CC      sound/core/ctljack.o
...
...
...
  LD      vmlinux
  SORTTAB vmlinux
  SYSMAP  System.map
  MODPOST modules-only.symvers
  OBJCOPY arch/riscv/boot/Image
  GZIP    arch/riscv/boot/Image.gz
  GEN     Module.symvers
  LD [M]  drivers/net/wireless/eswin/wlan_ecr6600u_usb.ko
  Kernel: arch/riscv/boot/Image.gz is ready
$ mkdir -p ~/visionfive2/kernel
$ make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv INSTALL_PATH=~/visionfive2/kernel zinstall -j 8
sh ./arch/riscv/boot/install.sh 5.15.0-dirty \
arch/riscv/boot/Image.gz System.map "/home/opvolger/visionfive2/kernel"
Installing compressed kernel
```

The kernel is Done! Now copy it to the boot partition!
