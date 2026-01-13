# Build u-boot and opensbi

[build info](https://github.com/u-boot/u-boot/blob/master/doc/board/starfive/visionfive2.rst)

Current version of u-boot is v2024.10 and I used the latest opensbi v1.5.1.

I disabled the NVME init in U-Boot, this is because of some AMDGPU don't like it (fan spin 100% in u-boot and nothing GPU is not working and is not visible with lspci after booting linux.)

I use external GPU on my Starfive VisionFive 2. So i disabled the NVME in u-boot. (I use a m.2 nvme to pcie adapter).

## commands to build

```bash
make all TAG_U_BOOT=v2024.07 TAG_OBENSBI=v1.5.1 DISABLE_NVME_SUPPORT_U_BOOT=yes
```

this will create the payloads that can be flashed for example on a SD-cart (for this example /dev/sdb)

```bash
sudo sgdisk --clear \
  --set-alignment=2 \
  --new=1:4096:8191 --change-name=1:spl --typecode=1:2E54B353-1271-4842-806F-E436D6AF6985\
  --new=2:8192:16383 --change-name=2:uboot --typecode=2:BC13C2FF-59E6-4262-A352-B275FD6F7172  \
  /dev/sdb

sudo dd if=u-boot-spl.bin.normal.out of=/dev/sdb1
sudo dd if=u-boot.itb of=/dev/sdb2
```

Done, you have now build your own main-stream u-boot and opensbi

## Firsttime boot in u-boot

Change the default boot environment variable

```bash
setenv bootdelay 5
# I have allready a boot.scr on my mmc in the root of partition 3
setenv bootcmd 'load mmc 0:3 ${scriptaddr} boot.scr; source ${scriptaddr}'
# save env varaible
saveenv
# reboot, auto boot will work
reset
```
