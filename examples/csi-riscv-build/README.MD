# Build of K8s CSI for amd64/arm64 and riscv64

First fix running qemu for multi arch docker builds [multi arch docker](https://github.com/tonistiigi/binfmt)

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

## Al the build can be build with this line

We need to patch some Dockerfile, most images are based on debian-bookworm and that has no riscv64 arch.

```bash
make push-multiarch PULL_BASE_REF=master REGISTRY_NAME=opvolger BUILD_PLATFORMS="linux amd64 amd64; linux arm64 arm64 -arm64; linux riscv64 riscv64 -riscv64"
```
