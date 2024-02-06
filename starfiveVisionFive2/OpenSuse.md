# Install OpenSuse Tumbleweed

Download
[cd-boot-images-riscv64_10_all.deb](http://mirrors.kernel.org/ubuntu/pool/main/c/cd-boot-images-riscv64/cd-boot-images-riscv64_10_all.deb)

```bash
wget http://mirrors.kernel.org/ubuntu/pool/main/c/cd-boot-images-riscv64/cd-boot-images-riscv64_10_all.deb
sudo mount /dev/sdb1 /home/opvolger/mnt
sudo cp ~/Downloads/SF2_2023_11_20/ubuntu/usr/share/cd-boot-images-riscv64/tree/EFI/boot/bootriscv64.efi /home/opvolger/mnt/EFI/BOOT/bootriscv64.efi
```

cp vmlinuz-6.1.31+ System and dtb + libs

```bash
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/dtb-6.1.31+ /run/media/opvolger/ROOT/boot/
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/vmlinuz-6.1.31+ /run/media/opvolger/ROOT/boot/
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/System.map-6.1.31+ /run/media/opvolger/ROOT/boot/
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/initrd.img-6.1.31+ /run/media/opvolger/ROOT/boot/
sudo cp /home/opvolger/Downloads/SF2_2023_11_20/opensuse2/initrd/usr/lib/modules/6.1.31+/ /run/media/opvolger/ROOT/usr/lib/modules -R
```

edit grub2.cfg

```bash
sudo nano /run/media/opvolger/ROOT/boot/grub2/grub.cfg
```

edit /etc/fstab

```bash
sudo nano /run/media/opvolger/ROOT/etc/fstab
```

```bash
sudo nano /run/media/opvolger/ROOT/etc/grub.d/40_custom
```

```ini
menuentry 'openSUSE Tumbleweed, with Linux 6.1.31+' {
                load_video
                set gfxpayload=keep
                insmod gzio
                insmod part_gpt
                insmod ext2
                search --no-floppy --fs-uuid --set=root 1a05dd52-4f43-495e-8de1-e6372d24d24d
                echo    'Loading Linux 6.1.31+'
                linux   /boot/vmlinuz-6.1.31+ root=/dev/mmcblk1p3  ro  efi=debug earlycon console=ttyS0,115200n8
                echo    'Loading devicetree 6.1.31+'
                devicetree      /boot/dtb-6.1.31+
}
```

Login root/linux

Update Grub + install kde + codecs

```bash
useradd opvolger
passwd opvolger
grub2-mkconfig -o /boot/grub2/grub.cfg
zypper install -t pattern kde kde_plasma
zypper install opi neofetch chromium nano
opi codecs
```
