---
date: 2026-10-20
author: Bas Magré
categories: ["RISC-V"]
tags: ["milk-v-jupiter", "RISC-V", "AMDGPU", "kernel", "linux", "Debian"]
title: "Milk-V Jupiter - Debian Trixie with external GPU AMD Radeon R9 290"
---
## Intro

More than 2 years ago with a lot of searching/patching/searching/patching etc, I had finally a working kernel with my `AMD Radeon R9 290`. I had some artifacts, but after multiple nights patching a was able to play the game `Factorio` on my board (with box64).

But i didn't save my changes/patches and wiped the directory, i still had some in my [git repo](https://github.com/Opvolger/spacemit-k1-linux-6.6) and tried to get it working again.... But give up.

Now it is 2 years later, and the mainline Linux had a lot of the board and PCI-e controller, so I did give it a try. To bad, AMDGPU was not working. So I ask `claude` what is missing and how it can be fixed. I don’t expect a real answer. But he gave my one. Here it started!

## Setup

I have a smart-plug and home-assistent, so with a token claude can power-on-off the device.

I have a USB to serial, so it can send commands to U-Boot

![total chaos! with cables and a computer](setup.jpg "total chaos, yes I can work in this")

I started a tftp server with docker, so it can download the kernel that is made after compiling.

I copied the root partition of my StarFive VisionFive 2 to an eMMC

I compiled U-Boot with my [ansible script](https://github.com/Opvolger/ansible-riscv-sd-card-creater/blob/master/milkv-jupiter-compile-latest.yaml). commented out some stuff, so only the u-boot was created on my SD card. You can also use the latest vendor U-Boot.

used the kernel claude builded for my and booted. See all the steppes in [my markdown](https://github.com/Opvolger/linux-kernel-jupiter-1/blob/master/milk-v-testing.md)

```bash
setenv serverip 192.168.2.34
setenv fdt_addr_r 0x31000000          # fdt_addr_r does not exist in the env
tftpboot ${fdt_addr_r} ${serverip}:arch/riscv/boot/dts/spacemit/k1-milkv-jupiter.dtb
tftpboot ${kernel_addr_r} ${serverip}:arch/riscv/boot/Image.gz   # ~20 MiB/s
setenv bootargs 'root=/dev/mmcblk0p1 rw swiotlb=131072 console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'
booti ${kernel_addr_r} - ${fdt_addr_r}
```

and failed! So I wrote down how `claude` can controle all of this, and watched some TV.

When I was back, there was a working AMDGPU! I had a console! Login and installed KDE Plasma! reboot and login. Artifacts!!!

I have a HDMI-capture card and let clause use it to capture the artifacts. So now I had to watch some Youtube on my computer and login to see if the artifacts where gone.

It worked, I know had no artifacts. So now a gave him the task to use same config as a Debian kernel. I did build and now that can boot to. It was only instable :(

After a night of try and error, claude found the problem: `performance-governor` was the solution, the `schedutil cpufreq governor` was not stable. So now full power!

![a kernel with the same config settings as the debian kernel*](cover.png "a kernel with the same config settings as the debian kernel*")

## Kernel with PCI-e support

So I now have a kernel with AMDGPU support (for my GPU, maybe more). In the future I will test my other (AMD)GPU's.

What isn't working is my nvme disk :(

Claude also can create a pipeline in 5 minutes, so here are the kernels: [release v1.0.0](https://github.com/Opvolger/linux-kernel-jupiter-1/releases/tag/v1.0.0)

## GitHub Repo

To not lose all the patches this time, i created a repo (with claude's help) [linux-kernel-jupiter-k1](https://github.com/Opvolger/linux-kernel-jupiter-1). 

Here you can see all the commands and try-and-errors runs.
