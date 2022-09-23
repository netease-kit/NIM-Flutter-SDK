/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

import com.netease.nimlib.sdk.RequestCallback
import kotlin.coroutines.Continuation

data class NimResult<T>(
    private val code: Int,
    private val data: T? = null,
    private val errorDetails: String? = null,
    private val convert: ((data: T) -> Map<String, Any?>)? = null
) {

    val isSuccess = code == 0 || code == 200

    fun toMap(): Map<String, Any?> {
        return mapOf(
            "code" to code,
            "errorDetails" to errorDetails,
            "data" to if (data != null && convert != null) convert.invoke(data) else data
        )
    }

    companion object {
        val FAILURE = NimResult<Nothing>(code = -1)

        val SUCCESS = NimResult<Nothing>(code = 0)

        inline fun <T> failure(exception: Throwable?): NimResult<T> =
            NimResult(code = -1, errorDetails = exception?.message)
    }
}

class NimResultCallback<T>(
    private val resultCallback: ResultCallback<T>,
    private val handler: ((T?) -> NimResult<T>)? = null
) : RequestCallback<T> {

    constructor(
        safeResult: SafeResult,
        handler: ((T?) -> NimResult<T>)? = null
    ) : this(ResultCallback<T>(safeResult), handler)

    override fun onSuccess(param: T?) {
        resultCallback.result(handler?.invoke(param) ?: NimResult(code = 0, data = param))
    }

    override fun onFailed(code: Int) {
        resultCallback.result(NimResult<T>(code = code))
    }

    override fun onException(exception: Throwable?) {
        resultCallback.result(NimResult.failure<T>(exception))
    }
}

class NimResultContinuationCallback<T>(
    private val continuation: Continuation<NimResult<T>>,
    private val handler: ((T?) -> NimResult<T>)? = null
) : RequestCallback<T> {

    override fun onSuccess(param: T?) {
        continuation.resumeWith(
            Result.success(
                handler?.invoke(param) ?: NimResult(
                    code = 0,
                    data = param
                )
            )
        )
    }

    override fun onFailed(code: Int) {
        continuation.resumeWith(Result.success(NimResult(code = code)))
    }

    override fun onException(exception: Throwable?) {
        continuation.resumeWith(Result.success(NimResult.failure(exception)))
    }
}

class NimResultContinuationCallbackOfNothing(
    private val continuation: Continuation<NimResult<Nothing>>
) : RequestCallback<Void> {

    override fun onSuccess(param: Void?) {
        continuation.resumeWith(Result.success(NimResult.SUCCESS))
    }

    override fun onFailed(code: Int) {
        continuation.resumeWith(Result.success(NimResult(code = code)))
    }

    override fun onException(exception: Throwable?) {
        continuation.resumeWith(Result.success(NimResult.failure(exception)))
    }
}
