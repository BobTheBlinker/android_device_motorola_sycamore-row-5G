# Inherit from MT6835 common.
$(call inherit-product, device/motorola/mt6835-common/common.mk)

# Soong namespaces.
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Shipping API level (stock ro.product.first_api_level)
PRODUCT_SHIPPING_API_LEVEL := 35

# VNDK snapshot for the stock API 33 vendor
PRODUCT_EXTRA_VNDK_VERSIONS := 33

# Tablet
PRODUCT_CHARACTERISTICS := tablet

# First-stage fstabs (stock)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.emmc:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.emmc \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6835:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6835 \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt8755:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt8755 \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt8755dm:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt8755dm

# fstabs and ueventd (stock vendor)
PRODUCT_COPY_FILES += \
    $(foreach f,$(notdir $(wildcard $(LOCAL_PATH)/rootdir/etc/fstab.*)),\
        $(LOCAL_PATH)/rootdir/etc/$(f):$(TARGET_COPY_OUT_VENDOR)/etc/$(f)) \
    $(LOCAL_PATH)/rootdir/etc/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

# Init (stock vendor)
PRODUCT_COPY_FILES += \
    $(foreach f,$(notdir $(wildcard $(LOCAL_PATH)/rootdir/etc/init/hw/*.rc)),\
        $(LOCAL_PATH)/rootdir/etc/init/hw/$(f):$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/$(f))

# Bluetooth profiles (stock system build.prop)
PRODUCT_SYSTEM_PROPERTIES += \
    bluetooth.profile.a2dp.source.enabled=true \
    bluetooth.profile.asha.central.enabled=true \
    bluetooth.profile.avrcp.target.enabled=true \
    bluetooth.profile.bas.client.enabled=true \
    bluetooth.profile.gatt.enabled=true \
    bluetooth.profile.hfp.ag.enabled=true \
    bluetooth.profile.hid.device.enabled=true \
    bluetooth.profile.hid.host.enabled=true \
    bluetooth.profile.map.server.enabled=true \
    bluetooth.profile.opp.enabled=true \
    bluetooth.profile.pan.nap.enabled=true \
    bluetooth.profile.pan.panu.enabled=true \
    bluetooth.profile.pbap.server.enabled=true \
    bluetooth.profile.sap.server.enabled=true

# Landscape boot animation (ro.bootanim.* is a system property; vendor_init cannot set it)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.bootanim.set_orientation_logical_0=ORIENTATION_90

# Overlays
PRODUCT_PACKAGES += \
    SycamoreCellBroadcastRes \
    SycamoreFrameworksRes \
    SycamoreFrameworksResExt \
    SycamoreSettingsProviderRes \
    SycamoreWifiRes

# Recovery: USB controller for adb (ro.hardware is mt8755)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.recovery.mt8755.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt8755.rc


# Inherit the proprietary files
$(call inherit-product, vendor/motorola/sycamore_row_5G/sycamore_row_5G-vendor.mk)
