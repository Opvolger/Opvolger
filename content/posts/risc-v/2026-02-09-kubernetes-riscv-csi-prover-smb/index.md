---
date: 2026-02-09
author: Bas Magré
categories: ["RISC-V"]
tags: ["kubernetes", "RISC-V"]
title: StarFive VisionFive 2 Lite - Kubernetes cluster
draft: false
---
## Intro

On FOSDEM 2026 I say a presentation from `Tom Wieczorek` on RISC-V support for k0s. k0s is the simple, solid & certified Kubernetes distribution that works on any infrastructure: bare-metal, on-premises, edge, IoT, public & private clouds. It's 100% open source & free. You can now compile and run it for RISC-V, it has no binaries yet on the release files (no RISC-V runners on github :( ). K0s is very empty after the default setup. k3s has default a csi provider for local storage, but k0s doesn't. So I thought, how hard can it be, creating the csi provider for RISC-V nodes.

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
