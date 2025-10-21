
CONFIG_ARM64_16K_PAGES is not set

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make bcm2712_defconfig
make menuconfig
make -j 12
mkdir /run/media/opvolger/bootfs/basm/
cp /run/media/opvolger/bootfs/cmdline.txt /run/media/opvolger/bootfs/basm/cmdline.txt
cp arch/arm64/boot/Image /run/media/opvolger/bootfs/basm/
cp .config /run/media/opvolger/bootfs/basm/config-6.18.0-rc1-v8-16k+
cp arch/arm64/boot/dts/broadcom/bcm2712-rpi-5-b.dtb /run/media/opvolger/bootfs/basm/

sudo ARCH=arm64 make modules_install INSTALL_MOD_PATH=/run/media/opvolger/rootfs

# add to config.txt
os_prefix=basm/
kernel=Image
dtparam=pciex1
dtoverlay=pcie-32bit-dma
dtoverlay=pciex1-compat-pi5,no-mip




# Check the file /etc/initramfs-tools/initramfs.conf
# Make sure the MODULES= line says MODULES=most

sudo update-initramfs -b /boot/firmware/basm -c -k $(uname -r)