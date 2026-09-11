// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension V2NIMSendMessageParams {
  /// 转换为对象， 用keypath 取属性作为 key 值
  /// - Returns: 对象
  static func fromDic(_ arguments: [String: Any]) -> V2NIMSendMessageParams {
    let attach = V2NIMSendMessageParams()

    if let messageConfig = arguments["messageConfig"] as? [String: Any] {
      attach.messageConfig = V2NIMMessageConfig.fromDic(messageConfig)
    }

    if let routeConfig = arguments["routeConfig"] as? [String: Any] {
      attach.routeConfig = V2NIMMessageRouteConfig.fromDic(routeConfig)
    }

    if let pushConfig = arguments["pushConfig"] as? [String: Any] {
      attach.pushConfig = V2NIMMessagePushConfig.fromDic(pushConfig)
    }

    if let antispamConfig = arguments["antispamConfig"] as? [String: Any] {
      attach.antispamConfig = V2NIMMessageAntispamConfig.fromDic(antispamConfig)
    }

    if let robotConfig = arguments["robotConfig"] as? [String: Any] {
      attach.robotConfig = V2NIMMessageRobotConfig.fromDic(robotConfig)
    }

    if let aiConfig = arguments["aiConfig"] as? [String: Any] {
      attach.aiConfig = V2NIMMessageAIConfigParams.fromDic(aiConfig)
    }

    if let targetConfig = arguments["targetConfig"] as? [String: Any] {
      attach.targetConfig = V2NIMMessageTargetConfig.fromDic(targetConfig)
    }

    if let clientAntispamEnabled = arguments["clientAntispamEnabled"] as? Bool {
      attach.clientAntispamEnabled = clientAntispamEnabled
    }

    if let clientAntispamReplace = arguments["clientAntispamReplace"] as? String {
      attach.clientAntispamReplace = clientAntispamReplace
    }

    return attach
  }

  /// 转换为字典， 用keypath 取属性作为 key 值
  /// - Returns: 字典
  func toDic() -> [String: Any] {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(V2NIMSendMessageParams.messageConfig)] = messageConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.routeConfig)] = routeConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.pushConfig)] = pushConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.antispamConfig)] = antispamConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.robotConfig)] = robotConfig.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.aiConfig)] = aiConfig?.toDic()
    keyPaths[#keyPath(V2NIMSendMessageParams.clientAntispamEnabled)] = clientAntispamEnabled
    keyPaths[#keyPath(V2NIMSendMessageParams.clientAntispamReplace)] = clientAntispamReplace
    return keyPaths
  }
}
