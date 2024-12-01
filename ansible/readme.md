# Create bootable partitions from RISCV

## StarFive VisionFive 2

U-boot and opensbi build can be find [here](https://github.com/u-boot/u-boot/blob/master/doc/board/starfive/visionfive2.rst)

### Reset u-boot environment variables

Maybe reset the u-boot environment variables with:

```bash
env default -a
saveenv
```

This has to be done in U-boot!

### Create / Update SD-card

```bash
ansible-playbook [board]-[action].yaml --ask-become-pass -v 
```

Examples for Starfive Visionfive2:

- starfive-visionfive2-compile.yaml: Compiles U-boot, OpenSBI and the kernel
- starfive-visionfive2-create-boot.yaml: starfive-visionfive2-compile.yaml + creates boot partitions + bootfs (with kernel)
- starfive-visionfive2-opensuse.yaml: starfive-visionfive2-create-boot.yaml + creates rootfs partition
- starfive-visionfive2-update-boot.yaml: updates U-boot, OpenSBI and the kernel on the boot partitions
- starfive-visionfive2-update-kernel.yaml: updates the kernel and copied to the bootfs
