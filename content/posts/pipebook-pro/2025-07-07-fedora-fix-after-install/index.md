---
date: 2025-07-07
author: Bas Magré
categories: ["ARM"]
tags: ["pinebook-pro", "ARM"]
title: "Pinebook Pro - Fedora setup"
---
## Fedora on Pinebook Pro

Some stuff I did after installing Fedora on my Pinebook Pro.

howto from [nullr0ute](https://nullr0ute.com/2021/05/fedora-on-the-pinebook-pro/)

```bash
sudo dnf install arm-image-installer uboot-images-armv8
sudo spi-flashing-disk --target=pinebook-pro-rk3399 --media=/dev/sdb
```

Now remove the mSD card from your host and put it into the Pinebook Pro. Press the power button, from experience you likely need to press and momentarily hold and in a second or two the display will light up with text output. Interrupt the boot by pressing space. Next up we write out the flash:

```bash
Hit any key to stop autoboot:  0 
=> ls mmc 1:1
   182272   idbloader.img
   364544   idbloader-spi.img
  1079808   u-boot.itb
  1997312   u-boot-rockchip.bin
  1997312   u-boot-rockchip-spi.bin

5 file(s), 0 dir(s)

=> sf probe
SF: Detected gd25q128 with page size 256 Bytes, erase size 4 KiB, total 16 MiB

=> load mmc 1:1 ${fdt_addr_r} u-boot-rockchip-spi.bin
1997312 bytes read in 39 ms (8.2 MiB/s)

=> sf update ${fdt_addr_r} 0 ${filesize}
device 0 offset 0x0, size 0x52000
61440 bytes written, 274432 bytes skipped in 0.803s, speed 427777 B/s
```

```bash
sudo arm-image-installer --media=/dev/sdb --resizefs --target=none --image=/home/opvolger/Downloads/Fedora-KDE-Desktop-Disk-42-1.1.aarch64.raw.xz
```

## fix install wifi firmware

```bash
wget https://fedora.roving-it.com/brcm-pinebookpro-0.0-1.noarch.rpm
sudo yum install brcm-pinebookpro-0.0-1.noarch.rpm
```

## fix BlueTooth firmware

```bash
sudo dnf copr enable jwillikers/pinebook-pro
sudo yum install ap6256-firmware
```

## Fix sound for Pinebook Pro

```bash
wget https://gitlab.manjaro.org/manjaro-arm/packages/community/pinebookpro-post-install/-/raw/master/asound.state
alsactl --file asound.state restore
```
