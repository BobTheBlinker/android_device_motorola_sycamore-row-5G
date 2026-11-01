/*
 * SPDX-FileCopyrightText: 2023 The LineageOS Project
 * SPDX-FileCopyrightText: 2026 BOBtheBlinker
 * SPDX-License-Identifier: Apache-2.0
 *
 * Derived from LineageOS/android_device_xiaomi_pipa peripheralmanager/.
 */

package org.lineageos.sycamoreperipheralmanager;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class BootCompletedReceiver extends BroadcastReceiver {

    private static final String TAG = "SycamorePeripheralManager";

    @Override
    public void onReceive(final Context context, Intent intent) {
        if (!Intent.ACTION_LOCKED_BOOT_COMPLETED.equals(intent.getAction())) {
            return;
        }
        Log.i(TAG, "Boot completed; starting peripheral listeners");
        PenUtils.setup(context);
        KeyboardUtils.setup(context);
    }
}
