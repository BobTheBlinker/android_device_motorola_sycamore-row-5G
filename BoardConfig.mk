DEVICE_PATH := device/motorola/sycamore_row_5G

# Inherit from Motorola MT6835 common.
include device/motorola/mt6835-common/BoardConfigCommon.mk

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := sycamore_row_5G

# Kernel
BOARD_KERNEL_IMAGE_NAME := Image

# Use the stock-known-good kernel for initial Lineage bring-up.
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_FORCE_PREBUILT_KERNEL := true

# Stock vendor_boot v4 header values (9bdeac_017)
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_MKBOOTIMG_ARGS += --kernel_offset 0x00000000
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset 0x26f00000
BOARD_MKBOOTIMG_ARGS += --tags_offset 0x07c80000
BOARD_MKBOOTIMG_ARGS += --dtb_offset 0x07c80000

# DTB / DTBO (stock)
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img

# Bring-up: SELinux permissive
BOARD_BOOTCONFIG += androidboot.selinux=permissive

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

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt8755
