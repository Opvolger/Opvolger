# Build U-Boot for StarFive VisionFive 2
# inspirated on https://github.com/xypron/visionfive2-u-boot-build/blob/main/Makefile
# and https://github.com/u-boot/u-boot/blob/master/doc/board/starfive/visionfive2.rst
.POSIX:

TAG_U_BOOT=v2024.10
export TAG_U_BOOT
TAG_OBENSBI=v1.5.1
export TAG_OBENSBI
DISABLE_NVME_SUPPORT_U_BOOT=yes
export DISABLE_NVME_SUPPORT_U_BOOT

NPROC=${shell nproc}
MK_ARCH="${shell uname -m}"
ifeq ("riscv64", $(MK_ARCH))
	undefine CROSS_COMPILE
else
	export CROSS_COMPILE=riscv64-linux-gnu-
endif
undefine MK_ARCH

all:
	make u-boot.bin

opensbi-git:
	cd opensbi && git reset --hard $(TAG_OBENSBI) || git clone -v https://github.com/riscv-software-src/opensbi.git

u-boot-git:
	cd u-boot && git reset --hard $(TAG_U_BOOT) || git clone -v https://github.com/u-boot/u-boot.git

u-boot.bin: u-boot-git fw_payload.bin
	echo $(CROSS_COMPILE)
	cd u-boot && make distclean
	cd u-boot && git reset --hard $(TAG_U_BOOT)
	if [ '$(DISABLE_NVME_SUPPORT_U_BOOT)' == 'yes' ]; then \
		sed -i 's/CONFIG_PREBOOT="nvme scan; /CONFIG_PREBOOT="/g' u-boot/configs/starfive_visionfive2_defconfig; \
		sed -i 's/CONFIG_PCI_INIT_R=y/CONFIG_PCI_INIT_R=n/g' u-boot/configs/starfive_visionfive2_defconfig; \
		sed -i 's/CONFIG_CMD_PCI=y/CONFIG_CMD_PCI=n/g' u-boot/configs/starfive_visionfive2_defconfig; \
	fi
	cd u-boot && make starfive_visionfive2_defconfig
	cd u-boot && make OPENSBI=../opensbi/build/platform/generic/firmware/fw_payload.bin CONFIG_DEFAULT_FDT_FILE=starfive/jh7110-starfive-visionfive-2-v1.3b.dtb -j $(NPROC)
	cp u-boot/spl/u-boot-spl.bin.normal.out .
	cp u-boot/u-boot.itb .

fw_payload.bin: opensbi-git
	cd opensbi && make clean
	cd opensbi && git reset --hard $(TAG_OBENSBI)
	cd opensbi && make -j $(NPROC) \
	  PLATFORM=generic \
	  FW_OPTIONS=0 \
	  FW_TEXT_START=0x40000000

clean:
	rm -f u-boot-spl.bin.normal.out u-boot.itb


# sudo sgdisk --clear \
#   --set-alignment=2 \
#   --new=1:4096:8191 --change-name=1:spl --typecode=1:2E54B353-1271-4842-806F-E436D6AF6985\
#   --new=2:8192:16383 --change-name=2:uboot --typecode=2:BC13C2FF-59E6-4262-A352-B275FD6F7172  \
#   --new=3:16384:1654784 --change-name=3:system --typecode=3:EBD0A0A2-B9E5-4433-87C0-68B6B72699C7 \
#   /dev/sdb

# sudo dd if=u-boot-spl.bin.normal.out of=/dev/sdb1
# sudo dd if=u-boot.itb of=/dev/sdb2
