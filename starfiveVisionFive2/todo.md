

```bash
# set the ip of the VisionFive 2, and of the server (where docker is running)
$ setenv ipaddr 192.168.2.222; setenv serverip 192.168.2.29
# check connection
$ ping 192.168.2.29
# Initialize SPI Flash
$ sf probe
# Download and Update SPL binary
$ tftpboot 0xa0000000 ${serverip}:ubuntu/u-boot-spl.bin.normal.out
$ tftpboot 0xa0000000 ${serverip}:u-boot-spl.bin.normal.out
$ sf update 0xa0000000 0x0 $filesize
# Download and Update U-Boot binary
$ tftpboot 0xa0000000 ${serverip}:ubuntu/u-boot.itb
$ tftpboot 0xa0000000 ${serverip}:visionfive2_fw_payload.img
$ sf update 0xa0000000 0x100000 $filesize
# Reset the default (default load options)
$ env default -f -a
# Save your changes
$ env save
```

```bash
Hit any key to stop autoboot:  0 
StarFive # setenv ipaddr 192.168.2.222; setenv serverip 192.168.2.29
StarFive # ping 192.168.2.29
ethernet@16030000 Waiting for PHY auto negotiation to complete....... done
Using ethernet@16030000 device
host 192.168.2.29 is alive
StarFive # sf probe
SF: Detected gd25lq128 with page size 256 Bytes, erase size 4 KiB, total 16 MiB
StarFive # tftpboot 0xa0000000 ${serverip}:ubuntu/u-boot-spl.bin.normal.out
Using ethernet@16030000 device
TFTP from server 192.168.2.29; our IP address is 192.168.2.222
Filename 'ubuntu/u-boot-spl.bin.normal.out'.
Load address: 0xa0000000
Loading: ##########
         900.4 KiB/s
done
Bytes transferred = 139367 (22067 hex)
StarFive # sf update 0xa0000000 0x0 $filesize
device 0 offset 0x0, size 0x22067
139367 bytes written, 0 bytes skipped in 0.802s, speed 177281 B/s
StarFive # tftpboot 0xa0000000 ${serverip}:ubuntu/u-boot.itb
Using ethernet@16030000 device
TFTP from server 192.168.2.29; our IP address is 192.168.2.222
Filename 'ubuntu/u-boot.itb'.
Load address: 0xa0000000
Loading: #################################################################
         ####
         1010.7 KiB/s
done
Bytes transferred = 1005851 (f591b hex)
StarFive # sf update 0xa0000000 0x100000 $filesize
device 0 offset 0x100000, size 0xf591b
932123 bytes written, 73728 bytes skipped in 7.618s, speed 135134 B/s
StarFive # env default -f -a
## Resetting to default environment
StarFive # env save
Saving Environment to SPIFlash... Erasing SPI flash...Writing to SPI flash...done
OK

```

```bash
-----BEGIN SSH HOST KEY KEYS-----
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNPq5SLKgBXEcCWZwAequ9Qr9af/PSurVzwNX3XIF/CAutf/aMGsOtBIyH5mk44HdLmtNLoM+voHsiZZ2/I8uCU= root@
ubuntu
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFLC6yXTpYmdkQstt6l2vzoJHRkQfvFllD3sVNg0L3o root@ubuntu
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1nU/WOAsdfYMyRYSLXWHgsDd8brhSlYYLMCpS00Lv2CJr037RUe+v5TfzPqbBw9xech8lFruZxzJ0AHJx4kbu34va9de6xSVLjD+5cHE343pn0eXi4VI9KT9bnN42h2
1+7q/yGv2+ALQJ48Gi/AvuDnWKFXa8i4LOqlVjbnfutpko6bdw1ogttRXF8Lh7PacU6XihfQ7R5yPk0r2Kw0eFPT8vLRWp5OmT2KJaMg0K/UE0+Avv5zLq5axvSchA4pbeQ0NhgCw7NQUmuFha3ZUf/saksiohAtXUo2AF
HB3crZFM39ffyHaZyycP0rSMCU3ErCsV3YYRWJZ34A0t7+4fxdWUfhB1+hxm9D8EovTtB6/K1qiEU5/b7fP4n2wuBlpMhn/Nt/UG3vJ/jxtfLCoNHTL4iFdhP33mpnpB7uVZxR9TGI22+EQO5HyXSMF5HI4CGUr2bo2/ud
A/QNZScPICD9Hfq1MFS553M2dINFpFmVuvSqK3u0w4sW7ErB2Xr/U= root@ubuntu
-----END SSH HOST KEY KEYS-----
[  127.899234] cloud-init[1714]: Cloud-init v. 23.3.1-0ubuntu2 finished at Mon, 20 Nov 2023 23:21:04 +0000. Datasource DataSourceNoCloud [seed=/var/lib/cloud/seed/noc
loud-net][dsmode=net].  Up 127.87 seconds
[  OK  ] Finished cloud-final.servi… Execute cloud user/final scripts.
[  OK  ] Reached target cloud-init.target - Cloud-init target.

Ubuntu 23.10 ubuntu ttyS0

ubuntu login: ubuntu
Password: 
You are required to change your password immediately (administrator enforced).
Changing password for ubuntu.
Current password: 
New password: 
Retype new password: 
Welcome to Ubuntu 23.10 (GNU/Linux 6.5.0-9-generic riscv64)

```

### BOOT/ROOT Add the boot option

```bash
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- modules -j 16 
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- INSTALL_MOD_PATH=/home/opvolger/visionfive2/kernel modules_install -j 16 
```

```bash
$ sudo cp ~/Downloads/SF2_2023_11_20/visionfive2/kernel/boot/System.map-6.1.31+ /run/media/opvolger/cloudimg-rootfs/boot/System.map-6.1.31+
$ sudo cp ~/Downloads/SF2_2023_11_20/visionfive2/kernel/boot/vmlinuz-6.1.31+ /run/media/opvolger/cloudimg-rootfs/boot/vmlinuz-6.1.31+
$ sudo cp ~/Downloads/SF2_2023_11_20/visionfive2/kernel/lib/modules/6.1.31+ /run/media/opvolger/cloudimg-rootfs/lib/modules/ -R
$ sudo cp ~/Downloads/SF2_2023_11_20/visionfive2/linux/arch/riscv/boot/dts/starfive/jh7110-visionfive-v2.dtb /run/media/opvolger/cloudimg-rootfs/boot/dtb-6.1.31+
$ sudo cp /run/media/opvolger/cloudimg-rootfs/boot/initrd.img-6.5.0-10-generic /run/media/opvolger/cloudimg-rootfs/boot/initrd.img-6.1.31+
$ sudo chmod o+w  /run/media/opvolger/cloudimg-rootfs/boot/initrd.img-6.1.31+
$ mkdir ~/Downloads/SF2_2023_11_20/visionfive2/initrd
$ cd ~/Downloads/SF2_2023_11_20/visionfive2/initrd
$ cpio -i -F /run/media/opvolger/cloudimg-rootfs/boot/initrd.img-6.1.31+
$ rm usr/lib/modules/6.5.0-10-generic/ -R
$ rm usr/lib/firmware -R
$ mkdir usr/lib/firmware
$ cp ~/Downloads/SF2_2023_11_20/visionfive2/kernel/lib/modules/6.1.31+ usr/lib/modules -R
$ cp ~/Downloads/SF2_2023_11_20/visionfive2/linux-firmware/* usr/lib/firmware -R
$ find . | cpio -o -H newc > /run/media/opvolger/cloudimg-rootfs/boot/initrd.img-6.1.31+



# copy the kernel to the sd-card
$ sudo cp arch/riscv/boot/Image.gz /run/media/opvolger/cloudimg-rootfs/boot/vmlinuz-6.1.31+
# copy the System map
$ sudo cp System.map /run/media/opvolger/cloudimg-rootfs/boot/System.map-6.1.31+
# copy the dtb (Device Tree) to the sd-card
$ sudo cp arch/riscv/boot/dts/starfive/jh7110-visionfive-v2.dtb /run/media/opvolger/cloudimg-rootfs/boot/dtb-6.1.31+


sudo update-initramfs -u -k version


```bash
$ git clone --branch JH7110_VisionFive2_upstream --depth 1 https://github.com/starfive-tech/linux.git linux2
# copy .config van 5.15.0 naar hier (linux2)
$ make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv menuconfig
# exit and save

$ make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j16
$ make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- modules -j 16
$ make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- INSTALL_MOD_PATH=/home/opvolger/Downloads/SF2_2023_11_20/visionfive2/kernel_modules/ modules_install -j 16 

# copy the kernel to the sd-card
$ sudo cp arch/riscv/boot/Image.gz /run/media/opvolger/cloudimg-rootfs/boot/vmlinuz-6.6.0+
# copy the System map
$ sudo cp System.map /run/media/opvolger/cloudimg-rootfs/boot/System.map-6.6.0+
# copy the dtb (Device Tree) to the sd-card
$ sudo cp arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-v1.3b.dtb /run/media/opvolger/cloudimg-rootfs/boot/dtb-6.6.0+
#
$ sudo -i
$ cd /home/opvolger/Downloads/SF2_2023_11_20/visionfive2/initrd
$ cp /run/media/opvolger/cloudimg-rootfs/boot/initrd.img-5.15.0-dirty .
$ zstd --decompress initrd.img-5.15.0-dirty -o initrd.img-5.15.0
$ cpio -i -F initrd.img-5.15.0
$ rm initrd.img-5.15.0* -f
$ cp /home/opvolger/Downloads/SF2_2023_11_20/visionfive2/kernel_modules/lib/modules/6.6.0+ usr/lib/modules -R
$ rm usr/lib/modules/6.6.0+/build
$ rm usr/lib/modules/5.15.0-starfive -rf
$ find . | cpio -H newc -o | zstd -19 --ultra -o ../initrd.img-6.6.0+
$ find . | cpio -H newc -o | gzip -9 > ../initrd-6.1.31+.img
$ cp ../initrd.img-6.6.0+ /run/media/opvolger/cloudimg-rootfs/boot/
$ exit
```

https://forum.rvspace.org/t/nvme-boot-using-visionfive2-software-v2-11-5/2464

Boot from emmc OpenSUSE

```bash
mmc info
mmc dev 0 # == emmc
mmc dev 1 # == sd
mmc part

ext4ls mmc 1:4 # ls for mmc dev 1 part 4
```

Boot Ubuntu

```bash
ext4load mmc 1:1 ${kernel_addr_r} /boot/vmlinuz-6.1.31+
ext4load mmc 1:1 ${fdt_addr_r} /boot/dtb-6.1.31+
ext4load mmc 1:1 ${ramdisk_addr_r} /boot/initrd.img-6.1.31+
setenv bootargs 'root=/dev/mmcblk1p1 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'
booti $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r
```

Boot from emmc OpenSUSE

```bash
ext4load mmc 0:3 ${kernel_addr_r} /boot/vmlinuz-6.1.31+
ext4load mmc 0:3 ${fdt_addr_r} /boot/dtb-6.1.31+
ext4load mmc 0:3 ${ramdisk_addr_r} /boot/initrd.img-6.1.31+

ext4load mmc 1:3 ${kernel_addr_r} /boot/vmlinuz-6.6.0+
ext4load mmc 1:3 ${fdt_addr_r} /boot/dtb-6.6.0+
ext4load mmc 1:3 ${ramdisk_addr_r} /boot/initrd-6.6.0+.img

#setenv bootargs 'console=ttyS0,115200 debug rootwait earlycon=sbi'
setenv bootargs 'root=/dev/mmcblk0p3 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'
#setenv kernel_comp_addr_r 0x88000000
setenv kernel_comp_addr_r 0x50000000
#setenv kernel_comp_size 0x4000000
setenv kernel_comp_size 0x04000000
booti $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r
```

```bash
pacman -S xorg plasma plasma-wayland-session kde-applications --ignore kcharselect,kde-dev-scripts,kontrast,gwenview,kpkpass,keysmith,kdbgsettings
```

```bash
git clone https://github.com/starfive-tech/Tools.git
git clone https://github.com/starfive-tech/opensbi.git
git clone https://github.com/starfive-tech/u-boot.git

git clone https://github.com/u-boot/u-boot.git
git clone https://github.com/riscv-software-src/opensbi.git

make -C Tools/spl_tool
# https://github.com/starfive-tech/VisionFive2/blob/JH7110_VisionFive2_devel/Makefile
# https://en.opensuse.org/VisionFive2:Tips#Downstream_firmware_construction

make -C u-boot ARCH=riscv starfive_visionfive2_defconfig
make -C u-boot ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j16 OPENSBI=../opensbi/build/platform/generic/firmware/fw_dynamic.bin 

make -C opensbi ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- PLATFORM=generic FW_PAYLOAD_PATH=../u-boot/u-boot.bin FW_FDT_PATH=../u-boot/arch/riscv/dts/jh7110-starfive-visionfive-2.dtb FW_TEXT_START=0x40000000
make -C opensbi ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- PLATFORM=generic FW_PAYLOAD_PATH=../u-boot/u-boot.bin FW_FDT_PATH=../u-boot/arch/riscv/dts/starfive_visionfive2.dtb FW_TEXT_START=0x40000000

wget https://raw.githubusercontent.com/starfive-tech/VisionFive2/JH7110_VisionFive2_devel/conf/visionfive2-uboot-fit-image.its
# change location of fw_payload.bin
nano visionfive2-uboot-fit-image.its
mkimage -f visionfive2-uboot-fit-image.its -A riscv -O u-boot -T firmware visionfive2_fw_payload.img
./Tools/spl_tool/spl_tool -c -f u-boot/spl/u-boot-spl.bin 0x01010101

sudo /sbin/sgdisk --clear  \
    --new=1:4096:8191     --change-name=1:"spl"   --typecode=1:2E54B353-1271-4842-806F-E436D6AF6985   \
    --new=2:8192:16383 --change-name=2:"uboot" --typecode=2:5B193300-FC78-40CD-8002-E86C45580B47 \
    /dev/sdb
/sbin/partprobe

# SPL:
sudo dd if=u-boot/spl/u-boot-spl.bin.normal.out of=/dev/sdb1
# U-Boot:
sudo dd if=visionfive2_fw_payload.img of=/dev/sdb2
```

Boot Fedora

```ini
modulename:  zram.ko
configname: CONFIG_ZRAM
Linux Kernel Configuration
└─>Device Drivers
└─>Block devices
└─>Compressed RAM block device support
```

```bash
# https://www.mail-archive.com/devel@openvz.org/msg41066.html

linux_dir=/home/opvolger/starfive/upstream
kernel_ver="6.6.0+"
dtb_filename=jh7110-starfive-visionfive-2-v1.3b.dtb
boot_dir=/run/media/opvolger/ROOT/boot/
tmp_dir=/home/opvolger/OpenSUSETumbleweed/tmp/boot
module_dir=/home/opvolger/OpenSUSETumbleweed/tmp/modules

linux_dir=/home/opvolger/OpenSUSETumbleweed/linux
kernel_ver="6.1.31+"
dtb_filename=jh7110-visionfive-v2.dtb
boot_dir=/run/media/opvolger/__boot
tmp_dir=/home/opvolger/Downloads/SF2_2023_11_20/fedora
module_dir=/home/opvolger/OpenSUSETumbleweed/modules

make -C $linux_dirCROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv menuconfig
make -C $linux_dir ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j 16
make -C $linux_dir ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- INSTALL_MOD_PATH=$module_dir modules_install -j 16

rm $tmp_dir/vmlinuz-$kernel_ver --force
rm $tmp_dir/System.map-$kernel_ver --force
rm $tmp_dir/dtb-$kernel_ver --force

cp $linux_dir/arch/riscv/boot/Image.gz $tmp_dir/vmlinuz-$kernel_ver
cp $linux_dir/System.map $tmp_dir/System.map-$kernel_ver
cp $linux_dir/arch/riscv/boot/dts/starfive/$dtb_filename $tmp_dir/dtb-$kernel_ver

rm $tmp_dir/ramdisk/usr/lib/modules/$kernel_ver -rf
cp $module_dir/lib/modules/$kernel_ver $tmp_dir/ramdisk/usr/lib/modules -R
cd $tmp_dir/ramdisk
rm ../initrd-$kernel_ver.img --force
find . | cpio -H newc -o | gzip -9 > ../initrd-$kernel_ver.img
yes | cp ../dtb-$kernel_ver $boot_dir
yes | cp ../vmlinuz-$kernel_ver $boot_dir
yes | cp ../System.map-$kernel_ver $boot_dir
yes | cp ../initrd-$kernel_ver.img $boot_dir

mkimage -C none -A riscv -T script -d /home/opvolger/code/Opvolger/starfiveVisionFive2/FedoraATIRadeon5450/boot.cmd /run/media/opvolger/__boot/boot.scr
cpio -i -F initrd.img-5.15.0
```

```
load mmc 0:1 ${scriptaddr} boot.scr; source ${scriptaddr}

load mmc 1:3 ${scriptaddr} boot.scr; source ${scriptaddr}
```

```bash
mkdir $tmp_dir/ramdisk/lib/firmware/radeon
mkdir $tmp_dir/ramdisk/lib/firmware/amdgpu
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/CYPRESS_uvd.bin $tmp_dir/ramdisk/lib/firmware/radeon/CYPRESS_uvd.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/CEDAR_smc.bin $tmp_dir/ramdisk/lib/firmware/radeon/CEDAR_smc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/CEDAR_me.bin $tmp_dir/ramdisk/lib/firmware/radeon/CEDAR_me.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/CEDAR_pfp.bin $tmp_dir/ramdisk/lib/firmware/radeon/CEDAR_pfp.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/CEDAR_rlc.bin $tmp_dir/ramdisk/lib/firmware/radeon/CEDAR_rlc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_k_smc.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_k_smc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_smc.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_smc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_uvd.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_uvd.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_vce.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_vce.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_sdma.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_sdma.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_sdma1.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_sdma1.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_pfp.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_pfp.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_me.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_me.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_ce.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_ce.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_rlc.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_rlc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_mec.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_mec.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/amdgpu/hawaii_mc.bin $tmp_dir/ramdisk/lib/firmware/amdgpu/hawaii_mc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_pfp.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_pfp.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_me.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_me.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_ce.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_ce.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_mec.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_mec.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_mc.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_mc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_rlc.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_rlc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_sdma.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_sdma.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_smc.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_smc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/hawaii_k_smc.bin $tmp_dir/ramdisk/lib/firmware/radeon/hawaii_k_smc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_pfp.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_pfp.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_me.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_me.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_ce.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_ce.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_mec.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_mec.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_mc.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_mc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_mc2.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_mc2.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_rlc.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_rlc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_sdma.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_sdma.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/radeon/HAWAII_smc.bin $tmp_dir/ramdisk/lib/firmware/radeon/HAWAII_smc.bin
cp /home/opvolger/OpenSUSETumbleweed/linux-firmware/rt2870.bin $tmp_dir/ramdisk/lib/firmware/rt2870.bin

```


https://command-not-found.com/mkimage
https://stackoverflow.com/questions/28891221/uenv-txt-vs-boot-scr
https://github.com/linux-sunxi/u-boot-sunxi/wiki

```bash
load mmc 0:1 ${scriptaddr} boot.scr; source ${scriptaddr}
load mmc 1:2 ${scriptaddr} boot.scr; source ${scriptaddr}
sysboot mmc 1:2 any ${scriptaddr} /extlinux/extlinux.conf
```

```bash
ext4load mmc 1:2 ${kernel_addr_r} /vmlinuz-6.1.31+
ext4load mmc 1:2 ${fdt_addr_r} /dtb-6.1.31+
ext4load mmc 1:2 ${ramdisk_addr_r} /initrd-6.1.31+.img
#setenv bootargs 'console=ttyS0,115200 debug rootwait earlycon=sbi'
setenv bootargs 'ro root=UUID=ee62c484-2eaf-45d7-937c-02fbe3ad8535 quiet LANG=en_US.UTF-8 rootflags=subvol=root'
#setenv kernel_comp_addr_r 0x88000000
setenv kernel_comp_addr_r 0x50000000
#setenv kernel_comp_size 0x4000000
setenv kernel_comp_size 0x04000000
booti $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r
```

```bash
$ sudo nano ~/visionfive2/root/etc/yum.repos.d/fedora.repo
```

If you want to disable the GPG validation for the whole Repo, add the following line to the Repo definition in /etc/yum.conf:

gpgcheck=0

# baseurl=http://fedora.riscv.rocks/repos-dist/f39/latest/riscv64/
# http://fedora.riscv.rocks/repos-dist/f40/latest/riscv64/
# http://fedora.riscv.rocks/repos/f40-build/latest/riscv64/repodata/
# http://fedora.riscv.rocks/repos-dist/f40/latest/

```bash
sudo dnf system-upgrade download --releasever=rawhide --exclude=sdubby
sudo dnf system-upgrade download --releasever=40 --exclude=sdubby
```
