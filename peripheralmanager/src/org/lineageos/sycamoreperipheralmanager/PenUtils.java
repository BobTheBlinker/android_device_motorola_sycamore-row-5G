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
 * Tracks the Lenovo Tab Pen Plus (BT HID, 0x17ef:0x617f). Phase 0: just logs
 * connect/disconnect and exposes a presence query for the Settings page.
 */
public final class PenUtils {

    private static final String TAG = "SycamorePeripheralManagerPen";

    // 0x17ef = 6127 (Lenovo), 0x617f = 24959 (Tab Pen Plus)
    static final int PEN_VENDOR_ID = 0x17ef;
    static final int PEN_PRODUCT_ID = 0x617f;

    private static InputManager sInputManager;
    private static final Set<Integer> sKnownIds = new HashSet<>();

    private PenUtils() {
    }

    public static void setup(Context context) {
        if (sInputManager == null) {
            sInputManager = (InputManager) context.getSystemService(Context.INPUT_SERVICE);
        }
        sKnownIds.clear();
        for (int id : sInputManager.getInputDeviceIds()) {
            if (isPen(sInputManager, id)) {
                sKnownIds.add(id);
            }
        }
        sInputManager.registerInputDeviceListener(sListener, null);
        Log.i(TAG, "Listening; pen " + (sKnownIds.isEmpty() ? "not connected" : "connected")
                + " at boot");
    }

    /** True if a Tab Pen Plus input device is currently present. */
    public static boolean isConnected(InputManager inputManager) {
        for (int id : inputManager.getInputDeviceIds()) {
            if (isPen(inputManager, id)) {
                return true;
            }
        }
        return false;
    }

    private static boolean isPen(InputManager inputManager, int id) {
        InputDevice device = inputManager.getInputDevice(id);
        return device != null
                && device.getVendorId() == PEN_VENDOR_ID
                && device.getProductId() == PEN_PRODUCT_ID;
    }

    private static final InputDeviceListener sListener = new InputDeviceListener() {
        @Override
        public void onInputDeviceAdded(int id) {
            if (isPen(sInputManager, id)) {
                sKnownIds.add(id);
                Log.i(TAG, "Pen connected (device " + id + ")");
            }
        }

        @Override
        public void onInputDeviceRemoved(int id) {
            // The device is already gone, so we can't query its IDs; use the tracked set.
            if (sKnownIds.remove(id)) {
                Log.i(TAG, "Pen disconnected (device " + id + ")");
            }
        }

        @Override
        public void onInputDeviceChanged(int id) {
        }
    };
}
