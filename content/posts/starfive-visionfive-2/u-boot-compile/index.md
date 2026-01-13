---
date: 2025-03-30
author: Bas Magré
categories: ["RISC-V"]
tags: ["starfive-visionfive-2", "RISC-V"]
title: StarFive VisionFive 2 - U-boot & Opensbi
draft: true
---
## Intro

Links:

- https://stijn.tintel.eu/blog/2024/05/19/compiling-uboot-bpi-f3/
- https://doc-en.rvspace.org/VisionFive2/SWTRM/VisionFive2_SW_TRM/compiling_the_u-boot%20-%20vf2.html
- https://docs.banana-pi.org/en/BPI-F3/GettingStarted_BPI-F3#_install_image_to_emmc_2
- https://github.com/xypron/visionfive2-u-boot-build/blob/main/README.rst
- [u-boot/doc/board/starfive/visionfive2.rst](https://github.com/u-boot/u-boot/blob/master/doc/board/starfive/visionfive2.rst)

U-Boot

```bash
git clone https://github.com/u-boot/u-boot.git
cd u-boot
CROSS_COMPILE=riscv64-linux-gnu-
export CROSS_COMPILE
make distclean
make starfive_visionfive2_defconfig
make all
# uboot-2022.10/arch/riscv/dts/m1-x_milkv-jupiter.dtb uboot-2022.10/spl/u-boot-spl.bin and uboot-2022.10/u-boot.bin
# uboot-2022.10/bootinfo_emmc.bin  uboot-2022.10/bootinfo_sd.bin  uboot-2022.10/bootinfo_spinand.bin  uboot-2022.10/bootinfo_spinor.bin
```

OpenSBI

```bash
git clone https://github.com/riscv-software-src/opensbi.git
cd opensbi
U_BOOT_DIR=../u-boot
export U_BOOT_DIR
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- PLATFORM=generic FW_PAYLOAD_PATH=../u-boot/u-boot.bin FW_FDT_PATH=../u-boot/arch/riscv/dts/jh7110-starfive-visionfive-2.dtb FW_TEXT_START=0x40000000
```

