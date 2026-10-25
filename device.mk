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

# First-stage fstabs (stock): explicit copies keep the exact first_stage_ramdisk paths
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/fstab.mt8755:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt8755 \
    $(LOCAL_PATH)/init/fstab.mt8755dm:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt8755dm

# fstabs, ueventd and init rc -> /vendor/etc via init/Android.bp (prebuilt_etc)
PRODUCT_PACKAGES += \
    fstab.enableswap \
    fstab.mt6835 \
    fstab.mt6835dm \
    fstab.mt8755 \
    fstab.mt8755dm \
    fstab.zram_wb \
    ueventd.mt8755.rc \
    init.aee.rc \
    init.cgroup.rc \
    init.connectivity.common.rc \
    init.connectivity.rc \
    init_connectivity.rc \
    init.modem.rc \
    init.mt6835.usb-v33.rc \
    init.mt8755.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.sensor_2_0.rc

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
    bluetooth.profile.sap.server.enabled=false

# Overlays
PRODUCT_PACKAGES += \
    SycamoreCellBroadcastRes \
    SycamoreFrameworksRes \
    SycamoreFrameworksResExt \
    SycamoreSettingsProviderRes \
    SycamoreWifiRes

# Recovery: USB controller for adb (ro.hardware is mt8755)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/init.recovery.mt8755.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.mt8755.rc


# Inherit the proprietary files
$(call inherit-product, vendor/motorola/sycamore_row_5G/sycamore_row_5G-vendor.mk)
