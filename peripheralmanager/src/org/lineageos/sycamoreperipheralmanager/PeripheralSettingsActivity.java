/*
 * SPDX-FileCopyrightText: 2023 The LineageOS Project
 * SPDX-FileCopyrightText: 2026 BOBtheBlinker
 * SPDX-License-Identifier: Apache-2.0
 *
 * Derived from LineageOS/android_device_xiaomi_pipa peripheralmanager/.
 */

package org.lineageos.sycamoreperipheralmanager;

import android.os.Bundle;

import com.android.settingslib.collapsingtoolbar.CollapsingToolbarBaseActivity;

public class PeripheralSettingsActivity extends CollapsingToolbarBaseActivity {

    private static final String TAG_PERIPHERAL = "peripheral";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        getFragmentManager().beginTransaction().replace(
                com.android.settingslib.collapsingtoolbar.R.id.content_frame,
                new PeripheralSettingsFragment(), TAG_PERIPHERAL).commit();
    }
}
