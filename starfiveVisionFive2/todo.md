

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