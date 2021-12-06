package com.netease.nimflutter.nim_core_example

import android.app.Application
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.io.File
import java.io.FileOutputStream

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