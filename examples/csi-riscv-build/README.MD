# Build of K8s CSI for amd64/arm64 and riscv64

```bash
make push-multiarch PULL_BASE_REF=master REGISTRY_NAME=opvolger BUILD_PLATFORMS="linux amd64 amd64; linux arm64 arm64 -arm64; linux riscv64 riscv64 -riscv64"
```
