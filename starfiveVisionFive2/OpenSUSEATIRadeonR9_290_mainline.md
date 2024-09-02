# Steps 6.11-rc6 with external GPU

put all the downloads in one directory. In this example it is /home/opvolger/demo

## download OpenSuse VisionFive2 image

download it to /home/opvolger/demo

[url](https://en.opensuse.org/HCL:VisionFive2)

flash img to eMMC (I used balenaEtcher, but dd or an other tool will work)

## download the kernel 6.11 or newer

[kernel.org](https://kernel.org/)

For this example i use 6.11-rc6

```bash
$ cd /home/opvolger/demo
$ tar -xvzf linux-6.11-rc6.tar.gz
```

## get the linux-firmware blobs

We do not want history so `--depth 1`

```bash
$ cd /home/opvolger/demo
$ git clone --depth 1 git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
```

## set config file make linux kernel

```bash
$ cd linux-6.11-rc6
$ make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv menuconfig
```

Select the next kernel options

Device Drivers
└─>Generic Driver Options
    └─>Firmware loader
      () Build named firmware blobs into the kernel binary
      (../linux-firmware) Firmware blobs root directory

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
amdgpu/hawaii_k_smc.bin amdgpu/hawaii_smc.bin amdgpu/hawaii_uvd.bin amdgpu/hawaii_vce.bin amdgpu/hawaii_sdma.bin amdgpu/hawaii_sdma1.bin amdgpu/hawaii_pfp.bin amdgpu/hawaii_me.bin amdgpu/hawaii_ce.bin amdgpu/hawaii_rlc.bin amdgpu/hawaii_mec.bin amdgpu/hawaii_mc.bin
```

Device Drivers
└─>Block devices
      <*> RAM block device support

Linux Kernel Configuration
└─>Device Drivers
    └─>Input device support
        └─>Event interface

Linux Kernel Configuration
└─>Device Drivers
  └─>Graphics support
    └─>Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)
      <*> ATI Redeon
      <*> AMD GPU

Device Drivers
└─>Sound card support
  └─>Advanced Linux Sound Architecture
    └─>HD-Audio
        <*> HD Audio PCI
        <*> Build HDMI/DisplayPort HD-audio codec support

File systems  -> [HIT ENTER]
└─>Miscellaneous filesystems -> [HIT ENTER]
  └─> <*> SquashFS 4.0 - Squased file system support [HIT SPACE 2x]
      [*] Squashfs XATTR support [HIT SPACE]
      [*] Include support for ZLIB compressed file systems
      [*] Include support for LZ4 compressed file systems [HIT SPACE]
      [*] Include support for LZO compressed file systems [HIT SPACE]
      [*] Include support for XZ compressed file systems [HIT SPACE]
      [*] Include support for ZSTD compressed file systems [HIT SPACE]

After all the kernel options, I want to edit the .config file. I only want modules in the kernel, so I don't need a ramdrive (or can use one of older kernel).

I use vscode to edit my .config file. but feel free to use your own editor

```bash
$ code .config
```

Replace all `=m` for `=y`. So all modules will be within the kernel.

Now it is time to build the kernel

```bash
$ make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j 16
```

This can take a while

I mounted the eMMC, and the directory is `/run/media/opvolger/ROOT`.
So i copy my kernel and dtb to `/run/media/opvolger/ROOT`

```bash
$ sudo cp arch/riscv/boot/Image.gz /run/media/opvolger/ROOT/boot/linux6-11-rc6
$ sudo cp arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dtb /run/media/opvolger/ROOT/boot/dtb-6.11-rc6

$ cd /run/media/opvolger/ROOT
$ sudo nano boot.cmd
```

Now create the boot.cmd, so we don't have to give this long command in u-boot.

```boot.cmd
load mmc 0:3 ${kernel_addr_r} /boot/linux6-11-rc6
load mmc 0:3 ${fdt_addr_r} /boot/dtb-6.11-rc6
load mmc 0:3 ${ramdisk_addr_r} /boot/initrd
setenv bootargs 'root=/dev/mmcblk0p3 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'
booti $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r
```

create a boot.source:

```bash
$ sudo mkimage -C none -A riscv -T script -d boot.cmd boot.scr
```

We can now unplug the eMMC from the pc and click it to the VisionFive 2.

## Poweron VisionFive 2

Poweron you VisionFive 2 after you have make a serial connection.

```bash
$ screen -L /dev/ttyUSB0 115200
```

Boot the VisionFive 2 and `break` the boot process

Now we can load the boot source we created. We put it on partion 3, so we can load.

```ini
load mmc 0:3 ${scriptaddr} boot.scr; source ${scriptaddr}
```

The first boot will take some time (make root partition bigger etc.)

You can now log in with username root and password linux

```bash
riscv login: root
Password: 
Have a lot of fun...
```

Create an user

```bash
# create a user
$ useradd opvolger

# set password for user
$ passwd opvolger
New password: 
Retype new password: 
passwd: password updated successfully

# update repo's
$ zypper update

# install stuff
$ zypper install opi neofetch chromium nano libcurl-devel git SDL2-devel git openal-soft-devel libvpx-devel alsa-devel flac-devel
# install codecs (with errors, not all codes are allready on mainline for risc-v) option 2
$ opi codecs
# install KDE-desktop
$ zypper install -t pattern kde kde_plasma

$ reboot
```

