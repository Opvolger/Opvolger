# branches
NODE_DRIVER_REGISTRAR_BRANCH ?= release-2.15
NODE_DRIVER_REGISTRAR_REPO ?= https://github.com/kubernetes-csi/node-driver-registrar
NODE_DRIVER_REGISTRAR_PATCHES ?= patches/node-driver-registrar

DOCKER_REGISTRY_NAME ?= opvolger
BUILD_PLATFORMS ?= "linux amd64 amd64; linux riscv64 riscv64 -riscv64; linux arm64 arm64 -arm64"

BUILD_ROOT ?= build/

docker:
	mkdir -p $(BUILD_ROOT);
	if [ -d "$(BUILD_ROOT)/node-driver-registrar" ]; then \
		cd $(BUILD_ROOT)/node-driver-registrar && git switch $(NODE_DRIVER_REGISTRAR_BRANCH); \
	else \
		cd $(BUILD_ROOT) && git clone -b $(NODE_DRIVER_REGISTRAR_BRANCH) $(NODE_DRIVER_REGISTRAR_REPO); \
	fi
	cd $(BUILD_ROOT) && git clean -fd && git reset --hard
	cd $(BUILD_ROOT)node-driver-registrar && git apply ../../$(NODE_DRIVER_REGISTRAR_PATCHES)/*.patch
	$(MAKE) -C $(BUILD_ROOT)/node-driver-registrar push-multiarch PULL_BASE_REF=$(NODE_DRIVER_REGISTRAR_BRANCH) REGISTRY_NAME=$(DOCKER_REGISTRY_NAME) BUILD_PLATFORMS=$(BUILD_PLATFORMS)
