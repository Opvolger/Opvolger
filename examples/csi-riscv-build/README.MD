# Build of K8s CSI for amd64/arm64 and riscv64

First fix running qemu for multi arch docker builds [multi arch docker](https://github.com/tonistiigi/binfmt)

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

Login with docker

```bash
docker login
```

Build the images

```bash
make docker_images
```

## Al the build can be build with this line

We need to patch some Dockerfile, most images are based on debian-bookworm and that has no riscv64 arch.

```bash
make push-multiarch PULL_BASE_REF=master REGISTRY_NAME=opvolger BUILD_PLATFORMS="linux amd64 amd64; linux arm64 arm64 -arm64; linux riscv64 riscv64 -riscv64"
```

## Deploy CSI SMB

values.yaml:

```yaml
image:
  baseRepo: opvolger
  smb:
    repository: /smbplugin # done
    tag: v1.20.0
    pullPolicy: IfNotPresent
  csiProvisioner:
    repository: /csi-provisioner # done
    tag: v6.1-canary
    pullPolicy: IfNotPresent
  csiResizer:
    repository: /csi-resizer # done
    tag: 2.0-canary
    pullPolicy: IfNotPresent
  livenessProbe:
    repository: /livenessprobe # done
    tag: 2.17-canary
    pullPolicy: IfNotPresent
  nodeDriverRegistrar:
    repository: /csi-node-driver-registrar  # done
    tag: 2.15.canary
    pullPolicy: IfNotPresent
  csiproxy:
    repository: ghcr.io/kubernetes-sigs/sig-windows/csi-proxy  # not needed only windows
    tag: v1.1.2
    pullPolicy: IfNotPresent
# for k0s change the kubelet path
linux:
    kubelet: /var/lib/k0s/kubelet
windows:
    kubelet: 'C:\var\lib\k0s\kubelet'
```

```bash
helm repo add csi-driver-smb https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts
helm install csi-driver-smb csi-driver-smb/csi-driver-smb --namespace kube-system --version 1.20.0 --values values.yaml
```

## Deploy CSI iscsi

See [install-driver.sh](https://github.com/kubernetes-csi/csi-driver-iscsi/blob/master/deploy/install-driver.sh)

Download `csi-iscsi-driverinfo.yaml` and `csi-iscsi-node.yaml` from the repo.
Edit `csi-iscsi-node.yaml` and change the docker image repo and tags

example:

```yaml
---
# This YAML file contains driver-registrar & csi driver nodeplugin API objects
# that are necessary to run CSI nodeplugin for iscsi
kind: DaemonSet
apiVersion: apps/v1
metadata:
  name: csi-iscsi-node
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: csi-iscsi-node
  template:
    metadata:
      labels:
        app: csi-iscsi-node
    spec:
      hostNetwork: true  # original iscsi connection would be broken without hostNetwork setting
      dnsPolicy: ClusterFirstWithHostNet  # available values: Default, ClusterFirstWithHostNet, ClusterFirst
      nodeSelector:
        kubernetes.io/os: linux
      containers:
        - name: liveness-probe
          image: opvolger/livenessprobe:2.17-canary # changed
          args:
            - --csi-address=/csi/csi.sock
            - --probe-timeout=3s
            - --health-port=29753
            - --v=2
          volumeMounts:
            - name: socket-dir
              mountPath: /csi
          resources:
            limits:
              memory: 100Mi
            requests:
              cpu: 10m
              memory: 20Mi
        - name: node-driver-registrar
          # This is necessary only for systems with SELinux, where
          # non-privileged sidecar containers cannot access unix domain socket
          # created by privileged CSI driver container.
          securityContext:
            privileged: true
          image: opvolger/csi-node-driver-registrar:2.15-canary # changed
          args:
            - --v=2
            - --csi-address=/csi/csi.sock
            - --kubelet-registration-path=/var/lib/kubelet/plugins/iscsi.csi.k8s.io/csi.sock
          env:
            - name: KUBE_NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
          volumeMounts:
            - name: socket-dir
              mountPath: /csi
            - name: registration-dir
              mountPath: /registration
          resources:
            limits:
              memory: 200Mi
            requests:
              cpu: 10m
              memory: 20Mi
        - name: iscsi
          securityContext:
            privileged: true
            capabilities:
              add: ["SYS_ADMIN"]
            allowPrivilegeEscalation: true
          image: opvolger/iscsiplugin:canary
          args:
            - "--nodeid=$(NODE_ID)"
            - "--endpoint=$(CSI_ENDPOINT)"
            - "--v=5"
          env:
            - name: NODE_ID
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: CSI_ENDPOINT
              value: unix:///csi/csi.sock
          ports:
            - containerPort: 29753
              name: healthz
              protocol: TCP
          livenessProbe:
            failureThreshold: 5
            httpGet:
              path: /healthz
              port: healthz
            initialDelaySeconds: 30
            timeoutSeconds: 10
            periodSeconds: 30
          imagePullPolicy: "IfNotPresent"
          volumeMounts:
            - name: socket-dir
              mountPath: /csi
            - name: mountpoint-dir
              mountPath: /var/lib/kubelet/
              mountPropagation: Bidirectional
            - name: host-dev
              mountPath: /dev
            - name: host-root
              mountPath: /host
              mountPropagation: "HostToContainer"
            - name: chroot-iscsiadm
              mountPath: /sbin/iscsiadm
              subPath: iscsiadm
            - name: iscsi-csi-run-dir
              mountPath: /var/run/iscsi.csi.k8s.io
          resources:
            limits:
              memory: 300Mi
            requests:
              cpu: 10m
              memory: 20Mi
      volumes:
        - name: socket-dir
          hostPath:
            path: /var/lib/kubelet/plugins/iscsi.csi.k8s.io
            type: DirectoryOrCreate
        - name: mountpoint-dir
          hostPath:
            path: /var/lib/kubelet/
            type: DirectoryOrCreate
        - name: registration-dir
          hostPath:
            path: /var/lib/kubelet/plugins_registry
            type: DirectoryOrCreate
        - name: host-dev
          hostPath:
            path: /dev
        - name: host-root
          hostPath:
            path: /
            type: Directory
        - name: chroot-iscsiadm
          configMap:
            defaultMode: 0555
            name: configmap-csi-iscsiadm
        - name: iscsi-csi-run-dir
          hostPath:
            path: /var/run/iscsi.csi.k8s.io
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: configmap-csi-iscsiadm
  namespace: kube-system
data:
  iscsiadm: |
    #!/bin/sh
    if [ -x /host/sbin/iscsiadm ]; then
      chroot /host /sbin/iscsiadm "$@"
    elif [ -x /host/usr/local/sbin/iscsiadm ]; then
      chroot /host /usr/local/sbin/iscsiadm "$@"
    elif [ -x /host/bin/iscsiadm ]; then
      chroot /host /bin/iscsiadm "$@"
    elif [ -x /host/usr/local/bin/iscsiadm ]; then
      chroot /host /usr/local/bin/iscsiadm "$@"
    else
      chroot /host iscsiadm "$@"
    fi
---
```
