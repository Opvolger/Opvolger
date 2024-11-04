# U-boot & Opensbi

# https://stijn.tintel.eu/blog/2024/05/19/compiling-uboot-bpi-f3/
# https://doc-en.rvspace.org/VisionFive2/SWTRM/VisionFive2_SW_TRM/compiling_the_u-boot%20-%20vf2.html
# https://docs.banana-pi.org/en/BPI-F3/GettingStarted_BPI-F3#_install_image_to_emmc_2

Kernel 6.6+ needs firmware
- https://gitee.com/bianbu-linux/buildroot-ext/blob/bl-v1.0.y/board/spacemit/k1/target_overlay/lib/firmware/esos.elf
- https://dev.to/luzero/bringing-up-bpi-f3-part-3-101h


```boot.cmd
usb start
ramdisk_addr_r=0x21000000
fdt_addr_r=0x31000000
load usb 0:1 ${kernel_addr_r} /6.6/Image.gz
load usb 0:1 ${fdt_addr_r} /6.6/m1-x_milkv-jupiter.dtb
load mmc 0:5 ${ramdisk_addr_r} /initrd.img-6.6.36
setenv bootargs 'console=ttyS0,115200 root=/dev/mmcblk0p7 rootfstype=ext4 rootwait rw earlycon clk_ignore_unused loglevel=7 radeon.pcie_gen2=0 swiotlb=131072 stmmaceth=chain_mode:1 selinux=0'
booti $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r
```

U-Boot

```bash
cd uboot-2022.10
CROSS_COMPILE=riscv64-linux-gnu-
export CROSS_COMPILE
make distclean
make k1_defconfig
make all
# uboot-2022.10/arch/riscv/dts/m1-x_milkv-jupiter.dtb uboot-2022.10/spl/u-boot-spl.bin and uboot-2022.10/u-boot.bin
# uboot-2022.10/bootinfo_emmc.bin  uboot-2022.10/bootinfo_sd.bin  uboot-2022.10/bootinfo_spinand.bin  uboot-2022.10/bootinfo_spinor.bin
```

OpenSBI

```bash
cd opensbi
CROSS_COMPILE=riscv64-linux-gnu-
export CROSS_COMPILE
make PLATFORM=generic menuconfig
```

In menuconfig, under Platform Options, disable Spacemit K1pro support, enable Spacemit K1x support and Spacemit K1x board evb, save and run make again. When the build is done, export the full path to build/platform/generic/firmware/fw_dynamic.bin in the OpenSBI dir as OPENSBI and change to the U-Boot source directory. To build, U-Boot, run the following commands:

```bash
make PLATFORM=generic
make k1_defconfig
make
# opensbi/build/platform/generic/firmware/fw_dynamic.bin
```

To SSD

milkv-jupiter-bianbu-23.10-minimal-k1-v1.0.15-release-2024-0907.img.zip -> sd
delete partition 5 and 6.

replace opensbi and u-boot

```bash
sudo dd if=uboot-2022.10/FSBL.bin of=/dev/sdb1
sudo dd if=opensbi/build/platform/generic/firmware/fw_dynamic.bin of=/dev/sdb3
sudo dd if=uboot-2022.10/u-boot.itb of=/dev/sdb4
```

My ATI Radeon 5000 GPU won't work on the Milk-V Jupiter.

I have a working openSUSE Tumbleweed 20240825 on my StarFive VisionFive 2 and an ATI Redeon 5000. (Custom kernel).

So I took the Milk-V Jupiter Ubuntu image and added a copy of my openSUSE Tumbleweed root partition. Made my own kernel from your repo and it works (almost).

I have text output from the ATI Radeon 5000 GPU, but when I want to go to X, it fails.

Ignore the hostname of the machine, that is due to the partition copy.

This is my u-boot

```bash
setenv dtb_addr 0x16000000
setenv ramdisk_addr 0x16100000
load nvme 0:7 ${kernel_addr_r} /home/opvolger/Image.gz
load nvme 0:5 ${dtb_addr} /spacemit/6.1.15/k1-x_milkv-jupiter.dtb
load nvme 0:5 ${ramdisk_addr} /initrd.img-6.1.15
setenv bootargs 'root=/dev/nvme0n1p7 rw radeon.modeset=1 radeon.dpm=0 radeon.pcie_gen2=0 swiotlb=131072 console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'
booti $kernel_addr_r $ramdisk_addr:$filesize $dtb_addr
```

```bash
sysboot nvme 0:5 any ${scriptaddr} /extlinux/extlinux.conf
sysboot nvme 0:5 any ${scriptaddr} /extlinux/extlinux2.conf
sysboot nvme 0:5 any ${scriptaddr} /extlinux/extlinux3.conf
```

This is not working, only sd card is readable.

## Kernel


After booting, I have text and a "working" driver

```bash
starfive:~ # lspci -k
0001:00:00.0 PCI bridge: ASR Microelectronics Device 3003 (rev 01)
        Kernel driver in use: pcieport
lspci: Unable to load libkmod resources: error -2
0001:01:00.0 Non-Volatile memory controller: Silicon Motion, Inc. SM2263EN/SM2263XT (DRAM-less) NVMe SSD Controllers (rev 03)
        Subsystem: Silicon Motion, Inc. SM2263EN/SM2263XT (DRAM-less) NVMe SSD Controllers
        Kernel driver in use: nvme
0002:00:00.0 PCI bridge: ASR Microelectronics Device 3003 (rev 01)
        Kernel driver in use: pcieport
0002:01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cedar [Radeon HD 5000/6000/7350/8350 Series]
        Subsystem: ASUSTeK Computer Inc. Device 0366
        Kernel driver in use: radeon
0002:01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Cedar HDMI Audio [Radeon HD 5400/6300/7300 Series]
        Subsystem: ASUSTeK Computer Inc. Device aa68
        Kernel driver in use: snd_hda_intel
```

Error in dmesg:
```bash
starfive:~ # dmesg | grep radeon
[    0.000000] Kernel command line: root=/dev/nvme0n1p7 rw amdgpu.pcie_gen2=0 radeon.pcie_gen2=0 swiotlb=131072 console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0
[    2.253291] [drm] radeon kernel modesetting enabled.
[    2.266646] radeon 0002:01:00.0: enabling device (0000 -> 0003)
[    2.410109] radeon 0002:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[    2.419148] radeon 0002:01:00.0: GTT: 1024M 0x0000000040000000 - 0x000000007FFFFFFF
[    2.435820] [drm] radeon: 1024M of VRAM memory ready
[    2.440873] [drm] radeon: 1024M of GTT memory ready.
[    2.466048] [drm] radeon: dpm initialized
[    2.562715] radeon 0002:01:00.0: WB enabled
[    2.566995] radeon 0002:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00
[    2.575157] radeon 0002:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c
[    2.594296] radeon 0002:01:00.0: fence driver on ring 5 use gpu addr 0x000000000005c418
[    2.603199] radeon 0002:01:00.0: radeon: MSI limited to 32-bit
[    2.609361] radeon 0002:01:00.0: radeon: using MSI.
[    2.614400] [drm] radeon: irq initialized.
[    2.872558] [drm:r600_ring_test] *ERROR* radeon: ring 0 test failed (scratch(0x8504)=0xCAFEDEAD)
[    2.881527] radeon 0002:01:00.0: disabling GPU acceleration
[    3.362376] radeon 0002:01:00.0: [drm] fb0: radeondrmfb frame buffer device
[    3.370356] [drm] Initialized radeon 2.50.0 20080528 for 0002:01:00.0 on minor 0
[   27.044595] [drm:radeon_bo_move] *ERROR* failed to bind 1 pages at 0x00000000
[   27.051938] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (4096, 2, 4096, -22)
[   27.061430] [drm:radeon_bo_move] *ERROR* failed to bind 1 pages at 0x00000000
[   27.068777] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (4096, 2, 4096, -22)
[   27.706885] [drm:radeon_bo_move] *ERROR* failed to bind 6 pages at 0x00000000
[   27.714312] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (24576, 2, 4096, -22)
[   27.723996] [drm:radeon_bo_move] *ERROR* failed to bind 6 pages at 0x00000000
[   27.731384] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (24576, 2, 4096, -22)
[   27.748715] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.756762] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
[   27.767290] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.775291] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
[   27.787727] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.795795] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
[   27.806444] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.814471] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
... etc etc etc
```

But if it boots into X Display Manager and used the DRM-driver

```bash

[  OK  ] Reached target Network.
         Starting NTP client/server...
         Starting CUPS Scheduler...
         Starting OpenSSH Daemon...
         Starting Permit User Sessions...
[  OK  ] Finished Permit User Sessions.
         Starting X Display Manager...
         Starting Hold until boot process finishes up...
[   22.723121] [drm:radeon_bo_move] *ERROR* failed to bind 1 pages at 0x00000000
[   22.730482] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (4096, 2, 4096, -22)
[   22.739998] [drm:radeon_bo_move] *ERROR* failed to bind 1 pages at 0x00000000
[   22.747279] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (4096, 2, 4096, -22)
[   23.368008] [drm:radeon_bo_move] *ERROR* failed to bind 6 pages at 0x00000000
[   23.375368] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (24576, 2, 4096, -22)
[   23.385074] [drm:radeon_bo_move] *ERROR* failed to bind 6 pages at 0x00000000
[   23.392446] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (24576, 2, 4096, -22)
[   23.410720] radeon 0002:01:00.0: swiotlb buffer is full (sz: 1048576 bytes), total 65536 (slots), used 9 (slots)
[   23.421155] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -14)
[   23.431899] radeon 0002:01:00.0: swiotlb buffer is full (sz: 1048576 bytes), total 65536 (slots), used 9 (slots)
[   23.442677] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -14)
[   23.455180] radeon 0002:01:00.0: swiotlb buffer is full (sz: 1048576 bytes), total 65536 (slots), used 9 (slots)
[   23.465573] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -14)
[   23.476297] radeon 0002:01:00.0: swiotlb buffer is full (sz: 1048576 bytes), total 65536 (slots), used 9 (slots)
[   23.486696] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -14)
[   23.497436] radeon 0002:01:00.0: swiotlb buffer is full (sz: 1048576 bytes), total 65536 (slots), used 9 (slots)
[   23.507921] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -14)
[   23.518674] radeon 0002:01:00.0: swiotlb buffer is full (sz: 1048576 bytes), total 65536 (slots), used 9 (slots)
[   23.529086] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -14)
[   25.601817] k1x_emac cac81000.ethernet end1: Link is Up - 1Gbps/Full - flow control off
[   25.601877] IPv6: ADDRCONF(NETDEV_CHANGE): end1: link becomes read
```

I have "fixxed" the "swiotlb buffer is full" with this patch: (Even more memory when I use this soc, this was already an adjustment for the K1, but apparently I'm running out of memory there too. + double the kernel argument)

```path
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index eac643ef4..cfa9c9552 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -23,7 +23,7 @@ struct scatterlist;
  * The complexity of {map,unmap}_single is linearly dependent on this value.
  */
 #if defined(CONFIG_SOC_SPACEMIT_K1X)
-#define IO_TLB_SEGSIZE	256
+#define IO_TLB_SEGSIZE	512
 #else
 #define IO_TLB_SEGSIZE	128
 #endif
```

Now i have still this errors (with more debug kernel options):

```bash
[  OK  ] Reached target Network.
         Starting NTP client/server...
         Starting CUPS Scheduler...
         Starting OpenSSH Daemon...
         Starting Permit User Sessions...
[  OK  ] Finished Permit User Sessions.
         Starting X Display Manager...
         Starting Hold until boot process finishes up...
[   26.209756] vgaarb: vga_arb_open
[   26.213140] vgaarb: client 0x0000000082e35b0d called 'target'
[   26.219004] vgaarb: PCI:0002:01:00.0 ==> 0002:01:00.0 pdev 00000000b16d9eeb
[   26.226071] vgaarb: vgadev 0000000030221129
[   26.629622] [drm:radeon_bo_move] *ERROR* failed to bind 1 pages at 0x00000000
[   26.637004] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (4096, 2, 4096, -22)
[   26.647264] [drm:radeon_bo_move] *ERROR* failed to bind 1 pages at 0x00000000
[   26.654573] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (4096, 2, 4096, -22)
[   26.937275] vgaarb: client 0x0000000082e35b0d called 'target'
[   26.943180] vgaarb: PCI:0002:01:00.0 ==> 0002:01:00.0 pdev 00000000b16d9eeb
[   26.950257] vgaarb: vgadev 0000000030221129
[   27.311882] [drm:radeon_bo_move] *ERROR* failed to bind 6 pages at 0x00000000
[   27.319257] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (24576, 2, 4096, -22)
[   27.328921] [drm:radeon_bo_move] *ERROR* failed to bind 6 pages at 0x00000000
[   27.336247] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (24576, 2, 4096, -22)
[   27.353595] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.361592] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
[   27.372118] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.380118] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
[   27.392171] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.400167] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
[   27.410669] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.418735] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
[   27.429235] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.437270] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
[   27.447764] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   27.455843] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
```

I also tried the newer 6.6 kernel (with bigger swiotlb)
Tried to set in radeon_device the dma_bits to 32 (hardcoded, maybe 40-bit dma was a problem...)

```bash
[   39.529290] trying to bind memory to uninitialized GART !
[   39.534764] WARNING: CPU: 2 PID: 1157 at drivers/gpu/drm/radeon/radeon_gart.c:294 radeon_gart_bind+0xd2/0xd8
[   39.534782] Modules linked in:
[   39.534789] CPU: 2 PID: 1157 Comm: Xorg.bin Tainted: G        W          6.6.36+ #5
[   39.534795] Hardware name: Milk-V Jupiter (DT)
[   39.534799] epc : radeon_gart_bind+0xd2/0xd8
[   39.534805]  ra : radeon_gart_bind+0xd2/0xd8
[   39.534811] epc : ffffffff8090cd44 ra : ffffffff8090cd44 sp : ffffffc800aa3910
[   39.534815]  gp : ffffffff82b41f78 tp : ffffffd902899780 t0 : 7420676e69797274
[   39.534818]  t1 : 0000000000000074 t2 : 6f7420676e697972 s0 : ffffffc800aa3970
[   39.534823]  s1 : ffffffd9049ab478 a0 : 000000000000002d a1 : ffffffda75edb608
[   39.534827]  a2 : ffffffda75ee79a8 a3 : 0000000000000010 a4 : 0000000000000000
[   39.534830]  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 0000000000000038
[   39.534834]  s2 : ffffffd900650000 s3 : ffffffd90d360700 s4 : ffffffc800aa3b00
[   39.534838]  s5 : 0000000000000000 s6 : ffffffc800aa3a78 s7 : 0000000000000000
[   39.534841]  s8 : ffffffd9006506e0 s9 : ffffffd9006506e0 s10: ffffffd9049ab478
[   39.534845]  s11: ffffffd9049ab400 t3 : ffffffff82b5ba9f t4 : ffffffff82b5ba9f
[   39.534849]  t5 : ffffffff82b5baa0 t6 : ffffffc800aa3718
[   39.534851] status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
[   39.534855] [<ffffffff8090cd44>] radeon_gart_bind+0xd2/0xd8
[   39.534863] [<ffffffff8090b03c>] radeon_bo_move+0x88/0x3ce
[   39.534870] [<ffffffff808ead98>] ttm_bo_handle_move_mem+0x8a/0x102
[   39.534879] [<ffffffff808eb666>] ttm_bo_validate+0x78/0xee
[   39.534886] [<ffffffff808eb7ca>] ttm_bo_init_reserved+0xee/0x126
[   39.534893] [<ffffffff808eb83e>] ttm_bo_init_validate+0x3c/0xaa
[   39.534901] [<ffffffff8090baac>] radeon_bo_create+0x108/0x1aa
[   39.534908] [<ffffffff8091db08>] radeon_gem_object_create+0x80/0x146
[   39.534915] [<ffffffff8091dca2>] radeon_gem_create_ioctl+0x5c/0x134
[   39.534921] [<ffffffff808b6736>] drm_ioctl_kernel+0xa0/0x122
[   39.534932] [<ffffffff808b6968>] drm_ioctl+0x1b0/0x3c6
[   39.534938] [<ffffffff808f3060>] radeon_drm_ioctl+0x3c/0x82
[   39.534946] [<ffffffff80209d24>] __riscv_sys_ioctl+0x8e/0xa0
[   39.534955] [<ffffffff815205a0>] do_trap_ecall_u+0x11a/0x12c
[   39.534964] [<ffffffff81529b72>] ret_from_exception+0x0/0x6e
[   39.534973] ---[ end trace 0000000000000000 ]---
[   39.534977] [drm:radeon_bo_move] *ERROR* failed to bind 256 pages at 0x00000000
[   39.754093] [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (1048576, 2, 4096, -22)
```

With the error of the kernel 6.6 i have the idea that the GART is not "ready/correct" yet in the PCIe driver of this SoC? [GART](https://en.wikipedia.org/wiki/Graphics_address_remapping_table) I am no kernel developer, it is a hobby to get stuff working in Linux. Here my knowledge of Linux kernels ends. I hope you can find a solution or are already working on it. It is also possible that this is still on the backlog, then I will have to wait a little longer.

Is the PCIe kernel driver not 100% complete? are there still missing stuff or is it not working correct (yet)?
