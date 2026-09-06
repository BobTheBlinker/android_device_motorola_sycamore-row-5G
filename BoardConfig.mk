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
