---
date: 2025-11-09
author: Bas Magré
---
# RPi 5 - Fedora with AMDGPU and Halflife 2

With an external GPU, you can build your own kernel and boot Fedora aarch64 Desktop.

## Fallback to llvmpipe on Radeon drivers

Al my ATI Radeon didn't work (I had screen output), but all did fallback to llvmpipe. So no hardware acceleration.

But the ATI Radeon R9 290 has Radeon and AMDGPU support in the kernel. If you don't build or disable Radeon in the kernel arguments, the AMDGPU drivers will work!

## Flash the Fedora KDE Desktop to SD-card

I downloaded the [Fedora-KDE-Desktop-Disk-43-1.6.aarch64.raw.xz](https://download.fedoraproject.org/pub/fedora/linux/releases/43/KDE/aarch64/images/Fedora-KDE-Desktop-Disk-43-1.6.aarch64.raw.xz) from the [website](https://fedoraproject.org/kde/download).

Flashed it to a SD-card with `Fedora Media Writer`. (Use options `Select .iso file`)

After the SD-card was flashed, i opened `gparted` and deleted the first 2 partitions. Created a new fat32 one and added the label `bootfs` and added the Flag `lba` to it.

Next I Resized the fedora partition to the end of the disk.

This will give something like this:

![img](FedoraATIRadeonR9_290/gparted.png)

## Build the kernel

Compiling will be done on an amd64 desktop. So we will cross-compile.

I have installed Fedora linux and had to install some stuff to be able to cross compile

```bash
$ sudo dnf group install "Development Tools"
$ sudo dnf install git gcc-plugin-devel libmpc-devel gcc-c++ gcc-c++-aarch64-linux-gnu ncurses-devel libmpc-devel nano gparted
```

I will work from the directory `/home/opvolger/demo`.

### Check out firmwares

First we need to clone the linux firmware

```bash
$ cd /home/opvolger/demo
$ git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
```

We need this, so we can add firmware directly in the kernel.

### Build kernel

Now we can clone the raspberry pi kernel.

```bash
# checkout kernel code
$ cd /home/opvolger/demo
$ git clone --branch rpi-6.12.y --depth 1 https://github.com/raspberrypi/linux.git raspberrypi-6.12-y
$ cd raspberrypi-6.12-y

# we want to cross-compile the kernel
$ export ARCH=arm64
$ export CROSS_COMPILE=aarch64-linux-gnu-

# make a default .config for the pi5 chip.
$ make bcm2712_defconfig
# we need to make (and add stuff) changes
$ make menuconfig
```

Select the next kernel options

```
Device Drivers
└─>Generic Driver Options
    └─>Firmware loader
      () Build named firmware blobs into the kernel binary
      (../linux-firmware) Firmware blobs root directory
```

In the `Build named firmware blobs into the kernel binary`, you will need to add your blobs of your AMD video card. In my case it was the hawaii (R2 290) blobs.
For example the 200-series you can find you "blob-names: on [wikipedia](https://en.wikipedia.org/wiki/Radeon_200_series)

If you do not have the correct blobs, you can see it with the commands following after booting:

```bash
$ journalctl -b | grep radeon
$ journalctl -b | grep amdgpu
$ journalctl -b | grep firmware
```

Than you can change it and rebuild the kernel.

Change Firmware blobs root directory to `../linux-firmware`

```ini
radeon/hawaii_pfp.bin radeon/hawaii_me.bin radeon/hawaii_ce.bin radeon/hawaii_mec.bin radeon/hawaii_mc.bin radeon/hawaii_rlc.bin radeon/hawaii_sdma.bin radeon/hawaii_smc.bin radeon/hawaii_k_smc.bin radeon/HAWAII_pfp.bin radeon/HAWAII_me.bin radeon/HAWAII_ce.bin radeon/HAWAII_mec.bin radeon/HAWAII_mc.bin radeon/HAWAII_mc2.bin radeon/HAWAII_rlc.bin radeon/HAWAII_sdma.bin radeon/HAWAII_smc.bin
```

Add AMDGPU/ATIGPU support

```
Linux Kernel Configuration
└─>Device Drivers
  └─>Graphics support
    └─>Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)
      <*> ATI Redeon
      <*> AMD GPU
      [*]   Enable amdgpu support for SI parts (NEW)
      [*]   Enable amdgpu support for CIK parts (NEW)
```

Change `Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)` from `M` (Modules) to `*` (with in the kernel) (with the space bar).

I disabled all `DRM support ....` that where selected. and selected `ATI Redeon`, `AMD GPU` and enabled SI en CIK support.

Now we want sound on the HDMI monitor, so we add support for that.

```
Device Drivers
└─>Sound card support
  └─>Advanced Linux Sound Architecture
    └─>HD-Audio
        <*> HD Audio PCI
        <*> Build HDMI/DisplayPort HD-audio codec support
```

Change `Advanced Linux Sound Architecture` from `M` (Modules) to `*` (with in the kernel) (with the space bar).

Select `*` for `HD Audio PCI` and now you can select `*` by `Build HDMI/DisplayPort HD-audio codec support`.

Now add and change the file systems we will support

```
File systems
└─><*> Btrfs filesystem support
   [*] Btrfs POSIX Access Control Lists
   [*] Btrfs debugging support
   [*] Btrfs assert support
   [*] Btrfs with the ref verify tool compiled in
```

I changed all the `M` (Modules) to `*` (with in the kernel) (if possible) (with the space bar) and added all the Btrfs options. No idea if i need them all....

We now need to set the page size from 16 to 4 in the kernel

```
Kernel Features
└─>Page size (16KB)
```

Now you need to select `4KB` (space bar).

We can now Exit and save the changes! 

You can disable more options (Like `Amateur Radio support`, `Industrial I/O support`, `USB sound devices` ,`ALSA for SoC audio support`, `Broadcom VideoCore support`, `Touchscreens`, `Media USB Adapters`, `Radio Adapters` and `Support for small TFT LCD display modules`), but this is optional. The kernel will compile faster.

```bash
# now we build the kernel. i have 16 cores, so i will build with -j 16
$ make -j 16
```

## Copy to SD-card

I mounted the SD-cart to `/run/media/opvolger/BOOTFS/` and `/run/media/opvolger/fedora/`. with dolphin (auto mount).

Now create the file `/run/media/opvolger/BOOTFS/config.txt` with nano or something else.

Here you can set some pi-setting for boot time

```ini
# no idea if they are all needed

# Automatically load overlays for detected DSI displays
display_auto_detect=1

# Automatically load initramfs files, if found (we don't)
auto_initramfs=1

# Run in 64-bit mode
arm_64bit=1

# Disable compensation for displays with overscan
disable_overscan=1

# Run as fast as firmware / board allows
arm_boost=1
# The name of the kernel
kernel=Image
# enable pci-express
dtparam=pciex1

# enable serial (so you can see what is going wrong over serial)
enable_serial=1
enable_uart=1
```

Now create the file `/run/media/opvolger/BOOTFS/cmdline.txt` with nano or something else.

This will add kernel argument on boot time.
We enable serial output, set the correct settings for the root-fs of fedora, disable radeon drivers and enable amdgpu drivers.

```ini
console=serial0,115200 console=tty1 root=PARTUUID=ead7b37c-03 ro rootflags=subvol=root rhgb rootflags=subvol=root fsck.repair=yes rootwait plymouth.ignore-serial-consoles radeon.si_support=0 radeon.cik_support=0 amdgpu.si_support=1 amdgpu.cik_support=1
```

```bash
$ cd /home/opvolger/demo/raspberrypi-6.12-y
# copy kernel and device tree to boot partition SD-card
$ cp arch/arm64/boot/Image /run/media/opvolger/BOOTFS/
$ cp arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b.dtb /run/media/opvolger/BOOTFS/

# now make the modules install them on the SD-card root partition (fedora)
sudo ARCH=arm64 make modules_install INSTALL_MOD_PATH=/run/media/opvolger/fedora/
```