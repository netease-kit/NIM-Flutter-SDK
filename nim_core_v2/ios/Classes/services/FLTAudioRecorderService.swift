// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum AudioRecorderType: String {
  case StartRecord = "startRecord"
  case StopRecord = "stopRecord"
  case CancelRecord = "cancelRecord"
  case AudioRecording = "isAudioRecording"
  case Amplitude = "getAmplitude"
}

class FLTAudioRecorderService: FLTBaseService, FLTService {
  lazy var mediaManager = NIMSDK.shared().mediaManager
  private var duration: Double = 0
  private var maxDuration: Double = 100

  func serviceName() -> String {
    ServiceType.AudioRecordService.rawValue
  }

  override func onInitialized() {
    NIMSDK.shared().mediaManager.add(self)
  }

  deinit {
    NIMSDK.shared().mediaManager.remove(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case AudioRecorderType.StartRecord.rawValue:
      startAudioRecord(arguments, resultCallback)
    case AudioRecorderType.StopRecord.rawValue:
      stopAudioRecord(arguments, resultCallback)
    case AudioRecorderType.CancelRecord.rawValue:
      cancelAudioRecord(arguments, resultCallback)
    case AudioRecorderType.AudioRecording.rawValue:
      isAudioRecord(arguments, resultCallback)
    case AudioRecorderType.Amplitude.rawValue:
      getCurrentRecordAmplitude(arguments, resultCallback)
    default:
      break
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func startAudioRecord(_ argument: [String: Any], _ result: ResultCallback) {
    duration = 0
    maxDuration = getDuration(argument)
    mediaManager.record(getRecordAudioType(argument), duration: maxDuration)
    successCallBack(result, true)
  }

  func stopAudioRecord(_ argument: [String: Any], _ result: ResultCallback) {
    mediaManager.stopRecord()
    successCallBack(result, true)
  }

  func cancelAudioRecord(_ argument: [String: Any], _ result: ResultCallback) {
    mediaManager.cancelRecord()
    successCallBack(result, true)
  }

  func isAudioRecord(_ argument: [String: Any], _ result: ResultCallback) {
    let success = mediaManager.isRecording()
    successCallBack(result, success)
  }

  func getCurrentRecordAmplitude(_ argument: [String: Any], _ result: ResultCallback) {
    let volume = Int(mediaManager.recordPeakPower())
    successCallBack(result, volume)
  }
}

extension FLTAudioRecorderService: NIMMediaManagerDelegate {
  func recordAudio(_ filePath: String?, didBeganWithError error: Error?) {
    var arguments = [String: Any]()
    arguments["filePath"] = filePath
    arguments["maxDuration"] = Int(maxDuration)
    if filePath != nil {
      if filePath!.hasSuffix("amr") {
        arguments["recordType"] = ".amr"
      } else if filePath!.hasSuffix("aac") {
        arguments["recordType"] = ".acc"
      }
    }
    notifyEvent("onRecordStart", &arguments)
  }

  func recordAudio(_ filePath: String?, didCompletedWithError error: Error?) {
    var arguments = [String: Any]()
    arguments["filePath"] = filePath
    arguments["duration"] = Int(duration)
    arguments["maxDuration"] = Int(maxDuration)
    if filePath != nil {
      do {
        let attr = try FileManager.default.attributesOfItem(atPath: filePath!)
        let fileSize = attr[FileAttributeKey.size] as? UInt64
        arguments["fileSize"] = fileSize
      } catch {
        print("Error: \(error)")
      }
      if filePath!.hasSuffix("amr") {
        arguments["recordType"] = ".amr"
      } else if filePath!.hasSuffix("aac") {
        arguments["recordType"] = ".acc"
      }
    }
    notifyEvent("onRecordSuccess", &arguments)
    duration = 0
  }

  func recordAudioProgress(_ currentTime: TimeInterval) {
    // 对齐安卓返回毫秒
    duration = currentTime * 1000
  }

  func recordAudioDidCancelled() {
    var arguments = [String: Any]()
    notifyEvent("onRecordCancel", &arguments)
  }

  func notifyEvent(_ state: String, _ arguments: inout [String: Any]) {
    arguments["serviceName"] = serviceName()
    arguments["recordState"] = state
    nimCore?.getMethodChannel()?.invokeMethod("onRecordStateChange", arguments)
  }
}
