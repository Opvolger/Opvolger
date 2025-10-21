
sudo cp arch/riscv/boot/Image.gz /run/media/opvolger/jupiter/
make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- -j 12
sudo cp arch/riscv/boot/Image.gz /run/media/opvolger/43a5c970-e3b6-4c7c-9ee7-772319ac7485/
sudo cp arch/riscv/boot/dts/spacemit/k1-x_milkv-jupiter.dtb /run/media/opvolger/43a5c970-e3b6-4c7c-9ee7-772319ac7485/

```bash
fdt_addr_r=0x31000000
usb start
load usb 0:1 ${kernel_addr_r} /Image.gz
load usb 0:1 ${fdt_addr_r} /k1-milkv-jupiter.dtb
setenv bootargs 'root=/dev/mmcblk0p1 rw swiotlb=131072 console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'
booti $kernel_addr_r - $fdt_addr_r
```


```bash
fdt_addr_r=0x31000000
usb start
load usb 0:1 ${kernel_addr_r} /Image.gz
load usb 0:1 ${fdt_addr_r} /k1-x_milkv-jupiter.dtb
setenv bootargs 'root=/dev/mmcblk2p1 rw radeon.modeset=1 iommu=pt pcie_aspm=off radeon.dpm=0 radeon.pcie_gen2=0 cma=512M swiotlb=65536 console=tty0 console=ttyS0,115200 earlycon rootwait selinux=0'
booti $kernel_addr_r - $fdt_addr_r
```

setenv bootargs 'swiotlb=131072 console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0'