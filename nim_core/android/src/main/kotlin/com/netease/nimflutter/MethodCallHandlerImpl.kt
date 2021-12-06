/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import android.app.Activity
import android.content.Context
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import kotlinx.coroutines.CoroutineScope

class MethodCallHandlerImpl(
    applicationContext: Context,
) : MethodChannel.MethodCallHandler {
    private val tag = "FLTMethodCallHandlerImpl"
    private var safeMethodChannel: SafeMethodChannel? = null
    private val nimCore = NimCore.getInstance(applicationContext)
    
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        nimCore.onMethodCall(call.method, call.arguments(), SafeResult(result))
    }

    fun startListening(messenger: BinaryMessenger) {
        if (safeMethodChannel != null) {
            ALog.e(tag, "Setting a method call handler before the last was disposed.")
            stopListening()
        }
        safeMethodChannel = SafeMethodChannel(messenger, "flutter.yunxin.163.com/nim_core")
        safeMethodChannel!!.setMethodCallHandler(this)
        nimCore.methodChannel = safeMethodChannel
    }

    fun stopListening() {
        if (safeMethodChannel == null) {
            ALog.e(tag, "Tried to stop listening when no MethodChannel had been initialized.")
            return
        }
        nimCore.methodChannel = null
        safeMethodChannel!!.setMethodCallHandler(null)
        safeMethodChannel = null
    }

    fun setActivity(activity: Activity?) {
        nimCore.activity = activity
    }
}