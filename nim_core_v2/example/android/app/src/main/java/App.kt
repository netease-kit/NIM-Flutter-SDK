// ktlint-disable filename
/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */
package com.netease.nimflutter.nimcore.example

import android.app.Application
import java.io.File
import java.io.FileOutputStream
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class App : Application() {

    override fun onCreate() {
        super.onCreate()
        copyAssetFile()
    }

    fun copyAssetFile() {
        listOf("test.jpg", "test.mp3", "test.mp4").forEach { name ->
            GlobalScope.launch {
                resources.assets.open(name).copyTo(
                    FileOutputStream(File("${getExternalFilesDir(null)!!.absolutePath}/$name"))
                )
            }
        }
    }
}
