# K3s on postmarketos

## flash mobile phone

[here](https://wiki.postmarketos.org/wiki/Xiaomi_POCO_F1_(xiaomi-beryllium))

## Install pmbootstrap

https://wiki.postmarketos.org/wiki/User_talk:Docker

## custom kernel

pmbootstrap init

pmbootstrap kconfig edit linux-postmarketos-qcom-sdm845

`> Networking support > Networking options > Network packet filtering framework (Netfilter) > Core Netfilter Configuration`

enable: <M> "multiport" Multiple port match support

-save-

```bash
pmbootstrap build linux-postmarketos-qcom-sdm845 --force
```

kernel apk is in `~/.local/var/pmbootstrap/packages/v22.12/aarch64/linux-postmarketos-qcom-sdm845-6.1.0-r0.apk`


```bash
$ scp ~/.local/var/pmbootstrap/packages/v22.12/aarch64/linux-postmarketos-qcom-sdm845-6.1.0-r0.apk user@172.16.42.1:/home/user/linux-postmarketos-qcom-sdm845-6.1.0-r0.apk
user@172.16.42.1's password: 
linux-postmarketos-qcom-sdm845-6.1.0-r0.apk                            100%   19MB  28.7MB/s   00:00
```

```bash
$ ssh user@172.16.42.1
user@172.16.42.1's password: 
Welcome to postmarketOS! o/

This distribution is based on Alpine Linux.
First time using postmarketOS? Make sure to read the cheatsheet in the wiki:

-> https://postmarketos.org/cheatsheet

You may change this message by editing /etc/motd.
$ sudo -i
[sudo] password for user:
$ apk add -u /home/user/linux-postmarketos-qcom-sdm845-6.1.0-r0.apk  --allow-untrusted
```
