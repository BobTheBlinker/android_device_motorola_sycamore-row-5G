#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)
from extract_utils.utils import import_module
from os import path

namespace_imports = [
    'vendor/motorola/mt6835-common',
]


def vndk_v33_libs():
    # Provided at runtime by the com.android.vndk.v33 APEX
    configs = path.join(
        path.dirname(path.realpath(__file__)),
        '../../../prebuilts/vndk/v33/arm64/configs',
    )
    libs = set()
    for name in ('vndkcore.libraries.33.txt', 'vndksp.libraries.txt'):
        with open(path.join(configs, name)) as f:
            libs.update(line.strip().removesuffix('.so') for line in f)
    libs.discard('')
    return libs


def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'libarmnn',
        'libmtkperf_client_vendor',
        'libperfctl_vendor',
        'libpowerhalwrap_vendor',
        'libvibrator',
    ): lib_fixup_vendor_suffix,
}

lib_fixups_covered = {
    lib
    for key in lib_fixups
    for lib in (key if isinstance(key, tuple) else (key,))
}

lib_fixups.update(
    {
        lib: lib_fixup_remove
        for lib in vndk_v33_libs()
        if lib not in lib_fixups_covered
    }
)

# Stock copies of libs that AOSP also builds for vendor, kept as -v33
v33_libs = (
    'android.frameworks.cameraservice.common@2.0',
    'android.frameworks.cameraservice.device@2.0',
    'android.frameworks.cameraservice.device@2.1',
    'android.frameworks.cameraservice.service@2.0',
    'android.frameworks.cameraservice.service@2.1',
    'android.frameworks.cameraservice.service@2.2',
    'android.frameworks.sensorservice@1.0',
    'android.hardware.audio.common-util',
    'android.hardware.audio.common@5.0',
    'android.hardware.audio.common@6.0',
    'android.hardware.audio.common@6.0-util',
    'android.hardware.audio.common@7.0',
    'android.hardware.audio.common@7.0-enums',
    'android.hardware.audio.common@7.0-util',
    'android.hardware.audio.common@7.1-enums',
    'android.hardware.audio.common@7.1-util',
    'android.hardware.audio.effect@6.0',
    'android.hardware.audio.effect@6.0-util',
    'android.hardware.audio.effect@7.0',
    'android.hardware.audio.effect@7.0-util',
    'android.hardware.audio@6.0',
    'android.hardware.audio@7.0',
    'android.hardware.audio@7.0-util',
    'android.hardware.audio@7.1',
    'android.hardware.audio@7.1-util',
    'android.hardware.bluetooth.audio@2.0',
    'android.hardware.bluetooth.audio@2.1',
    'android.hardware.bluetooth@1.0',
    'android.hardware.bluetooth@1.1',
    'android.hardware.boot@1.0',
    'android.hardware.boot@1.1',
    'android.hardware.boot@1.2',
    'android.hardware.camera.common@1.0',
    'android.hardware.camera.device@1.0',
    'android.hardware.camera.device@3.2',
    'android.hardware.camera.device@3.3',
    'android.hardware.camera.device@3.4',
    'android.hardware.camera.device@3.5',
    'android.hardware.camera.device@3.6',
    'android.hardware.camera.provider@2.4',
    'android.hardware.camera.provider@2.5',
    'android.hardware.camera.provider@2.6',
    'android.hardware.gatekeeper@1.0',
    'android.hardware.gnss.measurement_corrections@1.0',
    'android.hardware.gnss.measurement_corrections@1.1',
    'android.hardware.gnss.visibility_control@1.0',
    'android.hardware.gnss@1.0',
    'android.hardware.gnss@1.1',
    'android.hardware.gnss@2.0',
    'android.hardware.gnss@2.1',
    'android.hardware.graphics.composer@2.1',
    'android.hardware.graphics.composer@2.1-resources',
    'android.hardware.graphics.composer@2.2',
    'android.hardware.graphics.composer@2.2-resources',
    'android.hardware.graphics.composer@2.3',
    'android.hardware.graphics.composer@2.4',
    'android.hardware.light-V1-ndk',
    'android.hardware.light@2.0',
    'android.hardware.media.c2@1.0',
    'android.hardware.media.c2@1.1',
    'android.hardware.media.c2@1.2',
    'android.hardware.power@1.0',
    'android.hardware.power@1.1',
    'android.hardware.power@1.2',
    'android.hardware.radio@1.0',
    'android.hardware.radio@1.1',
    'android.hardware.radio@1.2',
    'android.hardware.secure_element@1.0',
    'android.hardware.secure_element@1.1',
    'android.hardware.secure_element@1.2',
    'android.hardware.security.keymint-V1-ndk',
    'android.hardware.sensors@1.0',
    'android.hardware.sensors@2.0',
    'android.hardware.sensors@2.0-ScopedWakelock',
    'android.hardware.sensors@2.1',
    'android.hardware.soundtrigger@2.1',
    'android.hardware.soundtrigger@2.2',
    'android.hardware.soundtrigger@2.3',
    'android.hardware.tetheroffload.config@1.0',
    'android.hardware.tetheroffload.control@1.0',
    'android.hardware.tetheroffload.control@1.1',
    'android.hardware.thermal@1.0',
    'android.hardware.thermal@2.0',
    'android.hardware.usb.gadget@1.0',
    'android.hardware.usb.gadget@1.1',
    'android.hardware.wifi@1.0',
    'android.hardware.wifi@1.1',
    'android.hardware.wifi@1.2',
    'android.hardware.wifi@1.3',
    'android.hardware.wifi@1.4',
    'android.hardware.wifi@1.5',
    'android.hardware.wifi@1.6',
    'android.hidl.allocator@1.0',
    'android.media.audio.common.types-V1-cpp',
    'android.system.keystore2-V1-ndk',
    'android.system.wifi.keystore@1.0',
    'audioclient-types-aidl-cpp',
    'framework-permission-aidl-cpp',
    'lib_android_keymaster_keymint_utils',
    'libalsautils',
    'libaudioclient_aidl_conversion',
    'libaudiofoundation',
    'libavservices_minijail',
    'libbinderdebug',
    'libcodec2_hidl@1.0',
    'libcodec2_hidl@1.1',
    'libcodec2_hidl@1.2',
    'libcodec2_soft_common',
    'libcodec2_vndk',
    'libcppbor_external',
    'libcppcose_rkp',
    'libdrm',
    'libeffectsconfig',
    'libext2_blkid',
    'libext2_com_err',
    'libext2_e2p',
    'libext2_misc',
    'libext2_quota',
    'libext2_uuid',
    'libext2fs',
    'libflatbuffers-cpp',
    'libhidltransport',
    'libhwbinder',
    'libkeymaster_messages',
    'libkeymaster_portable',
    'libkeymint',
    'libladder',
    'libmediautils_vendor',
    'libmemunreachable',
    'libopus',
    'libpcap',
    'libprotobuf-cpp-full-3.9.1',
    'libprotobuf-cpp-lite-3.9.1',
    'libpuresoftkeymasterdevice',
    'libruy',
    'libsfplugin_ccodec_utils',
    'libshmemcompat',
    'libshmemutil',
    'libsoft_attestation_cert',
    'libsparse',
    'libstagefright_amrnb_common',
    'libstagefright_bufferpool@2.0.1',
    'libstagefright_enc_common',
    'libstagefright_flacdec',
    'libstagefright_softomx',
    'libtextclassifier_hash',
    'libvorbisidec',
    'libvpx',
    'shared-file-region-aidl-cpp',
    'vendor.mediatek.hardware.mtkpower@1.0',
    'vendor.mediatek.hardware.mtkpower@1.1',
    'vendor.mediatek.hardware.mtkpower@1.2',
)


def blob_fixup_v33():
    fixup = blob_fixup()
    for lib in v33_libs:
        fixup = fixup.replace_needed(f'{lib}.so', f'{lib}-v33.so')
    return fixup


blob_fixups: blob_fixups_user_type = {
    (
        'vendor/bin/hw/vendor.lenovo.hardware.factory-service',
    ): blob_fixup_v33(),
}  # fmt: skip

module = ExtractUtilsModule(
    'sycamore_row_5G',
    'motorola',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device_with_common(module, 'mt6835-common', module.vendor)
    utils.run()

    common = import_module(
        'motorola_mt6835-common',
        path.join(
            path.dirname(path.realpath(__file__)),
            '../mt6835-common/extract-files.py',
        ),
    )
    common.postprocess_makefiles()
