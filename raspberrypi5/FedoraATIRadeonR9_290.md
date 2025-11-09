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
amdgpu/hawaii_k_smc.bin amdgpu/hawaii_smc.bin amdgpu/hawaii_uvd.bin amdgpu/hawaii_vce.bin amdgpu/hawaii_sdma.bin amdgpu/hawaii_sdma1.bin amdgpu/hawaii_pfp.bin amdgpu/hawaii_me.bin amdgpu/hawaii_ce.bin amdgpu/hawaii_rlc.bin amdgpu/hawaii_mec.bin amdgpu/hawaii_mc.bin radeon/hawaii_pfp.bin radeon/hawaii_me.bin radeon/hawaii_ce.bin radeon/hawaii_mec.bin radeon/hawaii_mc.bin radeon/hawaii_rlc.bin radeon/hawaii_sdma.bin radeon/hawaii_smc.bin radeon/hawaii_k_smc.bin radeon/HAWAII_pfp.bin radeon/HAWAII_me.bin radeon/HAWAII_ce.bin radeon/HAWAII_mec.bin radeon/HAWAII_mc.bin radeon/HAWAII_mc2.bin radeon/HAWAII_rlc.bin radeon/HAWAII_sdma.bin radeon/HAWAII_smc.bin
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

Change `M` to `*` from ZRAM and enable all the sub `Compressed RAM block device support`:

```
Device Drivers
└─>Block devices
    └─><*>Compressed RAM block device support
       [*]     lz4 compression support
        [*]     lz4hc compression support 
        [*]     zstd compression support  
        [*]     deflate compression support
        [*]     842 compression support
        [*]     lzo and lzo-rle compression support
                Default zram compressor (zstd)  --->
        [*]     Write back incompressible or idle page to backing device
        [*]     Track access time of zram entries
        [*]     Track zRam block status
        [*]     Enable multiple compression streams
```

We now need to set the page size from 16 to 4 in the kernel

```
Kernel Features
└─>Page size (16KB)
```

Now you need to select `4KB` (space bar).

We can now Exit and save the changes!

You can disable more options (Like `Amateur Radio support`, `Industrial I/O support`, `USB sound devices` ,`ALSA for SoC audio support`, `Broadcom VideoCore support`, `Touchscreens`, `Media USB Adapters`, `Radio Adapters` and `Support for small TFT LCD display modules`), but this is optional. The kernel will compile faster.

Before we can build, we need to add a kernel patch. We need to change code so the pi can work with the AMDGPU.

Create a file `drm.patch` in `/home/opvolger/demo/raspberrypi-6.12-y/`. I found this patch [here](https://github.com/geerlingguy/raspberry-pi-pcie-devices/discussions/756).

```patch
From c1d421d7c501c77e8c04bdfa141a55e639822c03 Mon Sep 17 00:00:00 2001
From: Yang Bo <bo.yang@smail.nju.edu.cn>
Date: Wed, 28 May 2025 11:18:19 +0800
Subject: [PATCH] Add amdgpu support for arm SoC

Change-Id: Ic95c8514271d246dd668631810e8dee210f7f1b4
Signed-off-by: Yanghaku <bo.yang@smail.nju.edu.cn>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c | 14 +-------------
 drivers/gpu/drm/ttm/ttm_module.c  |  5 +++++
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 0b3f4267130c..e0e55cb9edd2 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -343,8 +343,6 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
 		.no_wait_gpu = false
 	};
 	struct ttm_tt *ttm = bo->ttm;
-	struct ttm_resource_manager *man =
-			ttm_manager_type(bo->bdev, bo->resource->mem_type);
 	pgprot_t prot;
 	int ret;
 
@@ -354,17 +352,7 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo,
 	if (ret)
 		return ret;
 
-	if (num_pages == 1 && ttm->caching == ttm_cached &&
-	    !(man->use_tt && (ttm->page_flags & TTM_TT_FLAG_DECRYPTED))) {
-		/*
-		 * We're mapping a single page, and the desired
-		 * page protection is consistent with the bo.
-		 */
-
-		map->bo_kmap_type = ttm_bo_map_kmap;
-		map->page = ttm->pages[start_page];
-		map->virtual = kmap(map->page);
-	} else {
+	{
 		/*
 		 * We need to use vmap to get the desired page protection
 		 * or to make the buffer object look contiguous.
diff --git a/drivers/gpu/drm/ttm/ttm_module.c b/drivers/gpu/drm/ttm/ttm_module.c
index b3fffe7b5062..9f3e425626b5 100644
--- a/drivers/gpu/drm/ttm/ttm_module.c
+++ b/drivers/gpu/drm/ttm/ttm_module.c
@@ -63,7 +63,12 @@ pgprot_t ttm_prot_from_caching(enum ttm_caching caching, pgprot_t tmp)
 {
 	/* Cached mappings need no adjustment */
 	if (caching == ttm_cached)
+	{
+#ifdef CONFIG_ARM64
+		return pgprot_dmacoherent(tmp);
+#endif
 		return tmp;
+	}
 
 #if defined(__i386__) || defined(__x86_64__)
 	if (caching == ttm_write_combined)
-- 
2.49.0
```

```bash
# we first apply the patch
$ git apply 
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

First check you PARTUUID of your fedora rootfs. You can do this with with the command `blkid`

```bash
$ blkid
................
................
................
................
/dev/sdb1: LABEL_FATBOOT="BOOTFS" LABEL="BOOTFS" UUID="F830-72A5" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="a5e8e31d-01"
/dev/zram0: LABEL="zram0" UUID="d3cb02f4-a70f-4f48-92ce-1bb0474c14fc" TYPE="swap"
/dev/sdb3: LABEL="fedora" UUID="fe1a5809-2964-4049-804b-c6308eea9706" UUID_SUB="8695f5be-13c2-4f38-9ec4-ca593ac9665d" BLOCK_SIZE="4096" TYPE="btrfs" PARTUUID="a5e8e31d-03"
```

Now create the file `/run/media/opvolger/BOOTFS/cmdline.txt` with nano or something else.

This will add kernel argument on boot time.
We enable serial output, set the correct settings for the root-fs of fedora, disable radeon drivers and enable amdgpu drivers.

Here we can use `a5e8e31d-03` for the `PARTUUID`. don't forget to update. The boot process will stop. (it will not find a root partition).

```ini
console=serial0,115200 console=tty1 root=PARTUUID=a5e8e31d-03 ro rootflags=subvol=root rhgb rootflags=subvol=root fsck.repair=yes rootwait plymouth.ignore-serial-consoles radeon.si_support=0 radeon.cik_support=0 amdgpu.si_support=1 amdgpu.cik_support=1
```

Now we change the fstab file from the fedora root partition. We have deleted the boot partition, so we must delete it from the mount on startup.

```bash
sudo nano /run/media/opvolger/fedora/root/etc/fstab
```

Add a `#` for the /boot and /boot/efi mounts. On a newer version the UUID's can be different, keep them, only add the `#` on the lines where `/boot` annd `/boot/efi` are located.

```ini
UUID=fe1a5809-2964-4049-804b-c6308eea9706 / btrfs x-systemd.growfs,compress=zstd:1,defaults,subvol=root 0 1
#UUID=c17a86dd-8323-4e0d-9595-3ba0107f6345 /boot ext4 defaults 0 0
UUID=fe1a5809-2964-4049-804b-c6308eea9706 /home btrfs x-systemd.growfs,compress=zstd:1,subvol=home 0 0
UUID=fe1a5809-2964-4049-804b-c6308eea9706 /var btrfs x-systemd.growfs,compress=zstd:1,subvol=var 0 0
#UUID=9AB8-3989 /boot/efi vfat defaults,umask=0077,shortname=winnt 0 0
```

Now we only have to copy the kernel files!

```bash
$ cd /home/opvolger/demo/raspberrypi-6.12-y
# copy kernel and device tree to boot partition SD-card
$ cp arch/arm64/boot/Image /run/media/opvolger/BOOTFS/
$ cp arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b.dtb /run/media/opvolger/BOOTFS/
# copy overlay needed for pi boot process
$ mkdir /run/media/opvolger/BOOTFS/overlays
$ cp /home/opvolger/demo/raspberrypi-6.12-y/arch/arm64/boot/dts/overlays/* /run/media/opvolger/BOOTFS/overlays

# now make the modules install them on the SD-card root partition (fedora)
$ sudo ARCH=arm64 make modules_install INSTALL_MOD_PATH=/run/media/opvolger/fedora/
```

## Boot from SD-Card

Umount the root and boot partitions from the SD-card.

If everything works great, you will see a setup.

```bash
$ sudo dnf install fex-emu fex-emu-filesystem fex-emu-rootfs-fedora fex-emu-thunks fex-emu-utils erofs-fuse  erofs-utils  squashfuse  squashfuse-libs
```
