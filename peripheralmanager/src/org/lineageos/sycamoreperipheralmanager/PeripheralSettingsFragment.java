/*
 * SPDX-FileCopyrightText: 2023 The LineageOS Project
 * SPDX-FileCopyrightText: 2026 BOBtheBlinker
 * SPDX-License-Identifier: Apache-2.0
 *
 * Derived from LineageOS/android_device_xiaomi_pipa peripheralmanager/.
 */

package org.lineageos.sycamoreperipheralmanager;

import android.content.Context;
import android.hardware.input.InputManager;
import android.hardware.input.InputManager.InputDeviceListener;
import android.os.Bundle;

import androidx.preference.Preference;
import androidx.preference.PreferenceFragment;

public class PeripheralSettingsFragment extends PreferenceFragment
        implements InputDeviceListener {

    private static final String KEY_PEN_STATUS = "pen_status";
    private static final String KEY_KEYBOARD_STATUS = "keyboard_status";

    private InputManager mInputManager;
    private Preference mPenStatus;
    private Preference mKeyboardStatus;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.peripheral_settings);

        mInputManager = (InputManager) getContext().getSystemService(Context.INPUT_SERVICE);
        mPenStatus = findPreference(KEY_PEN_STATUS);
        mKeyboardStatus = findPreference(KEY_KEYBOARD_STATUS);
    }

    @Override
    public void onResume() {
        super.onResume();
        mInputManager.registerInputDeviceListener(this, null);
        refresh();
    }

    @Override
    public void onPause() {
        super.onPause();
        mInputManager.unregisterInputDeviceListener(this);
    }

    private void refresh() {
        mPenStatus.setSummary(PenUtils.isConnected(mInputManager)
                ? R.string.status_connected : R.string.status_not_connected);
        mKeyboardStatus.setSummary(KeyboardUtils.isConnected(mInputManager)
                ? R.string.status_connected : R.string.status_not_connected);
    }

    @Override
    public void onInputDeviceAdded(int id) {
        refresh();
    }

    @Override
    public void onInputDeviceRemoved(int id) {
        refresh();
    }

    @Override
    public void onInputDeviceChanged(int id) {
        refresh();
    }
}
