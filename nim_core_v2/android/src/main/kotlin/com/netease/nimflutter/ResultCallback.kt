/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

package com.netease.nimflutter

class ResultCallback<T>(private val safeResult: SafeResult) {
    fun result(data: NimResult<T>) {
        safeResult.success(data.toMap())
    }
}
