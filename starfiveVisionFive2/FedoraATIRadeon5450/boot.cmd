ext4load mmc 1:2 ${kernel_addr_r} /vmlinuz-6.1.31+
ext4load mmc 1:2 ${fdt_addr_r} /dtb-6.1.31+
ext4load mmc 1:2 ${ramdisk_addr_r} /initrd-6.1.31+.img
setenv bootargs 'ro root=UUID=ee62c484-2eaf-45d7-937c-02fbe3ad8535 quiet LANG=en_US.UTF-8 rootflags=subvol=root'
setenv kernel_comp_addr_r 0x50000000
setenv kernel_comp_size 0x04000000
booti $kernel_addr_r $ramdisk_addr_r:$filesize $fdt_addr_r