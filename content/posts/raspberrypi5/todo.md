---
draft: true
---
CONFIG_ARM64_16K_PAGES is not set

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make bcm2712_defconfig
make menuconfig
make -j 12
mkdir -p /run/media/opvolger/bootfs/basm2/overlays

cp /run/media/opvolger/bootfs/cmdline.txt /run/media/opvolger/bootfs/basm2/cmdline.txt
cp arch/arm64/boot/Image /run/media/opvolger/bootfs/basm2/
cp .config /run/media/opvolger/bootfs/basm2/config-6.12.57-v8-16k+
cp arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b.dtb /run/media/opvolger/bootfs/basm2/
cp arch/arm64/boot/dts/overlays/*.dtbo /run/media/opvolger/bootfs/basm2/overlays

sudo ARCH=arm64 make modules_install INSTALL_MOD_PATH=/run/media/opvolger/rootfs

sudo ARCH=arm64 make modules_install INSTALL_MOD_PATH=/run/media/opvolger/fedora/root/

# add to config.txt
os_prefix=basm2/
kernel=Image
dtparam=pciex1
dtoverlay=pcie-32bit-dma
dtoverlay=pciex1-compat-pi5,no-mip


dtoverlay=pciex1-compat-pi5,no-mip
dtoverlay=pcie-32bit-dma-pi5

# cmdline.txt

```ini
console=serial0,115200 console=tty1 root=PARTUUID=ead7b37c-03 ro rootflags=subvol=root rhgb rootflags=subvol=root fsck.repair=yes rootwait plymouth.ignore-serial-consoles cfg80211.ieee80211_regdom=NL radeon.pcie_gen_cap=0x10001 radeon.pcie_lane_cap=0x10000 radeon.modeset=1 iommu=pt pcie_aspm=off radeon.dpm=0 radeon.pcie_gen2=0
```

# Check the file /etc/initramfs-tools/initramfs.conf
# Make sure the MODULES= line says MODULES=most

sudo update-initramfs -b /boot/firmware/basm2 -c -k $(uname -r)


radeon.si_support=0 radeon.cik_support=0 amdgpu.si_support=1 amdgpu.cik_support=1

sudo dnf rm binfmt-dispatcher


cmake .. -D RPI5ARM64=1 -D CMAKE_BUILD_TYPE=RelWithDebInfo -DBOX32=ON -DBOX32_BINFMT=ON
