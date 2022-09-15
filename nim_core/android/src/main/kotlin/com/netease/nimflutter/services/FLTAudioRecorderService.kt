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
import com.netease.nimlib.sdk.media.record.AudioRecorder
import com.netease.nimlib.sdk.media.record.IAudioRecordCallback
import com.netease.nimlib.sdk.media.record.RecordType
import java.io.File

class FLTAudioRecorderService(
    applicationContext: Context,
    nimCore: NimCore
) : FLTService(applicationContext, nimCore) {

    private var recordType: RecordType = RecordType.AAC
    private var maxLength: Int = AudioRecorder.DEFAULT_MAX_AUDIO_RECORD_TIME_SECOND

    private var mAudioRecordCallback: IAudioRecordCallback = object : IAudioRecordCallback {
        override fun onRecordReady() {
            notify("onRecordReady", mutableMapOf())
        }

        override fun onRecordStart(audioFile: File?, recordType: RecordType?) {
            val messageMap = mutableMapOf<String, Any?>()
            messageMap["filePath"] = audioFile?.path
            messageMap["recordType"] = recordType?.fileSuffix
            notify("onRecordStart", messageMap)
        }

        override fun onRecordSuccess(audioFile: File?, audioLength: Long, recordType: RecordType?) {
            val messageMap = mutableMapOf<String, Any?>()
            messageMap["filePath"] = audioFile?.path
            messageMap["recordType"] = recordType?.fileSuffix
            messageMap["fileSize"] = audioFile?.length()
            messageMap["duration"] = audioLength
            notify("onRecordSuccess", messageMap)
        }

        override fun onRecordFail() {
            notify("onRecordFail", mutableMapOf())
        }

        override fun onRecordCancel() {
            notify("onRecordCancel", mutableMapOf())
        }

        override fun onRecordReachedMaxTime(maxTime: Int) {
            val messageMap = mutableMapOf<String, Any?>()
            messageMap["maxDuration"] = maxTime
            notify("onRecordReachedMaxTime", mutableMapOf())
            mAudioRecorder.handleEndRecord(true, maxTime)
        }
    }
    private var mAudioRecorder: AudioRecorder = AudioRecorder(
        applicationContext,
        recordType,
        maxLength,
        mAudioRecordCallback
    )

    override val serviceName = "AudioRecorderService"

    init {
        registerFlutterMethodCalls(
            "startRecord" to ::startAudioRecord,
            "stopRecord" to ::stopAudioRecord,
            "cancelRecord" to ::cancelAudioRecord,
            "isAudioRecording" to ::isAudioRecord,
            "getAmplitude" to ::getCurrentRecordAmplitude
        )
    }

    // 通知事件，将播放的监听的状态信息，通过该方法回调给Flutter层
    private fun notify(state: String, arguments: MutableMap<String, Any?>) {
        arguments["recordState"] = state
        notifyEvent("onRecordStateChange", arguments)
    }

    private suspend fun startAudioRecord(arguments: Map<String, *>): NimResult<Boolean> {
        // 如果正在录制，需要停止
        if (mAudioRecorder.isRecording) {
            mAudioRecorder.completeRecord(true)
        }
        var type = recordType
        var maxLen = maxLength
        if (arguments["recordType"] != null) {
            type =
                if ((arguments["recordType"] as Number).toInt() == 0) RecordType.AAC else RecordType.AMR
        }
        if (arguments["maxLength"] != null) {
            maxLen = (arguments["maxLength"] as Number).toInt()
        }
        // 配置参数发送变化，需要重新创建AudioRecord
        if (type != recordType || maxLen != maxLength) {
            mAudioRecorder.destroyAudioRecorder()
            recordType = type
            maxLength = maxLen
            mAudioRecorder = AudioRecorder(
                applicationContext,
                recordType,
                maxLength,
                mAudioRecordCallback
            )
        }
        mAudioRecorder.startRecord()
        return NimResult(code = 0, data = true)
    }

    @Suppress("UNUSED_PARAMETER")
    private suspend fun stopAudioRecord(arguments: Map<String, *>): NimResult<Nothing> {
        mAudioRecorder.completeRecord(false)
        return NimResult.SUCCESS
    }

    @Suppress("UNUSED_PARAMETER")
    private suspend fun cancelAudioRecord(arguments: Map<String, *>): NimResult<Nothing> {
        mAudioRecorder.completeRecord(true)
        return NimResult.SUCCESS
    }

    @Suppress("UNUSED_PARAMETER")
    private suspend fun isAudioRecord(arguments: Map<String, *>): NimResult<Boolean> =
        NimResult(code = 0, data = mAudioRecorder.isRecording)

    @Suppress("UNUSED_PARAMETER")
    private suspend fun getCurrentRecordAmplitude(arguments: Map<String, *>): NimResult<Int> =
        NimResult(code = 0, data = mAudioRecorder.currentRecordMaxAmplitude)
}
