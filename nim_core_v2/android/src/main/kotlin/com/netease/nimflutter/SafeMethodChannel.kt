/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class SafeMethodChannel(messenger: BinaryMessenger, name: String) {

    private val methodChannel: MethodChannel = MethodChannel(messenger, name)
    private val handler: Handler = Handler(Looper.getMainLooper())

    fun invokeMethod(method: String, arguments: Any?, callback: MethodChannel.Result? = null) {
        runOnMainThread { methodChannel.invokeMethod(method, arguments, callback) }
    }

    fun setMethodCallHandler(handler: MethodCallHandler?) {
        runOnMainThread { methodChannel.setMethodCallHandler(handler) }
    }

    private fun runOnMainThread(runnable: () -> Unit) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable()
        } else {
            handler.post(runnable)
        }
    }
}
