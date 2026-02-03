---
draft: true
---
## Intro

For work I was setting up Jenkins in Kubernetes and was wondering, is this also possible for RISC-V now?

Java applications can run on RISC-V, so Jenkins shouldn't be a problem.
I've seen Docker working and even saw an article of unofficial k3s build for Kubernetes.
There's a Helm-chart for deploying Jenkins in Kubernetes.

How hard can it be?

## RISC-V Board

I now have three VisionFive 2s from StarFive.

I had already ordered one during the Kickstarter a few years ago. With the Lite version, I ordered another one. Shortly after, StarFive contacted me to ask if I wanted a Lite for my projects. So that brought my total to three.

3 is also a nice number to build a cluster with

## Status Kubernetes for RISC-V

Unfortunately, there is no official support for RISC-V in Kubernetes from the Kubernetes project yet.
[url](https://github.com/kubernetes/kubernetes/issues/132570#issuecomment-3055208610)

But I did find some Kubernetes projects that looked at RISC-V.

### Solokube

[url](https://www.sokube.io/)

Yes! There is [Solokube](https://www.sokube.io/), but that only works for a single node. I want a multi node cluster.

### Talos

[url](https://www.talos.dev/)
[url](https://github.com/pl4nty/talos)

### k3s

[url](https://github.com/CARV-ICS-FORTH/kubernetes-riscv64)
[url](https://github.com/k3s-io/k3s/pull/7778)
[url](https://github.com/CARV-ICS-FORTH/k3s/tree/riscv64-release-20241024)
[url](https://github.com/k3s-io/k3s/compare/main...CARV-ICS-FORTH:k3s:riscv64-release-20241024)

But after some searching around, I found this [pull-request](https://github.com/k3s-io/k3s/pull/7778) on k3s. That let me to this [github repo](https://github.com/CARV-ICS-FORTH/k3s).

Since I'm already a little familiar with k3s, I chose this project to create my RISC-V cluster.

So I forked it, created a new branch, pulled the latest changes from k3s main and merged his release branch in it. This worked! (after one little fix). So I created my own k3s-riscv64 bin file! See my [repo](https://github.com/opvolger/k3s).

## Installing k3s

To install the cluster, I first tried my version of k3s under the Debian version from StarFive. But, this returned all sorts of errors; apparently, some components in the kernel were missing. But which ones?

I know there was a script to check for missing kernel modules for Docker. It's in the Docker source code.

But apparently, you just have this check in the k3s installation file.

So, I ended up creating my own kernel and installing Debian Trixie with it. I did this using the source code for 6.19. Yes, this is still a release candidate. But everything for the StarFive VisionFive 2 Lite is now included. Except for the GPU drivers.

I kept this setup simple. It's not really a high-availability cluster. Just one master with two agents.

## Jenkins

Oke, we have a cluster running. Now we need to install Jenkins on it.

Fortunately, I can use the existing Helm chart to install Jenkins. But, Jenkins doesn't have any RISC-V Docker images yet. But it looks like they're working on it.

[url](https://community.jenkins.io/t/platform-sig-december-02-2025/35903)

But I managed to build the docker images on my RISC-V boards.

I still ran into one major hurdle. But I was able to solve that by installing the newer Docker engine from Debian SID.

helm uninstall jenkins -n jenkins
helm install jenkins jenkins/jenkins -n jenkins --values values.yaml
