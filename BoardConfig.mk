DEVICE_PATH := device/motorola/sycamore_row_5G

# Inherit from Motorola MT6835 common.
include device/motorola/mt6835-common/BoardConfigCommon.mk

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := sycamore_row_5G

# Kernel
BOARD_KERNEL_IMAGE_NAME := Image.lz4

# Google GKI android13-5.15 at the stock build (ab/14024729), trimmed to the stock KMI,
# without the GKI zram/zsmalloc modules (the stock vendor modules are used).
TARGET_KERNEL_SOURCE := kernel/google/gki-5.15
TARGET_KERNEL_CONFIG := gki_defconfig
TARGET_KERNEL_CONFIG_EXT := $(DEVICE_PATH)/kernel/gki.config
TARGET_KERNEL_CLANG_VERSION := r450784e
TARGET_KERNEL_CLANG_PATH := $(abspath prebuilts/clang/kernel/android13-5.15/clang-r450784e)

# Google's pahole and source/output path maps (KERNEL_OUT is set when kernel.mk expands this)
SYC_KERNEL_SRC := $(abspath $(TARGET_KERNEL_SOURCE))
TARGET_KERNEL_ADDITIONAL_FLAGS = \
    PAHOLE=$(abspath prebuilts/kernel-build-tools-android13/linux-x86/bin/pahole) \
    KCPPFLAGS="-ffile-prefix-map=$(SYC_KERNEL_SRC)/= -ffile-prefix-map=$(SYC_KERNEL_SRC)=common \
        -ffile-prefix-map=$(KERNEL_BUILD_OUT_PREFIX)$(KERNEL_OUT)=out/android13-5.15/common"

# Stock vendor_boot v4 header values (9bdeac_017)
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_KERNEL_CMDLINE += bootconfig
BOARD_MKBOOTIMG_ARGS += --kernel_offset 0x00000000
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset 0x26f00000
BOARD_MKBOOTIMG_ARGS += --tags_offset 0x07c80000
BOARD_MKBOOTIMG_ARGS += --dtb_offset 0x07c80000

# Stock boot.img: empty header os fields, stock AVB os_version/security_patch (KeyMint patch level)
BOARD_MKBOOTIMG_ARGS += --os_version 0 --os_patch_level none
BOOT_OS_VERSION := 13
BOOT_SECURITY_PATCH := 2024-05-05

# Stock init_boot: same pin (init_boot carries the OS version / patch level)
BOARD_MKBOOTIMG_INIT_ARGS += --os_version 0 --os_patch_level none
INIT_BOOT_OS_VERSION := 13

# AVB: stock layout (vbmeta chains boot, vbmeta_system, vbmeta_vendor), rollback index 0.
# Key defaults to the AOSP test key; a ROM's private keys config can set BOARD_AVB_KEY_PATH/ALGORITHM.
BOARD_AVB_KEY_PATH ?= external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_ALGORITHM ?= SHA256_RSA4096
BOARD_AVB_ROLLBACK_INDEX := 0

BOARD_AVB_BOOT_KEY_PATH ?= $(BOARD_AVB_KEY_PATH)
BOARD_AVB_BOOT_ALGORITHM ?= $(BOARD_AVB_ALGORITHM)
BOARD_AVB_BOOT_ROLLBACK_INDEX := 0
BOARD_AVB_BOOT_ROLLBACK_INDEX_LOCATION := 3

BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH ?= $(BOARD_AVB_KEY_PATH)
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM ?= $(BOARD_AVB_ALGORITHM)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := 0
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_VENDOR_KEY_PATH ?= $(BOARD_AVB_KEY_PATH)
BOARD_AVB_VBMETA_VENDOR_ALGORITHM ?= $(BOARD_AVB_ALGORITHM)
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := 0
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 4

$(foreach p,SYSTEM SYSTEM_EXT PRODUCT VENDOR VENDOR_DLKM ODM_DLKM SYSTEM_DLKM, \
    $(eval BOARD_AVB_$(p)_ADD_HASHTREE_FOOTER_ARGS += --hash_algorithm sha256))

# DTB / DTBO (stock)
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img

# SEPolicy
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private

# Dynamic partitions: Lenovo layout uses group "main" (main_a / main_b)
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 11809062912
BOARD_MAIN_PARTITION_LIST := odm_dlkm product system system_dlkm system_ext vendor vendor_dlkm

# Vendor ramdisk kernel modules (stock vendor_boot)
SYC_VB_MODULES := $(DEVICE_PATH)/prebuilt/modules/vendor_boot
BOARD_DO_NOT_STRIP_VENDOR_RAMDISK_MODULES := true
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(SYC_VB_MODULES)/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(strip $(shell cat $(SYC_VB_MODULES)/modules.load))
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(strip $(shell cat $(SYC_VB_MODULES)/modules.load.recovery))

# Vendor kernel modules (stock vendor_dlkm, installed unstripped)
SYC_DLKM_MODULES := $(DEVICE_PATH)/prebuilt/modules/vendor_dlkm
BOARD_DO_NOT_STRIP_VENDOR_MODULES := true
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(SYC_DLKM_MODULES)/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(SYC_DLKM_MODULES)/modules.load))

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt8755
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# Landscape recovery to match the landscape-native display (portrait panel rotated 90 CW)
TARGET_RECOVERY_DEFAULT_ROTATION := ROTATION_RIGHT
TARGET_RECOVERY_DEFAULT_TOUCH_ROTATION := ROTATION_RIGHT

# Display
TARGET_SCREEN_DENSITY := 320

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
TARGET_ODM_PROP += $(DEVICE_PATH)/odm.prop

# VINTF
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/vintf/manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DEVICE_PATH)/configs/vintf/framework_compatibility_matrix.xml

# Inherit the proprietary files
include vendor/motorola/sycamore_row_5G/BoardConfigVendor.mk
