

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

Boot from emmc OpenSUSE

```bash
ext4load mmc 0:3 ${kernel_addr_r} /boot/vmlinuz-6.1.31+
ext4load mmc 0:3 ${ramdisk_addr_r} /boot/initrd.img-6.1.31+
ext4load mmc 0:3 ${fdt_addr_r} /boot/dtb-6.1.31+
#setenv bootargs 'console=ttyS0,115200 debug rootwait earlycon=sbi'
setenv bootargs 'root=/dev/mmcblk0p3 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'
#setenv kernel_comp_addr_r 0x88000000
setenv kernel_comp_addr_r 0x50000000
#setenv kernel_comp_size 0x4000000
setenv kernel_comp_size 0x04000000
booti $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r
```

Boot Fedora

```bash
# https://www.mail-archive.com/devel@openvz.org/msg41066.html
make CROSS_COMPILE=riscv64-linux-gnu- ARCH=riscv menuconfig
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j 16
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- INSTALL_MOD_PATH=~/OpenSUSETumbleweed/modules modules_install -j 16 


rm /home/opvolger/Downloads/SF2_2023_11_20/fedora/vmlinuz-6.1.31+ --force
rm /home/opvolger/Downloads/SF2_2023_11_20/fedora/System.map-6.1.31+ --force
rm /home/opvolger/Downloads/SF2_2023_11_20/fedora/dtb-6.1.31+ --force
cp /home/opvolger/OpenSUSETumbleweed/linux/arch/riscv/boot/Image.gz /home/opvolger/Downloads/SF2_2023_11_20/fedora/vmlinuz-6.1.31+
cp /home/opvolger/OpenSUSETumbleweed/linux/System.map /home/opvolger/Downloads/SF2_2023_11_20/fedora/System.map-6.1.31+
cp /home/opvolger/OpenSUSETumbleweed/linux/arch/riscv/boot/dts/starfive/jh7110-visionfive-v2.dtb /home/opvolger/Downloads/SF2_2023_11_20/fedora/dtb-6.1.31+
rm /home/opvolger/Downloads/SF2_2023_11_20/fedora/ramdisk/usr/lib/modules/6.1.31+ -rf
cp /home/opvolger/OpenSUSETumbleweed/modules/lib/modules/6.1.31+ /home/opvolger/Downloads/SF2_2023_11_20/fedora/ramdisk/usr/lib/modules -R
cd /home/opvolger/Downloads/SF2_2023_11_20/fedora/ramdisk
rm ../initrd-6.1.31+.img --force
find . | cpio -H newc -o | gzip -9 > ../initrd-6.1.31+.img
cp ../*6.1.31+ /run/media/opvolger/__boot
cp ../initrd-6.1.31+.img /run/media/opvolger/__boot

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
