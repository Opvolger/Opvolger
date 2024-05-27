ext4load mmc 0:3 ${fdt_addr_r} /home/opvolger/jh7110-starfive-visionfive-2-v1.3b.dtb;
ext4load mmc 0:3 ${kernel_addr_r} /home/opvolger/Image.gz;
setenv bootargs 'root=/dev/mmcblk0p3 rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0';
booti $kernel_addr_r - $fdt_addr_r;