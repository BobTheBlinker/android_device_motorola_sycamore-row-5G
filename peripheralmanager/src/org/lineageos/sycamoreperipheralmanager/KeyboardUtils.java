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
import android.util.Log;
import android.view.InputDevice;

import java.util.HashSet;
import java.util.Set;

/**
 * Tracks the keyboard folio (USB HID, 0x17ef:0x61ba), which appears on dock and
 * disappears on undock / fold-to-tablet. Phase 0: just logs connect/disconnect
 * and exposes a presence query for the Settings page.
 */
public final class KeyboardUtils {

    private static final String TAG = "SycamorePeripheralManagerKeyboard";

    // 0x17ef = 6127 (Lenovo), 0x61ba = 25018 (keyboard folio)
    static final int KEYBOARD_VENDOR_ID = 0x17ef;
    static final int KEYBOARD_PRODUCT_ID = 0x61ba;

    private static InputManager sInputManager;
    private static final Set<Integer> sKnownIds = new HashSet<>();

    private KeyboardUtils() {
    }

    public static void setup(Context context) {
        if (sInputManager == null) {
            sInputManager = (InputManager) context.getSystemService(Context.INPUT_SERVICE);
        }
        sKnownIds.clear();
        for (int id : sInputManager.getInputDeviceIds()) {
            if (isKeyboard(sInputManager, id)) {
                sKnownIds.add(id);
            }
        }
        sInputManager.registerInputDeviceListener(sListener, null);
        Log.i(TAG, "Listening; folio " + (sKnownIds.isEmpty() ? "not connected" : "connected")
                + " at boot");
    }

    /** True if the keyboard folio input device is currently present. */
    public static boolean isConnected(InputManager inputManager) {
        for (int id : inputManager.getInputDeviceIds()) {
            if (isKeyboard(inputManager, id)) {
                return true;
            }
        }
        return false;
    }

    private static boolean isKeyboard(InputManager inputManager, int id) {
        InputDevice device = inputManager.getInputDevice(id);
        return device != null
                && device.getVendorId() == KEYBOARD_VENDOR_ID
                && device.getProductId() == KEYBOARD_PRODUCT_ID;
    }

    private static final InputDeviceListener sListener = new InputDeviceListener() {
        @Override
        public void onInputDeviceAdded(int id) {
            if (isKeyboard(sInputManager, id)) {
                sKnownIds.add(id);
                Log.i(TAG, "Keyboard folio connected (device " + id + ")");
            }
        }

        @Override
        public void onInputDeviceRemoved(int id) {
            // The device is already gone, so we can't query its IDs; use the tracked set.
            if (sKnownIds.remove(id)) {
                Log.i(TAG, "Keyboard folio disconnected (device " + id + ")");
            }
        }

        @Override
        public void onInputDeviceChanged(int id) {
        }
    };
}
