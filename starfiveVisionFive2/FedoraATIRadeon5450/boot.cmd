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