/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter.services

import android.content.Context
import com.netease.nimflutter.FLTService
import com.netease.nimflutter.NimCore
import com.netease.nimflutter.NimResult
import com.netease.nimflutter.extension.toMap
import com.netease.nimlib.sdk.v2.utils.V2NIMClientAntispamUtil

class FLTClientAntispamUtil(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {
    override val serviceName = "V2NIMClientAntispamUtil"

    init {
        registerFlutterMethodCalls(
            "checkTextAntispam" to ::checkTextAntispam
        )
    }

    private suspend fun checkTextAntispam(arguments: Map<String, *>): NimResult<Map<String, Any?>?> {
        val text = arguments["text"] as? String ?: return NimResult(
            code = -1,
            errorDetails = "text is null"
        )
        val replace = arguments["replace"] as? String
        val result = V2NIMClientAntispamUtil.checkTextAntispam(text, replace)
        return NimResult(code = 0, data = result?.toMap())
    }
}
