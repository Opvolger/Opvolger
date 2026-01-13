---
date: 2025-12-19
author: Bas Magré
categories: ["RISC-V"]
tags: ["starfive-visionfive-2", "RISC-V"]
title: StarFive VisionFive 2 Lite - Kubernetes cluster
draft: false
---
## Intro

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

## Install k3s

For the server node

```bash
# On the one of my risc-v machine with ip 192.168.2.30:
wget https://raw.githubusercontent.com/Opvolger/k3s/refs/heads/release-1.34-riscv/install.sh
chmod +x install.sh
sudo GITHUB_URL=https://github.com/Opvolger/k3s/releases INSTALL_K3S_VERSION=v1.34-1 ./install.sh
```

For the other agent nodes, replace the token for the token from the server (`/var/lib/rancher/k3s/server/token`).

```bash
# On the other two of my risc-v machines, that will connect to ip 192.168.2.30:
wget https://raw.githubusercontent.com/Opvolger/k3s/refs/heads/release-1.34-riscv/install.sh
chmod +x install.sh
sudo GITHUB_URL=https://github.com/Opvolger/k3s/releases INSTALL_K3S_VERSION=v1.34-1 INSTALL_K3S_EXEC="agent --server https://192.168.2.30:6443 --token K105aa9e1f8a944fa6f1d8641b3c4e19cf962d943f56168d9441ff749b3014bdbae::server:281ceb4f9e6aaabdd0363c77991bf31e
" ./install.sh
```

## Fix Kube config

Get the `/etc/rancher/k3s/k3s.yaml` from the server node and copy it in your main machine `.kube/config` if you don't have one or merge the configs by hand. Change the ip address to what is the ip of your master node. In my case 192.168.2.30

My `.kube/config` looks something like this. (i renamed the cluster to riscv and had already the clusters local and nipogi).

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0t
    server: https://127.0.0.1:6443
  name: localhost
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk
    server: https://192.168.2.201:6443
  name: nipogi
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJk
    server: https://192.168.2.30:6443
  name: riscv
contexts:
- context:
    cluster: localhost
    user: localhost
  name: localhost
- context:
    cluster: nipogi
    user: nipogi
  name: nipogi
- context:
    cluster: riscv
    user: riscv
  name: riscv
current-context: riscv
kind: Config
preferences: {}
users:
- name: localhost
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJra
    client-key-data: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0t
- name: nipogi
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJrVENDQVR
    client-key-data: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSVBTa
- name: riscv
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJrRENDQVRlZ0F3SUJ
    client-key-data: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSUpNK0NoMksvdWw0YmZRR3E3bnJQN
```

```bash
kubectl get pods -A -o wide
kubectl get nodes -o wide
```

## add DNS to your /etc/hosts

I want to test the ingress of my cluster, so I added a line to my /etc/hosts to simulate that the DNS is working :)

```ini
# Loopback entries; do not change.
# For historical reasons, localhost precedes localhost.localdomain:
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
# See hosts(5) for proper format and other examples:
# 192.168.1.10 foo.mydomain.org foo
# 192.168.1.13 bar.mydomain.org bar
192.168.2.27 jenkins.k8s.riscv.net
```

## Install Jenkins helm-chart

See the github repo from [jenkins helm-chart](https://github.com/jenkinsci/helm-charts)

```bash
# On my main machine
helm repo add jenkins https://charts.jenkins.io
helm repo update
kubectl create namespace jenkins
helm install jenkins jenkins/jenkins -n jenkins
```

It will not start up, there is no RISC-V image (yet).

```bash
# On my main machine
kubectl get pods -o wide -n jenkins
kubectl get event --namespace jenkins --field-selector involvedObject.name=jenkins-0
```

```ini
Failed to pull image "docker.io/kiwigrid/k8s-sidecar:1.30.7": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/kiwigrid/k8s-sidecar:1.30.7": no match for platform in manifest: not found
```

[The project](https://github.com/kiwigrid/k8s-sidecar) has no risc-v support, we need to build/push it

```bash
# On the risc-v machine:
git clone https://github.com/kiwigrid/k8s-sidecar.git
cd k8s-sidecar
git checkout 1.30.7
sudo docker build . -t opvolger/k8s-sidecar:1.30.7
sudo docker push opvolger/k8s-sidecar:1.30.7
```

I started to make a value.yaml for the values I want to change.

```yaml
controller:
  sidecars:
    configAutoReload:
      image:
        repository: opvolger/k8s-sidecar
        tag: 1.30.7
```

So the sidecar container was working, but now we have the next problem, jenkins image has not a risc-v arch image.

```bash
# On my main machine
helm uninstall jenkins -n jenkins
helm install jenkins jenkins/jenkins -n jenkins --values values.yaml
kubectl get pods -o wide -n jenkins
kubectl get event --namespace jenkins --field-selector involvedObject.name=jenkins-0
```

```ini
Failed to pull image "docker.io/jenkins/jenkins:2.528.3-jdk21": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/jenkins/jenkins:2.528.3-jdk21": no match for platform in manifest: not found
```

We need to build Jenkins for risc-v

The arguments to give for building the jenkins image was not complete, so i found some in the [source code](https://github.com/jenkinsci/docker/blob/2.528.3/debian/trixie/hotspot/Dockerfile) and some by getting the ARG from the build on my main machine.

```bash
# On my main machine
docker pull jenkins/jenkins:2.528.3-jdk21
docker history jenkins/jenkins:2.528.3-jdk21 --no-trunc | grep ARG
# now you can see the build ARG's needed to build the risc-v version.
```

```bash
# On the risc-v machine:
git clone https://github.com/jenkinsci/docker.git
cd docker
git checkout 2.528.3

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
This is because jlink has still a "bug" for RISC-V, you can see that with `jlink --version`
It is making a system call that is not permitted.

```ini
0.843 [0.013s][error][os] Syscall: RISCV_FLUSH_ICACHE not available; error='Operation not permitted' (errno=EPERM)
```

This is fixed in in [moby](https://github.com/moby/moby/pull/43553/files). But that version of docker.io is not in debian trixie, what i am using. So we need to update docker.io. I updated with the version from `sid`.

Added this in `/etc/apt/sources.list`

```ini
deb http://deb.debian.org/debian/ sid main
```

```bash
# On the risc-v machine:
sudo -i
nano /etc/apt/sources.list
apt update
apt install docker.io
```

now remove the line in `/etc/apt/sources.list` again

```bash
# On the risc-v machine:
nano /etc/apt/sources.list
apt update
# leave the this with Ctrl + D
```

Now run the docker build again.

```bash
# On the risc-v machine:
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

I updated my values.yaml again with this new image, added username/password for login and an ingress.

```yaml
controller:
  admin:
    username: opvolger
    password: demodemo
  image:
    repository: opvolger/jenkins
    tag: 2.528.3-jdk21
  sidecars:
    configAutoReload:
      image:
        repository: opvolger/k8s-sidecar
        tag: 1.30.7
  ingress:
    enabled: true
    hostName: "jenkins.k8s.riscv.net"
```

```bash
# On my main machine
helm uninstall jenkins -n jenkins
helm install jenkins jenkins/jenkins -n jenkins --values values.yaml
```

It didn't work, the sidecar image was restarting and giving an error:

```bash
# On my main machine
kubectl logs jenkins-0 config-reload -n jenkins
```

The error of the sidecar container:

```bash
{"time": "2026-01-11T19:43:44.750737+00:00", "level": "INFO", "msg": "Starting collector"}
{"time": "2026-01-11T19:43:44.751753+00:00", "level": "INFO", "msg": "No folder annotation was provided, defaulting to k8s-sidecar-target-directory"}
{"time": "2026-01-11T19:43:44.752692+00:00", "level": "INFO", "msg": "Loading incluster config ..."}
{"time": "2026-01-11T19:43:44.756520+00:00", "level": "INFO", "msg": "Config for cluster api at 'https://10.43.0.1:443' loaded."}
{"time": "2026-01-11T19:43:44.757022+00:00", "level": "INFO", "msg": "Unique filenames will not be enforced."}
{"time": "2026-01-11T19:43:44.757446+00:00", "level": "INFO", "msg": "5xx response content will not be enabled."}
{"time": "2026-01-11T19:43:44.859127+00:00", "level": "ERROR", "msg": "FileNotFoundError: [Errno 2] No usable temporary directory found in ['/tmp', '/var/tmp', '/usr/tmp', '/app']", "exc_info": "Traceback (most recent call last):\n  File \"/app/sidecar.py\", line 174, in <module>\n    main()\n    ~~~~^^\n  File \"/app/sidecar.py\", line 136, in main\n    watch_for_changes(method, label, label_value, target_folder, request_url, request_method, request_payload,\n    ~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n                      namespace, folder_annotation, resources, unique_filenames, script, enable_5xx,\n                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n                      ignore_already_processed, resource_name)\n                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n  File \"/app/resources.py\", line 427, in watch_for_changes\n    processes = _start_watcher_processes(current_namespace, folder_annotation, label,\n                                         label_value, request_method, mode, request_payload, resources,\n                                         target_folder, unique_filenames, script, request_url, enable_5xx,\n                                         ignore_already_processed, resource_name)\n  File \"/app/resources.py\", line 460, in _start_watcher_processes\n    proc.start()\n    ~~~~~~~~~~^^\n  File \"/usr/local/lib/python3.14/multiprocessing/process.py\", line 121, in start\n    self._popen = self._Popen(self)\n                  ~~~~~~~~~~~^^^^^^\n  File \"/usr/local/lib/python3.14/multiprocessing/context.py\", line 224, in _Popen\n    return _default_context.get_context().Process._Popen(process_obj)\n           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^\n  File \"/usr/local/lib/python3.14/multiprocessing/context.py\", line 300, in _Popen\n    return Popen(process_obj)\n  File \"/usr/local/lib/python3.14/multiprocessing/popen_forkserver.py\", line 35, in __init__\n    super().__init__(process_obj)\n    ~~~~~~~~~~~~~~~~^^^^^^^^^^^^^\n  File \"/usr/local/lib/python3.14/multiprocessing/popen_fork.py\", line 20, in __init__\n    self._launch(process_obj)\n    ~~~~~~~~~~~~^^^^^^^^^^^^^\n  File \"/usr/local/lib/python3.14/multiprocessing/popen_forkserver.py\", line 51, in _launch\n    self.sentinel, w = forkserver.connect_to_new_process(self._fds)\n                       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^\n  File \"/usr/local/lib/python3.14/multiprocessing/forkserver.py\", line 89, in connect_to_new_process\n    self.ensure_running()\n    ~~~~~~~~~~~~~~~~~~~^^\n  File \"/usr/local/lib/python3.14/multiprocessing/forkserver.py\", line 157, in ensure_running\n    address = connection.arbitrary_address('AF_UNIX')\n  File \"/usr/local/lib/python3.14/multiprocessing/connection.py\", line 79, in arbitrary_address\n    return tempfile.mktemp(prefix='sock-', dir=util.get_temp_dir())\n                                               ~~~~~~~~~~~~~~~~~^^\n  File \"/usr/local/lib/python3.14/multiprocessing/util.py\", line 216, in get_temp_dir\n    base_tempdir = _get_base_temp_dir(tempfile)\n  File \"/usr/local/lib/python3.14/multiprocessing/util.py\", line 171, in _get_base_temp_dir\n    base_tempdir = tempfile.gettempdir()\n  File \"/usr/local/lib/python3.14/tempfile.py\", line 316, in gettempdir\n    return _os.fsdecode(_gettempdir())\n                        ~~~~~~~~~~~^^\n  File \"/usr/local/lib/python3.14/tempfile.py\", line 309, in _gettempdir\n    tempdir = _get_default_tempdir()\n  File \"/usr/local/lib/python3.14/tempfile.py\", line 224, in _get_default_tempdir\n    raise FileNotFoundError(_errno.ENOENT,\n                            \"No usable temporary directory found in %s\" %\n                            dirlist)\nFileNotFoundError: [Errno 2] No usable temporary directory found in ['/tmp', '/var/tmp', '/usr/tmp', '/app']"}
```

There was no temp directory where the container can write into. So I added it. Sometimes a had a timeout on my probes, so changed the probes as well

```yaml
persistence:
  volumes:
   - name: tmp
     emptyDir: {}
controller:
  admin:
    username: opvolger
    password: demodemo
  # some more time for the low performance RISC-V boards 
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
    tag: 2.528.3-jdk21
  sidecars:
    configAutoReload:
      additionalVolumeMounts:
        - name: tmp
          mountPath: "/tmp"
      image:
        repository: opvolger/k8s-sidecar
        tag: 1.30.7
  ingress:
    enabled: true
    hostName: "jenkins.k8s.riscv.net"
```

```bash
# On my main machine
helm uninstall jenkins -n jenkins
helm install jenkins jenkins/jenkins -n jenkins --values values.yaml
```

Now it is running without a problem!

## Kubernetes job

Oke, now we can create our first pipeline job in the jenkins. I created a very simple build. It will only run `uanme -a` on a ubuntu docker container.

```groovy
pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
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

Running the job! It was nog a success :\(

```bash
# On my main machine
kubectl get event --namespace jenkins
```

But this was failing!

```ini
Failed to pull image "jenkins/inbound-agent:3345.v03dee9b_f88fc-1": rpc error: code = NotFound desc = failed to pull and unpack image "docker.io/jenkins/inbound-agent:3345.v03dee9b_f88fc-1": no match for platform in manifest: not found
```

The last thing I needed was the agent docker for risc-v:

```bash
# On the risc-v machine:
git clone https://github.com/jenkinsci/docker-agent.git

cd docker-agent
git checkout 3345.v03dee9b_f88fc-1
sudo docker build -f debian/Dockerfile . \
--build-arg JAVA_VERSION=21.0.9_10 \
-t opvolger/inbound-agent:3345.v03dee9b_f88fc-1 --progress plain
sudo docker push opvolger/inbound-agent:3345.v03dee9b_f88fc-1
```

```yaml
persistence:
  volumes:
   - name: tmp
     emptyDir: {}
agent:
  defaultsProviderTemplate: default
  image:
    repository: "opvolger/inbound-agent"
    tag: "3345.v03dee9b_f88fc-1"
controller:
  admin:
    username: opvolger
    password: demodemo
  # some more time for the low performance RISC-V boards 
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
    tag: 2.528.3-jdk21
  sidecars:
    configAutoReload:
      additionalVolumeMounts:
        - name: tmp
          mountPath: "/tmp"
      image:
        repository: opvolger/k8s-sidecar
        tag: 1.30.7
  ingress:
    enabled: true
    hostName: "jenkins.k8s.riscv.net"
```

uninstall and install again with the updated values.yaml

```bash
# On my main machine
helm uninstall jenkins -n jenkins
helm install jenkins jenkins/jenkins -n jenkins --values values.yaml
```

Re-create the pipeline, and it will work!

## All in one deploy

create values.yaml

```yaml
persistence:
  volumes:
   - name: tmp
     emptyDir: {}
agent:
  defaultsProviderTemplate: default
  image:
    repository: "opvolger/inbound-agent"
    tag: "3345.v03dee9b_f88fc-1"
controller:
  admin:
    username: opvolger
    password: demodemo
  # some more time for the low performance RISC-V boards 
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
    tag: 2.528.3-jdk21
  sidecars:
    configAutoReload:
      additionalVolumeMounts:
        - name: tmp
          mountPath: "/tmp"
      image:
        repository: opvolger/k8s-sidecar
        tag: 1.30.7
  ingress:
    enabled: true
    hostName: "jenkins.k8s.riscv.net"
  installPlugins:
    - kubernetes:latest
    - workflow-aggregator:latest
    - git:latest
    - configuration-as-code:latest
    - blueocean:latest
    - job-dsl:latest
  JCasC:
    configScripts:
      jobs: |
        jobs:
          - script: >
              pipelineJob('test') {
                definition {
                  cps {
                    sandbox()
                    script("""\
                      pipeline {
                          agent {
                              kubernetes {
                                  yaml '''
                      apiVersion: v1
                      kind: Pod
                      spec:
                        containers:
                        - name: shell
                          image: ubuntu
                          command:
                          - sleep
                          args:
                          - infinity
                          securityContext:
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
                      }""".stripIndent())
                  }
                }
              }
```

```bash
helm install jenkins jenkins/jenkins -n jenkins --values values.yaml
```
