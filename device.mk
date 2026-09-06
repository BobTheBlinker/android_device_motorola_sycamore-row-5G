# Inherit from MT6835 common.
$(call inherit-product, device/motorola/mt6835-common/common.mk)

# Soong namespaces.
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)
