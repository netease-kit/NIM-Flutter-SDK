/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import android.content.Context
import com.netease.yunxin.kit.alog.ALog
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.launch

typealias FlutterMethodCall<T> = suspend (arguments: Map<String, *>) -> NimResult<T>

abstract class FLTService(
    val applicationContext: Context,
    val nimCore: NimCore
) {
    abstract val serviceName: String

    private val flutterMethodCallRegistry = hashMapOf<String, FlutterMethodCall<*>>()

    fun registerFlutterMethodCalls(vararg methods: Pair<String, FlutterMethodCall<*>>) =
        flutterMethodCallRegistry.putAll(methods)

    @Deprecated("replace with registerFlutterMethodCalls")
    open fun onMethodCalled(method: String, arguments: Map<String, *>, safeResult: SafeResult) {
        safeResult.notImplemented()
    }

    fun dispatchFlutterMethodCall(
        method: String,
        arguments: Map<String, *>,
        safeResult: SafeResult
    ) {
        flutterMethodCallRegistry[method]?.let { func ->
            nimCore.lifeCycleScope.launch {
                runCatching {
                    func(arguments)
                }.fold(
                    onSuccess = { data -> safeResult.success(data.toMap()) },
                    onFailure = { exception ->
                        ALog.e("${serviceName}_K", "$method onException", exception)
                        safeResult.success(
                            NimResult<Nothing>(code = -1, errorDetails = exception.message).toMap()
                        )
                    }
                )
            }
        } ?: runCatching {
            onMethodCalled(method, arguments, safeResult)
        }.onFailure { exception ->
            ALog.e("${serviceName}_K", "$method onException", exception)
            safeResult.success(
                NimResult<Nothing>(code = -1, errorDetails = exception.message).toMap()
            )
        }
    }

    protected fun notifyEvent(
        method: String,
        arguments: Map<String, Any?>,
        callback: MethodChannel.Result? = null
    ) {
        ALog.d("${serviceName}_K", "notifyEvent method = $method arguments = $arguments")
        val params = arguments.toMutableMap().also { args -> args["serviceName"] = serviceName }
        nimCore.methodChannel.forEach { channel ->
            channel.invokeMethod(
                method,
                params,
                callback
            )
        }
    }

    protected fun <T> onFailed(
        funcName: String,
        code: Int,
        resultCallback:
        ResultCallback<T>
    ) {
        println("$serviceName $funcName onFailed code = $code")
        ALog.d(serviceName, "$funcName onFailed code = $code")
        resultCallback.result(
            NimResult(
                code = code,
                errorDetails = "$funcName " +
                    "but onFailed code = $code!"
            )
        )
    }

    protected fun <T> onException(
        funcName: String,
        exception: Throwable?,
        resultCallback:
        ResultCallback<T>
    ) {
        println("$serviceName $funcName onFailed exception = ${exception?.message}")
        ALog.d(
            serviceName,
            "$funcName onFailed exception = ${exception?.message}"
        )
        resultCallback.result(
            NimResult(
                code = -1,
                errorDetails = "$funcName " +
                    "but onException exception = ${exception?.message}!"
            )
        )
    }
}
