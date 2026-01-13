---
draft: true
---

# Info

# https://github.com/carlosedp/riscv-bringup/blob/master/Ubuntu-Rootfs-Guide.md

```bash
# install prerequisites
sudo apt install debootstrap qemu qemu-user-static binfmt-support dpkg-cross --no-install-recommends
# generate minimal bootstrap rootfs
sudo debootstrap --arch=riscv64 --foreign jammy ./temp-rootfs http://ports.ubuntu.com/ubuntu-ports
# chroot into the rootfs we just created
sudo chroot temp-rootfs /bin/bash
# run 2nd stage of deboostrap
/debootstrap/debootstrap --second-stage
# add package sources
cat >/etc/apt/sources.list <<EOF
deb http://ports.ubuntu.com/ubuntu-ports jammy main restricted

deb http://ports.ubuntu.com/ubuntu-ports jammy-updates main restricted

deb http://ports.ubuntu.com/ubuntu-ports jammy universe
deb http://ports.ubuntu.com/ubuntu-ports jammy-updates universe

deb http://ports.ubuntu.com/ubuntu-ports jammy multiverse
deb http://ports.ubuntu.com/ubuntu-ports jammy-updates multiverse

deb http://ports.ubuntu.com/ubuntu-ports jammy-backports main restricted universe multiverse

deb http://ports.ubuntu.com/ubuntu-ports jammy-security main restricted
deb http://ports.ubuntu.com/ubuntu-ports jammy-security universe
deb http://ports.ubuntu.com/ubuntu-ports jammy-security multiverse
EOF
# update and install some packages
apt-get update
apt-get install --no-install-recommends -y util-linux haveged openssh-server systemd kmod initramfs-tools conntrack ebtables ethtool iproute2 iptables mount socat ifupdown iputils-ping vim dhcpcd5 neofetch sudo chrony
# optional for zram
apt-get install zram-config
systemctl enable zram-config
# Create base config files
mkdir -p /etc/network
cat >>/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

cat >/etc/resolv.conf <<EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

# write text to fstab (this is with swap enabled if you want to disable it just put a # before the swap line)
cat >/etc/fstab <<EOF
# <file system>	<mount pt>	<type>	<options>	<dump>	<pass>
/dev/root	/		ext4	rw,noauto	0	1
proc		/proc		proc	defaults	0	0
devpts		/dev/pts	devpts	defaults,gid=5,mode=620,ptmxmode=0666	0	0
tmpfs		/dev/shm	tmpfs	mode=0777	0	0
tmpfs		/tmp		tmpfs	mode=1777	0	0
tmpfs		/run		tmpfs	mode=0755,nosuid,nodev,size=64M	0	0
sysfs		/sys		sysfs	defaults	0	0
/dev/mmcblk0p4  none            swap    sw              0       0
EOF
# set hostname
echo "milkvduo-ubuntu" > /etc/hostname
# set root passwd
echo "root:riscv" | chpasswd
# enable root login through ssh
sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
# exit chroot
exit
sudo tar -cSf Ubuntu-jammy-rootfs.tar -C temp-rootfs .
gzip Ubuntu-jammy-rootfs.tar
rm -rf temp-rootfs
```

```bash
docker run --rm -ti --privileged --cap-add=SYS_ADMIN --security-opt apparmor:unconfined -v $(pwd):/build ubuntu:22.04 /bin/bash
```

```bash
sudo sfdisk --dump /dev/sdb > sdb.bkp
cp sdb.bkp sdb.new
nano sdb.new
sudo sfdisk /dev/sdb < sdb.new
sudo sfdisk /dev/sdb < sdb.bkp


cat /dev/urandom > /dev/fb0
cat /dev/zero > /dev/fb0
cat /proc/cmdline
# One liner pixel draw (yellow on x:y=200:100, if width is 1920):
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((100 * 1920 + 200)) >/dev/fb0

# H

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 100)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((102 * 1920 + 100)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 100)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((104 * 1920 + 100)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 100)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 101)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 102)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 103)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 104)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((102 * 1920 + 104)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 104)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((104 * 1920 + 104)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 104)) > /dev/fb0

# E

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 106)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((102 * 1920 + 106)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 106)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((104 * 1920 + 106)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 106)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 107)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 107)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 107)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 108)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 108)) > /dev/fb0

# L

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 111)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((102 * 1920 + 111)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 111)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((104 * 1920 + 111)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 111)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 112)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 113)) > /dev/fb0

# E

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 116)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((102 * 1920 + 116)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 116)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((104 * 1920 + 116)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 116)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 117)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 117)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 117)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 118)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 118)) > /dev/fb0

# N

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 121)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((102 * 1920 + 121)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 121)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((104 * 1920 + 121)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 121)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((102 * 1920 + 122)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 123)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((104 * 1920 + 124)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((101 * 1920 + 125)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((102 * 1920 + 125)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((103 * 1920 + 125)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((104 * 1920 + 125)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((105 * 1920 + 125)) > /dev/fb0

# hartje


printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((113 * 1920 + 111)) > /dev/fb0

printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((112 * 1920 + 112)) > /dev/fb0
printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((113 * 1920 + 112)) > /dev/fb0
printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((114 * 1920 + 112)) > /dev/fb0

printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((113 * 1920 + 113)) > /dev/fb0
printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((114 * 1920 + 113)) > /dev/fb0
printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((115 * 1920 + 113)) > /dev/fb0

printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((112 * 1920 + 114)) > /dev/fb0
printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((113 * 1920 + 114)) > /dev/fb0
printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((114 * 1920 + 114)) > /dev/fb0

printf "\xF0\xF0\xF0\xF0" | dd bs=4 seek=$((113 * 1920 + 115)) > /dev/fb0


# B

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((122 * 1920 + 106)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((123 * 1920 + 106)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((124 * 1920 + 106)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((125 * 1920 + 106)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((126 * 1920 + 106)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((122 * 1920 + 107)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((124 * 1920 + 107)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((126 * 1920 + 107)) > /dev/fb0


printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((123 * 1920 + 108)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((125 * 1920 + 108)) > /dev/fb0

# A

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((125 * 1920 + 111)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((126 * 1920 + 111)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((123 * 1920 + 112)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((124 * 1920 + 112)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((122 * 1920 + 113)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((124 * 1920 + 113)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((123 * 1920 + 114)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((124 * 1920 + 114)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((125 * 1920 + 115)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((126 * 1920 + 115)) > /dev/fb0

# S

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((122 * 1920 + 118)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((123 * 1920 + 118)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((124 * 1920 + 118)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((126 * 1920 + 118)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((122 * 1920 + 119)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((124 * 1920 + 119)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((126 * 1920 + 119)) > /dev/fb0

printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((122 * 1920 + 120)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((124 * 1920 + 120)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((125 * 1920 + 120)) > /dev/fb0
printf "\x00\xFF\xFF\x00" | dd bs=4 seek=$((126 * 1920 + 120)) > /dev/fb0

```

```ini
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y

CONFIG_DRM_UDL=y
CONFIG_FB_UDL=y

# and add at the end:
CONFIG_CGROUPS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_CGROUP_SCHED=y
CONFIG_NAMESPACES=y
CONFIG_OVERLAY_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EPOLL=y
CONFIG_IPV6=y
CONFIG_FANOTIFY=y

# optional (enable zram):
CONFIG_ZSMALLOC=y
CONFIG_ZRAM=y
```


use docker sdk v2

docker run --privileged -itd --name duodocker -v $(pwd):/home/work milkvtech/milkv-duo:latest /bin/bash
docker exec -it 044 bash

cd /home/work/

./build.sh

cd /home/work/linux_5.10/build/sg2000_milkv_duos_musl_riscv64_sd

export PATH="/home/work/host-tools/gcc/riscv64-linux-musl-x86_64/bin/:$PATH"
make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-musl- -j 16

uImage_addr=0x81800000
setenv kernel_comp_addr_r 0x85800000
setenv kernel_comp_size 0x87800000
update_addr=0x9fe00000
load mmc 0:1 ${uImage_addr} Image.gz
load mmc 0:1 ${update_addr} sg2000_milkv_duos_musl_riscv64_sd.dtb
setenv bootargs 'console=ttyS0,115200 root=/dev/mmcblk0p3 rootwait rw earlycon loglevel=7 selinux=0'
booti $uImage_addr - $update_addr