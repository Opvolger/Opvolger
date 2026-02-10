# node-driver-registrar
NODE_DRIVER_REGISTRAR_BRANCH ?= release-2.15
NODE_DRIVER_REGISTRAR_REPO ?= https://github.com/kubernetes-csi/node-driver-registrar
NODE_DRIVER_REGISTRAR_PATCHES ?= patches/node-driver-registrar

# livenessprobe
LIVENESSPROBE_BRANCH ?= release-2.17
LIVENESSPROBE_REPO ?= https://github.com/kubernetes-csi/livenessprobe.git
LIVENESSPROBE_PATCHES ?= patches/livenessprobe

# csi-driver-iscsi
CSI_DRIVER_ISCSI_BRANCH ?= master
CSI_DRIVER_ISCSI_REPO ?= https://github.com/kubernetes-csi/csi-driver-iscsi.git
CSI_DRIVER_ISCSI_PATCHES ?= patches/csi-driver-iscsi

# csi-driver-smb
CSI_DRIVER_SMB_BRANCH ?= release-1.20
CSI_DRIVER_SMB_REPO ?= https://github.com/kubernetes-csi/csi-driver-smb.git
CSI_DRIVER_SMB_PATCHES ?= patches/csi-driver-smb

# csi-provisioner
CSI_PROVISIONER_BRANCH ?= release-6.1
CSI_PROVISIONER_REPO ?= https://github.com/kubernetes-csi/external-provisioner.git
CSI_PROVISIONER_PATCHES ?= patches/external-provisioner

# csi-resizer
CSI_RESIZER_BRANCH ?= release-2.0
CSI_RESIZER_REPO ?= https://github.com/kubernetes-csi/external-resizer.git
CSI_RESIZER_PATCHES ?= patches/external-resizer

DOCKER_REGISTRY_NAME ?= opvolger
BUILD_PLATFORMS_LINUX_ONLY ?= "linux amd64 amd64; linux riscv64 riscv64 -riscv64; linux arm64 arm64 -arm64"
BUILD_PLATFORMS ?= "linux amd64 amd64; linux riscv64 riscv64 -riscv64; linux arm64 arm64 -arm64; windows amd64 amd64 .exe nanoserver:1809 servercore:ltsc2019; windows amd64 amd64 .exe nanoserver:ltsc2022 servercore:ltsc2022"

BUILD_ROOT ?= build/

define checkout_code_add_patches
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
endef

docker_images: docker_csi_node_driver_registrar docker_csi_driver_iscsi docker_livenessprobe docker_csi_driver_smb docker_csi_provisioner docker_csi_resizer

docker_csi_node_driver_registrar:
	@$(call checkout_code_add_patches,"node-driver-registrar",${NODE_DRIVER_REGISTRAR_REPO},${NODE_DRIVER_REGISTRAR_BRANCH},${NODE_DRIVER_REGISTRAR_PATCHES})
	$(MAKE) -C $(BUILD_ROOT)/${$@_DIR} push-multiarch PULL_BASE_REF=${$@_BRANCH} REGISTRY_NAME=$(DOCKER_REGISTRY_NAME) BUILD_PLATFORMS=$(BUILD_PLATFORMS)

docker_csi_driver_iscsi:
	@$(call checkout_code_add_patches,"csi-driver-iscsi",${CSI_DRIVER_ISCSI_REPO},${CSI_DRIVER_ISCSI_BRANCH},${CSI_DRIVER_ISCSI_PATCHES})
	$(MAKE) -C $(BUILD_ROOT)/${$@_DIR} push-multiarch PULL_BASE_REF=${$@_BRANCH} REGISTRY_NAME=$(DOCKER_REGISTRY_NAME) BUILD_PLATFORMS=$(BUILD_PLATFORMS_LINUX_ONLY)

docker_livenessprobe:
	@$(call checkout_code_add_patches,"livenessprobe",${LIVENESSPROBE_REPO},${LIVENESSPROBE_BRANCH},${LIVENESSPROBE_PATCHES})
	$(MAKE) -C $(BUILD_ROOT)/${$@_DIR} push-multiarch PULL_BASE_REF=${$@_BRANCH} REGISTRY_NAME=$(DOCKER_REGISTRY_NAME) BUILD_PLATFORMS=$(BUILD_PLATFORMS)

docker_csi_driver_smb:
	@$(call checkout_code_add_patches,"csi-driver-smb",${CSI_DRIVER_SMB_REPO},${CSI_DRIVER_SMB_BRANCH},${CSI_DRIVER_SMB_PATCHES})
	$(MAKE) -C $(BUILD_ROOT)/csi-driver-smb container-all REGISTRY_NAME=$(DOCKER_REGISTRY_NAME)
	$(MAKE) -C $(BUILD_ROOT)/csi-driver-smb push-manifest REGISTRY_NAME=$(DOCKER_REGISTRY_NAME)

docker_csi_provisioner:
	@$(call checkout_code_add_patches,"external-provisioner",${CSI_PROVISIONER_REPO},${CSI_PROVISIONER_BRANCH},${CSI_PROVISIONER_PATCHES})
	$(MAKE) -C $(BUILD_ROOT)/${$@_DIR} push-multiarch PULL_BASE_REF=${$@_BRANCH} REGISTRY_NAME=$(DOCKER_REGISTRY_NAME) BUILD_PLATFORMS=$(BUILD_PLATFORMS_LINUX_ONLY)

docker_csi_resizer:
	@$(call checkout_code_add_patches,"external-resizer",${CSI_RESIZER_REPO},${CSI_RESIZER_BRANCH},${CSI_RESIZER_PATCHES})
	$(MAKE) -C $(BUILD_ROOT)/${$@_DIR} push-multiarch PULL_BASE_REF=${$@_BRANCH} REGISTRY_NAME=$(DOCKER_REGISTRY_NAME) BUILD_PLATFORMS=$(BUILD_PLATFORMS_LINUX_ONLY)
