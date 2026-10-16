# Inherit from the 64-bit product configuration (with 32-bit support for the stock vendor).
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
TARGET_SUPPORTS_OMX_SERVICE := false
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from sycamore_row_5G device.
$(call inherit-product, device/motorola/sycamore_row_5G/device.mk)

# Inherit Lineage configuration.
$(call inherit-product, vendor/lineage/config/common_full_tablet.mk)

PRODUCT_NAME := lineage_sycamore_row_5G
PRODUCT_DEVICE := sycamore_row_5G
PRODUCT_MANUFACTURER := Motorola
PRODUCT_BRAND := Motorola
PRODUCT_MODEL := Moto Pad 2026

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    DeviceProduct="XT2575-4" \
    BuildDesc="XT2575-4-user 16 BP2A.250605.031.A3 9bdeac_017 release-keys" \
    BuildFingerprint="Motorola/XT2575-4/XT2575-4:16/BP2A.250605.031.A3/9bdeac_017:user/release-keys"
