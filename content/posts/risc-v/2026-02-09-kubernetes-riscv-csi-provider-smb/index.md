---
date: 2026-02-09
author: Bas Magré
categories: ["RISC-V"]
tags: ["kubernetes", "RISC-V", "k0s"]
title: CSI provider SMB for RISC-V Kubernetes cluster
draft: false
---
## Intro

On `FOSDEM 2026` I say a presentation from `Tom Wieczorek` on RISC-V support for `k0s`. k0s is the simple, solid & certified Kubernetes distribution that works on any infrastructure: bare-metal, on-premises, edge, IoT, public & private clouds. It's 100% open source & free. You can now compile and run it for RISC-V 😃, it has no binaries yet on the release files (no RISC-V runners on github 😐 ). K0s is very empty after the default setup. k3s has default a csi provider for local storage, but k0s doesn't. So I thought, how hard can it be, creating the csi provider for RISC-V nodes.

## Choice SMB of ISCSI

I have ISCSI and SMB on my network (synology nas). SMB is a microsoft protocol and has not the linux file permissions, so I thought first: I will compile the [csi for iscsi](https://github.com/kubernetes-csi/csi-driver-iscsi), but there is (still) no official release. So I started with the [csi for smb](https://github.com/kubernetes-csi/csi-driver-smb).

I soon discovered that the Docker images I wanted to create for RISC-V were all based on Debian bookworm, which didn't support RISC-V. So I patched the Docker files so they used a different base image (Debian trixie) for only RISC-V.

For some projects, I also had to patch the Makefiles, but usually, the modification the dockerfile only for RISC-V was enough!

## Project

I created a new github repo for my project: [k8s-csi-driver-riscv64](https://github.com/Opvolger/k8s-csi-driver-riscv64). It is not more than some patches and a makefile. It build docker images and push them. You can set your docker username or repo and username as variable, login with docker and start the build.

## Images

All the images needed for a working CSI provider (SMB) in Kubernetes are now present under [my user on docker](https://hub.docker.com/u/opvolger).

## Install the CSI provider on your cluster

On the project [readme-file](https://github.com/Opvolger/k8s-csi-driver-riscv64/blob/master/README.md) can you see how you can install the helm-chart for the csi provider (SMB).

## It is working

Here you see (debug kernel options, riscv64 with serial output)

```bash
sfvf2lite login: opvolger
Password: 
Linux sfvf2lite 6.19.0 #4 SMP PREEMPT_DYNAMIC Wed Feb 11 17:55:54 CET 2026 riscv64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
opvolger@sfvf2lite:~$ [   47.494639] kube-bridge: port 1(vethdc1c21c8) entered blocking state
[   47.515393] kube-bridge: port 1(vethdc1c21c8) entered disabled state
[   47.544599] vethdc1c21c8: entered allmulticast mode
[   47.558788] vethdc1c21c8: entered promiscuous mode
[   47.565077] kube-bridge: port 2(veth51f3ed1e) entered blocking state
[   47.579886] kube-bridge: port 2(veth51f3ed1e) entered disabled state
[   47.588358] veth51f3ed1e: entered allmulticast mode
[   47.604744] veth51f3ed1e: entered promiscuous mode
[   47.668459] kube-bridge: port 1(vethdc1c21c8) entered blocking state
[   47.674916] kube-bridge: port 1(vethdc1c21c8) entered forwarding state
[   47.754553] kube-bridge: port 2(veth51f3ed1e) entered blocking state
[   47.761010] kube-bridge: port 2(veth51f3ed1e) entered forwarding state
[   71.231896] CIFS: No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1) specify vers=1.0 on mount.
[   71.257182] CIFS: enabling forceuid mount option implicitly because uid= option is specified
[   71.265666] CIFS: enabling forcegid mount option implicitly because gid= option is specified
[   71.274146] CIFS: Attempting to mount //192.168.2.203/kubernetes
```

🥳
