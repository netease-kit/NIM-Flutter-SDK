/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import androidx.annotation.NonNull
import com.netease.yunxin.kit.alog.ALog
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class NimCorePlugin : FlutterPlugin, ActivityAware {

    private var channel: MethodCallHandlerImpl? = null

    private val tag = "NimCorePlugin"

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        ALog.i(tag, "on attached to engine.")
        channel = MethodCallHandlerImpl(
            flutterPluginBinding.applicationContext,
            flutterPluginBinding.flutterAssets
        )
        channel!!.startListening(flutterPluginBinding.binaryMessenger)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        if (channel == null) {
            ALog.e(tag, "Already detached from the engine.")
            return
        }
        ALog.i(tag, "on detached from engine.")
        channel!!.stopListening()
        channel = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        if (channel == null) {
            ALog.e(tag, "nimCore was never set.")
            return
        }
        ALog.i(tag, "on attached to activity.")
        channel!!.setActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        ALog.i(tag, "on detached from activity for config changes.")
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        ALog.i(tag, "on reattached to activity for config changes.")
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        if (channel == null) {
            ALog.e(tag, "nimCore was never set.")
            return
        }
        ALog.i(tag, "on detached from activity.")
        channel!!.setActivity(null)
    }
}
