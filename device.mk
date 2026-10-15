# Inherit from MT6835 common.
$(call inherit-product, device/motorola/mt6835-common/common.mk)

# Soong namespaces.
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Tablet
PRODUCT_CHARACTERISTICS := tablet

# First-stage fstabs (stock)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.emmc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6835:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6835 \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt8755:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt8755 \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt8755dm:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt8755dm

# Recovery: USB controller for adb (ro.hardware is mt8755)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.recovery.mt8755.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt8755.rc
