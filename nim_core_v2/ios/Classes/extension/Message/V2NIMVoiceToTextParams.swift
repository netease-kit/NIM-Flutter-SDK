// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMVoiceToTextParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMVoiceToTextParams {
    let attach = V2NIMVoiceToTextParams()

    if let voicePath = arguments["voicePath"] as? String {
      attach.voicePath = voicePath
    }

    if let voiceUrl = arguments["voiceUrl"] as? String {
      attach.voiceUrl = voiceUrl
    }

    if let mimeType = arguments["mimeType"] as? String {
      attach.mimeType = mimeType
    }

    if let sampleRate = arguments["sampleRate"] as? String {
      attach.sampleRate = sampleRate
    }

    let duration = arguments["duration"] as? Int
    attach.duration = TimeInterval(duration ?? 0)

    if let sceneName = arguments["sceneName"] as? String {
      attach.sceneName = sceneName
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMVoiceToTextParams.voicePath)] = voicePath
    keyPaths[#keyPath(V2NIMVoiceToTextParams.voiceUrl)] = voiceUrl
    keyPaths[#keyPath(V2NIMVoiceToTextParams.mimeType)] = mimeType
    keyPaths[#keyPath(V2NIMVoiceToTextParams.sampleRate)] = sampleRate
    keyPaths[#keyPath(V2NIMVoiceToTextParams.duration)] = duration
    keyPaths[#keyPath(V2NIMVoiceToTextParams.sceneName)] = sceneName
    return keyPaths
  }
}
