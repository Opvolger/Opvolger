---
date: 2025-12-19
author: Bas Magré
---
# StarFive VisionFive 2 Lite - Kubernetes cluster

I have now 3 StarFive VisionFive 2 (Lite).

- StarFive VisionFive 2 (kickstarter long time ago)
- StarFive VisionFive 2 Lite (kickstarter short time ago)
- StarFive VisionFive 2 Lite (send to my from StarFive, THNX!)

I already had ordered my `StarFive VisionFive 2 Lite` and StarFive contacted me, if I wanted a board for testing and reviewing. So I said, "I've already ordered one." But StarFive wanted to send me one anyway. "That's great," I said, "then I can create a Kubernetes cluster." That's how this challenge came about.

## Is there a out of the box kubernetes for RISC-V?

### Solokube

Yes! There is [Solokube](https://www.sokube.io/), but that only works for a single node. I want a multi node cluster.

### k3s

But after some searching around, I found this [pull-request](https://github.com/k3s-io/k3s/pull/7778) on k3s. That let me to this [github repo](https://github.com/CARV-ICS-FORTH/k3s). So I forked it, created a new branch, pulled the latest changes from k3s main and merged his release branch in it. This worked! (after one little fix). So I created my own k3s-riscv64 bin file! See my [repo](https://github.com/opvolger/k3s).

## Running k3s on my StarFive VisionFive 2 Lite

First i tried the [StarFive Debian image](https://github.com/starfive-tech/Debian/releases). I copied the binary file and and and... It didn't work :\(

I known about this script [check-config.sh](https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh) from docker. Here you can check if your kernel has all the options needed to run docker. So I found out about this command `./k3s-riscv64 check-config`.

```bash
cat: /sys/kernel/security/apparmor/profiles: No such file or directory

Verifying binaries in /var/lib/rancher/k3s/data/b43a475215976c5e56ad3e2fbc248ae845a7b93a49d328091377e8efc6fe5981/bin:
- sha256sum: good
- links: good

System:
- /var/lib/rancher/k3s/data/b43a475215976c5e56ad3e2fbc248ae845a7b93a49d328091377e8efc6fe5981/bin/aux/iptables: unknown version: 
- swap: disabled
- routes: ok

Limits:
- /proc/sys/kernel/keys/root_maxkeys: 1000000

info: reading kernel config from /proc/config.gz ...

Generally Necessary:
- cgroup hierarchy: cgroups V2 mounted, cpu|cpuset|memory controllers status: good
- CONFIG_NAMESPACES: enabled
- CONFIG_NET_NS: enabled
- CONFIG_PID_NS: enabled
- CONFIG_IPC_NS: enabled
- CONFIG_UTS_NS: enabled
- CONFIG_CGROUPS: enabled
- CONFIG_CGROUP_PIDS: enabled
- CONFIG_CGROUP_CPUACCT: enabled
- CONFIG_CGROUP_DEVICE: enabled
- CONFIG_CGROUP_FREEZER: enabled
- CONFIG_CGROUP_SCHED: enabled
- CONFIG_CPUSETS: enabled
- CONFIG_MEMCG: enabled
- CONFIG_SECCOMP: enabled
- CONFIG_KEYS: enabled
- CONFIG_VETH: enabled
- CONFIG_BRIDGE: enabled
- CONFIG_BRIDGE_NETFILTER: enabled
- CONFIG_IP_NF_FILTER: enabled
- CONFIG_IP_NF_TARGET_MASQUERADE: enabled
- CONFIG_IP_NF_TARGET_REJECT: enabled
- CONFIG_NETFILTER_XT_MATCH_ADDRTYPE: enabled
- CONFIG_NETFILTER_XT_MATCH_CONNTRACK: enabled
- CONFIG_NETFILTER_XT_MATCH_IPVS: enabled
- CONFIG_NETFILTER_XT_MATCH_COMMENT: missing (fail)
- CONFIG_NETFILTER_XT_MATCH_MULTIPORT: enabled
- CONFIG_NETFILTER_XT_MATCH_STATISTIC: missing (fail)
- CONFIG_IP_NF_NAT: enabled
- CONFIG_NF_NAT: enabled
- CONFIG_POSIX_MQUEUE: enabled

Optional Features:
- CONFIG_USER_NS: enabled
- CONFIG_BLK_CGROUP: enabled
- CONFIG_BLK_DEV_THROTTLING: enabled
- CONFIG_CGROUP_PERF: enabled
- CONFIG_CGROUP_HUGETLB: enabled
- CONFIG_NET_CLS_CGROUP: enabled
- CONFIG_CGROUP_NET_PRIO: enabled
- CONFIG_CFS_BANDWIDTH: enabled
- CONFIG_FAIR_GROUP_SCHED: enabled
- CONFIG_RT_GROUP_SCHED: missing
- CONFIG_IP_NF_TARGET_REDIRECT: enabled
- CONFIG_IP_SET: missing
- CONFIG_IP_VS: enabled
- CONFIG_IP_VS_NFCT: enabled
- CONFIG_IP_VS_PROTO_TCP: enabled
- CONFIG_IP_VS_PROTO_UDP: enabled
- CONFIG_IP_VS_RR: enabled
- CONFIG_EXT4_FS: enabled
- CONFIG_EXT4_FS_POSIX_ACL: enabled
- CONFIG_EXT4_FS_SECURITY: enabled
- Network Drivers:
  - "overlay":
    - CONFIG_VXLAN: enabled
      Optional (for encrypted networks):
      - CONFIG_CRYPTO: enabled
      - CONFIG_CRYPTO_AEAD: enabled
      - CONFIG_CRYPTO_GCM: enabled
      - CONFIG_CRYPTO_SEQIV: enabled
      - CONFIG_CRYPTO_GHASH: enabled
      - CONFIG_XFRM: enabled
      - CONFIG_XFRM_USER: enabled
      - CONFIG_XFRM_ALGO: enabled
      - CONFIG_INET_ESP: enabled
      - CONFIG_INET_XFRM_MODE_TRANSPORT: missing
- Storage Drivers:
  - "overlay":
    - CONFIG_OVERLAY_FS: enabled

STATUS: 2 (fail)
```

I am missing `CONFIG_NETFILTER_XT_MATCH_COMMENT` and `CONFIG_NETFILTER_XT_MATCH_STATISTIC`. So i need to build my own kernel with that options enabled!

I already have done a howto compiling a kernel for the `StarFive VisionFive 2 Lite` [here](LiteUBootKernel.md). But almost everything is already in the kernel 6.19-rc1 (latest kernel when I was making this), Only a patch for the [PCIe is missing](https://patchwork.kernel.org/project/linux-pci/patch/20251204064956.118747-1-hal.feng@starfivetech.com/).

So I compiled my own kernel 6.19-rc1 with the patch and all the options needed.

## install k3s

```bash
wget https://raw.githubusercontent.com/Opvolger/k3s/refs/heads/release-1.34-riscv/install.sh
chmod +x install.sh
sudo GITHUB_URL=https://github.com/Opvolger/k3s/releases INSTALL_K3S_VERSION=v1.34-1 ./install.sh
```

## fix config

.kube/config

```bash
kubectl get pods -A
```

## install Jenkins helm-chart

See the github repo from [jenkins helm-chart](https://github.com/jenkinsci/helm-charts)

```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
kubectl create namespace jenkins
helm install jenkins jenkins/jenkins -n jenkins
```

```ini
Failed to pull image "docker.io/kiwigrid/k8s-sidecar:1.30.7": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/kiwigrid/k8s-sidecar:1.30.7": no match for platform in manifest: not found
```

```ini
Failed to pull image "docker.io/jenkins/jenkins:2.528.3-jdk21": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/jenkins/jenkins:2.528.3-jdk21": no match for platform in manifest: not found
```

[The project](https://github.com/kiwigrid/k8s-sidecar) has no risc-v support, we need to build/push it

On the risc-v machine:

```bash
git clone https://github.com/kiwigrid/k8s-sidecar.git
cd k8s-sidecar
git checkout 1.30.7
sudo docker build . -t opvolger/k8s-sidecar:1.30.7
sudo docker push opvolger/k8s-sidecar:1.30.7
```

create a values.yaml file I added a ingress configuration and changed the docker image location

```yaml
# kubectl create namespace jenkins
# helm pull jenkins/jenkins
# helm install jenkins jenkins/jenkins -n jenkins --values values.yaml
# helm upgrade jenkins jenkins/jenkins -n jenkins --values values.yaml
# helm uninstall jenkins -n jenkins

global:
  domain: k8s.riscv.net

jenkinsUrlProtocol: "http"

controller:
  probes:
    startupProbe:
      failureThreshold: 20
      periodSeconds: 15
      timeoutSeconds: 30
    livenessProbe:
      failureThreshold: 10
      initialDelaySeconds: 30
    readinessProbe:
      failureThreshold: 10
      initialDelaySeconds: 30
  image:
    repository: opvolger/jenkins
  sidecars:
    configAutoReload:
      enabled: false # this is crashing
      image:
        repository: opvolger/k8s-sidecar
  ingress:
    enabled: true
    hostName: "{{ .Release.Name }}.{{ .Values.global.domain }}"
```

On your own pc (intel/arm based)

```bash
docker pull jenkins/jenkins:2.528.3-jdk21
docker history jenkins/jenkins:2.528.3-jdk21 --no-trunc | grep ARG
# now you can see the build ARG's needed to build the risc-v version
```

We need to build Jenkins for risc-v

```bash
git clone https://github.com/jenkinsci/docker.git
cd docker
git checkout 2.504.3

sudo docker build -f debian/trixie/hotspot/Dockerfile . \
--build-arg JENKINS_VERSION=2.528.3 \
--build-arg WAR_SHA=bfa31f1e3aacebb5bce3d5076c73df97bf0c0567eeb8d8738f54f6bac48abd74 \
--build-arg WAR_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/2.528.3/jenkins-war-2.528.3.war \
--build-arg COMMIT_SHA=1d22f3716cc2a5baeedeb636a006c4c38d35ce4c \
--build-arg PLUGIN_CLI_VERSION=2.13.2 \
--build-arg TRIXIE_TAG=20251208 \
--build-arg JAVA_VERSION=21.0.9_10 \
--build-arg TARGETARCH=riscv64 \
-t opvolger/jenkins:2.528.3-jdk21 --progress plain
```

But it will give an error `0.839 ERROR: unmanaged jlink version pattern`
This is because jlink has still a bug for RISC-V, you can see that with `jlink --version`

```ini
0.843 [0.013s][error][os] Syscall: RISCV_FLUSH_ICACHE not available; error='Operation not permitted' (errno=EPERM)
```

This is fixed in in [moby](https://github.com/moby/moby/pull/43553/files). But that version of docker.io is not in debian trixie. So we need to update docker.io. I updated with the version from `sid`.

Added this in `/etc/apt/sources.list`

```ini
deb http://deb.debian.org/debian/ sid main
```

```bash
sudo -i
nano /etc/apt/sources.list
apt update
apt install docker.io
```

now remove the line in `/etc/apt/sources.list` again

```bash
nano /etc/apt/sources.list
apt update
# leave the this with Ctrl + D
```

Now run the docker build again.

```bash
sudo docker build -f debian/trixie/hotspot/Dockerfile . \
--build-arg JENKINS_VERSION=2.528.3 \
--build-arg WAR_SHA=bfa31f1e3aacebb5bce3d5076c73df97bf0c0567eeb8d8738f54f6bac48abd74 \
--build-arg WAR_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/2.528.3/jenkins-war-2.528.3.war \
--build-arg COMMIT_SHA=1d22f3716cc2a5baeedeb636a006c4c38d35ce4c \
--build-arg PLUGIN_CLI_VERSION=2.13.2 \
--build-arg TRIXIE_TAG=20251208 \
--build-arg JAVA_VERSION=21.0.9_10 \
--build-arg TARGETARCH=riscv64 \
-t opvolger/jenkins:2.528.3-jdk21 --progress plain
sudo docker push opvolger/jenkins:2.528.3-jdk21
```

## Kubernetes job

```ini
Failed to pull image "jenkins/inbound-agent:3345.v03dee9b_f88fc-1": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/jenkins/inbound-agent:3345.v03dee9b_f88fc-1": no match for platform in manifest: not found
```

```bash
git clone https://github.com/jenkinsci/docker-agent.git

cd docker-agent
git checkout 3345.v03dee9b_f88fc-1
sudo docker build -f debian/Dockerfile . \
--build-arg JAVA_VERSION=21.0.9_10 \
-t opvolger/inbound-agent:3345.v03dee9b_f88fc-1 --progress plain
sudo docker push opvolger/inbound-agent:3345.v03dee9b_f88fc-1
```

```groovy
// Uses Declarative syntax to run commands inside a container.
pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jnlp
    image: opvolger/inbound-agent:3345.v03dee9b_f88fc-1
  - name: shell
    image: ubuntu
    command:
    - sleep
    args:
    - infinity
    securityContext:
      # ubuntu runs as root by default, it is recommended or even mandatory in some environments (such as pod security admission "restricted") to run as a non-root user.
      runAsUser: 1000
'''
            defaultContainer 'shell'
            retries 2
        }
    }
    stages {
        stage('Main') {
            steps {
                sh 'uname -a'
            }
        }
    }
}

```