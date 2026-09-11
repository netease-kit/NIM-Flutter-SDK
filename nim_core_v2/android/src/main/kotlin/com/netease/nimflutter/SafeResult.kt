/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CancellableContinuation

class SafeResult(private val unsafeResult: Result) : Result {

    private var handler: Handler = Handler(Looper.getMainLooper())

    override fun success(result: Any?) {
        runOnMainThread { unsafeResult.success(result) }
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        runOnMainThread { unsafeResult.error(errorCode, errorMessage, errorDetails) }
    }

    override fun notImplemented() {
        runOnMainThread(unsafeResult::notImplemented)
    }

    private fun runOnMainThread(runnable: () -> Unit) {
        if (Looper.getMainLooper() == Looper.myLooper()) {
            runnable()
        } else {
            handler.post(runnable)
        }
    }
}

class MethodChannelError(
    private val errorCode: String?,
    private val errorMessage: String?,
    private val errorDetails: Any?
) : Exception()

class MethodChannelSuspendResult(
    private val continuation: CancellableContinuation<Any?>
) : Result {

    override fun success(result: Any?) {
        if (continuation.isActive) {
            continuation.resumeWith(kotlin.Result.success(result))
        }
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        if (continuation.isActive) {
            continuation.resumeWith(
                kotlin.Result.failure(
                    MethodChannelError(
                        errorCode,
                        errorMessage,
                        errorDetails
                    )
                )
            )
        }
    }

    override fun notImplemented() {
        if (continuation.isActive) {
            continuation.resumeWith(kotlin.Result.failure(NotImplementedError()))
        }
    }
}

// 原生回调dart层超时限制 30s
const val nimProviderTimeout = 30 * 1000L
