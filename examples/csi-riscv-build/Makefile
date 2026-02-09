# node-driver-registrar
NODE_DRIVER_REGISTRAR_BRANCH ?= release-2.15
NODE_DRIVER_REGISTRAR_REPO ?= https://github.com/kubernetes-csi/node-driver-registrar
NODE_DRIVER_REGISTRAR_PATCHES ?= patches/node-driver-registrar

# csi-driver-iscsi
CSI_DRIVER_ISCSI_BRANCH ?= master
CSI_DRIVER_ISCSI_REPO ?= https://github.com/kubernetes-csi/csi-driver-iscsi.git
CSI_DRIVER_ISCSI_PATCHES ?= patches/csi-driver-iscsi

# livenessprobe
LIVENESSPROBE_BRANCH ?= release-2.17
LIVENESSPROBE_REPO ?= https://github.com/kubernetes-csi/livenessprobe.git
LIVENESSPROBE_PATCHES ?= patches/livenessprobe

DOCKER_REGISTRY_NAME ?= opvolger
BUILD_PLATFORMS ?= "linux amd64 amd64; linux riscv64 riscv64 -riscv64; linux arm64 arm64 -arm64"

BUILD_ROOT ?= build/

define build_docker_images
	$(eval $@_DIR = $(1))
	$(eval $@_REPO = $(2))
	$(eval $@_BRANCH = $(3))
	$(eval $@_PATCHES = $(4))
	mkdir -p $(BUILD_ROOT);
	if [ -d "$(BUILD_ROOT)/${$@_DIR}" ]; then \
		cd $(BUILD_ROOT)/${$@_DIR} && git switch ${$@_BRANCH}; \
	else \
		cd $(BUILD_ROOT) && git clone -b ${$@_BRANCH} ${$@_REPO}; \
	fi
	echo ${$@_BRANCH}
	cd $(BUILD_ROOT)/${$@_DIR} && git clean -fd && git reset --hard
	cd $(BUILD_ROOT)/${$@_DIR} && git apply ../../${$@_PATCHES}/*.patch
	$(MAKE) -C $(BUILD_ROOT)/${$@_DIR} push-multiarch PULL_BASE_REF=${$@_BRANCH} REGISTRY_NAME=$(DOCKER_REGISTRY_NAME) BUILD_PLATFORMS=$(BUILD_PLATFORMS)
endef

docker_images: docker_node_driver_registrar docker_csi_driver_iscsi docker_livenessprobe

docker_node_driver_registrar:
	@$(call build_docker_images,"node-driver-registrar",${NODE_DRIVER_REGISTRAR_REPO},${NODE_DRIVER_REGISTRAR_BRANCH},${NODE_DRIVER_REGISTRAR_PATCHES})

docker_csi_driver_iscsi:
	@$(call build_docker_images,"csi-driver-iscsi",${CSI_DRIVER_ISCSI_REPO},${CSI_DRIVER_ISCSI_BRANCH},${CSI_DRIVER_ISCSI_PATCHES})

docker_livenessprobe:
	@$(call build_docker_images,"livenessprobe",${LIVENESSPROBE_REPO},${LIVENESSPROBE_BRANCH},${LIVENESSPROBE_PATCHES})