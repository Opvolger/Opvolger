# Compile kernel

You can't clone repo from xff.cz. Only a bundle

```bash
git clone https://xff.cz/git/linux
Cloning into 'linux'...
remote: /============================= ATTENTION =============================\
remote: |                                                                     |
remote: | Sorry, Linux GIT repository is too large for my puny little server. |
remote: |                                                                     |
remote: | For efficicency purposes I distribute content of my repository via  |
remote: | two GIT bundles available at https://xff.cz/kernels/git/            |
remote: |                                                                     |
remote: | - https://xff.cz/kernels/git/orange-pi-active.bundle                |
remote: |                                                                     |
remote: |   (Small ~10 MiB bundle containing actively supported branches)     |
remote: |                                                                     |
remote: | - https://xff.cz/kernels/git/orange-pi-history.bundle               |
remote: |                                                                     |
remote: |   (Large ~150 MiB bundle containing all my releases back to March   |
remote: |    2017, if you need to reference old code for whatever reason)     |
remote: |                                                                     |
remote: | To apply the bundle to your kernel repository, run:                 |
remote: |                                                                     |
remote: | curl -o .bundle https://xff.cz/kernels/git/orange-pi-active.bundle  |
remote: | git fetch .bundle '+refs/heads/*:refs/remotes/megi/*'               |
remote: |                                                                     |
remote: | The bundles depend on uptodate Linus Torvalds's GIT master branch.  |
remote: | If you don't have a Linux repository, yet, you can clone it from:   |
remote: |
remote: | git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
remote: |
remote: | Best of luck,                                               ~megi   |
remote: |                                                                     |
remote: \============================= ATTENTION =============================/
fatal: unable to access 'https://xff.cz/git/linux/': The requested URL returned error: 403
opvolger@desktop:~/code/kernel_pbp$ ^C
opvolger@desktop:~/code/kernel_pbp$ git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Cloning into 'linux'...
remote: Enumerating objects: 9955531, done.
remote: Counting objects: 100% (32/32), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 9955531 (delta 31), reused 30 (delta 30), pack-reused 9955499
Receiving objects: 100% (9955531/9955531), 2.75 GiB | 14.06 MiB/s, done.


$ curl -o .bundle https://xff.cz/kernels/git/orange-pi-active.bundle
$ git fetch .bundle '+refs/heads/*:refs/remotes/megi/*'
# use tag orange-pi-6.7-20240108-1629
$ cd linux
$ make pinephone_pro_defconfig
$ make CROSS_COMPILE=aarch64-linux-gnu- ARCH=arm64 menuconfig # save and exit
```

update
```ini
#
# Boot options
#
CONFIG_CMDLINE=""
CONFIG_EFI_STUB=y
CONFIG_EFI=y
CONFIG_DMI=y
# end of Boot options
```

```bash
$ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j 16
$ make ARCH=riscv CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=/home/opvolger/code/linux-lts/modules modules_install -j 16 
```
