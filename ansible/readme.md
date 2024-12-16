# Create bootable partitions from RISCV

Start with a SD-card with no partitions and GTP-partision table!

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
- starfive-visionfive2-create-boot-partitions.yaml: creates boot partitions + copy kernel
- starfive-visionfive2-update-boot.yaml: updates U-boot, OpenSBI and the kernel on the boot partitions
- starfive-visionfive2-update-kernel.yaml: updates the kernel and copied to the bootfs

- starfive-visionfive2-opensuse.yaml: creates rootfs partition + create boot.src
- starfive-visionfive2-ubuntu-20-10.yaml: creates rootfs partition + create boot.src

- starfive-visionfive2-opensuse-all.yaml: Compiles U-boot, OpenSBI and the kernel + creates boot partitions + copy kernel + creates rootfs partition + create boot.src
- starfive-visionfive2-ubuntu-20-10-all.yaml: Compiles U-boot, OpenSBI and the kernel + creates boot partitions + copy kernel + creates rootfs partition + create boot.src

## Switch from Ubuntu to OpenSuse

Delete only 4th partition of the SD-card and run the other playbook: starfive-visionfive2-opensuse.yaml vs starfive-visionfive2-ubuntu-20-10.yaml

## Ubuntu

First login: ubuntu/ubuntu

Change password and install kde

```bash
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt update
sudo apt install kde-standard firefox
```

## OpenSUSE

Hit `Ctrl + Alt + F3` and login as `root` with password `linux`.

```bash
Welcome to openSUSE Tumbleweed 20241117 - Kernel 6.6.36+ (ttyS0).

end0: 192.168.2.28 2a02:a447:277b:1:e172:a638:be8a:114c
end1:  


fedora login: root
Password: 
Have a lot of fun...
2a02-a447-277b-1-e172-a638-be8a-114c:~ #
```

now create a user! I create a user opvolger.

```bash
$ useradd opvolger
# set password
$ passwd opvolger
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: password updated successfully
# install wheel group
$ zypper install system-group-wheel
Retrieving repository 'Open H.264 Codec (openSUSE Tumbleweed)' metadata ..[done]
Building repository 'Open H.264 Codec (openSUSE Tumbleweed)' cache .......[done]
Retrieving repository 'openSUSE-Tumbleweed-Oss' metadata .................[done]
Building repository 'openSUSE-Tumbleweed-Oss' cache ......................[done]
Retrieving repository 'openSUSE-Tumbleweed-Update' metadata ..............[done]
Building repository 'openSUSE-Tumbleweed-Update' cache ...................[done]
Loading repository data...
Reading installed packages...
Resolving package dependencies...

The following NEW package is going to be installed:
  system-group-wheel

1 new package to install.

Package download size:     8.6 KiB

Package install size change:
            |        38 B  required by packages that will be installed
      38 B  |  -      0 B  released by packages that will be removed

Backend:  classic_rpmtrans
Continue? [y/n/v/...? shows all options] (y): 
Retrieving: system-group-wheel-20170617-26.1.noarch (openSUSE-Tumbleweed-Oss)
                                                            (1/1),   8.6 KiB
Retrieving: system-group-wheel-20170617-26.1.noarch.rpm ..................[done]

Checking for file conflicts: .............................................[done]
/usr/bin/systemd-sysusers --replace=/usr/lib/sysusers.d/system-group-wheel.conf -
Creating group 'wheel' with GID 469.
(1/1) Installing: system-group-wheel-20170617-26.1.noarch ................[done]
Running post-transaction scripts .........................................[done]
# add user as sudo-er
$ usermod -a -G wheel opvolger
```

Now hit `Ctrl + Alt + F2`. Login with user opvolger and your password.

We will see the Desktop!
