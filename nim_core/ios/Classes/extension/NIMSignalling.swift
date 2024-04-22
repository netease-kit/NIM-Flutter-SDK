// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

extension NIMSignalingNotifyInfo {
  func eventToDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channelBaseInfo"] = channelInfo.toDict()
      jsonObject["fromAccountId"] = fromAccountId
      jsonObject["customInfo"] = customInfo
      jsonObject["eventType"] = FLTSignalingEventType.convert(type: eventType).rawValue
      jsonObject["time"] = Int(time)
      return jsonObject
    }
    return nil
  }

  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["signallingEvent"] = eventToDict()
      switch eventType {
      case .join:
        if let notify = self as? NIMSignalingJoinNotifyInfo,
           let joinMember = notify.member.toDict() {
          jsonObject["joinMember"] = joinMember
        }
      case .invite:
        if let notify = self as? NIMSignalingInviteNotifyInfo,
           let pushConfig = notify.push.toDict() {
          jsonObject["pushConfig"] = pushConfig
          jsonObject["toAccountId"] = notify.toAccountId
          jsonObject["requestId"] = notify.requestId
        }
      case .cancelInvite:
        if let notify = self as? NIMSignalingCancelInviteNotifyInfo {
          jsonObject["toAccountId"] = notify.toAccountId
          jsonObject["requestId"] = notify.requestId
        }
      case .reject:
        if let notify = self as? NIMSignalingRejectNotifyInfo {
          jsonObject["toAccountId"] = notify.toAccountId
          jsonObject["requestId"] = notify.requestId
          jsonObject["ackStatus"] = "reject"
        }
      case .accept:
        if let notify = self as? NIMSignalingAcceptNotifyInfo {
          jsonObject["toAccountId"] = notify.toAccountId
          jsonObject["requestId"] = notify.requestId
          jsonObject["ackStatus"] = "accept"
        }
      default:
        break
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMSignalingChannelDetailedInfo {
  func detailToDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channelBaseInfo"] = toDict()
      if members.count > 0 {
        let ret = members.map { member in
          member.toDict()
        }
        jsonObject["members"] = ret
      }
      return jsonObject
    }
    return nil
  }
}

extension NIMSignalingChannelInfo {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["channelId"] = channelId
      jsonObject["channelName"] = channelName
      jsonObject["type"] = FLTSignalingChannelType.convert(type: channelType)?.rawValue
      jsonObject["createTimestamp"] = Int(createTimeStamp)
      jsonObject["creatorAccountId"] = creatorId
      jsonObject["expireTimestamp"] = Int(expireTimeStamp)
      jsonObject["channelStatus"] = FLTSignnallingChannelStatus.convert(status: invalid)?
        .rawValue
      jsonObject["channelExt"] = channelExt
      return jsonObject
    }
    return nil
  }
}

extension NIMSignalingMemberInfo {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["accountId"] = accountId
      jsonObject["uid"] = Int(uid)
      jsonObject["joinTime"] = Int(createTimeStamp)
      jsonObject["expireTime"] = Int(expireTimeStamp)
      return jsonObject
    }
    return nil
  }
}

extension NIMSignalingPushInfo {
  func toDict() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["needPush"] = needPush
      jsonObject["pushTitle"] = pushTitle
      jsonObject["pushContent"] = pushContent
      jsonObject["pushPayload"] = pushPayload
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> NIMSignalingPushInfo {
    if let model = NIMSignalingPushInfo.yx_model(with: json) {
      if let needPush = json["needPush"] as? Bool {
        model.needPush = needPush
      }
      if let pushTitle = json["pushTitle"] as? String {
        model.pushTitle = pushTitle
      }
      if let pushContent = json["pushContent"] as? String {
        model.pushContent = pushContent
      }
      if let pushPayload = json["pushPayload"] as? [String: Any] {
        model.pushPayload = pushPayload
      }
      return model
    }
    return NIMSignalingPushInfo()
  }
}

extension NIMSignalingInviteRequest {
  static func fromDic(_ json: [String: Any]) -> NIMSignalingInviteRequest {
    if let model = NIMSignalingInviteRequest.yx_model(with: json) {
      if let accId = json["accountId"] as? String {
        model.accountId = accId
      }
      if let channelId = json["channelId"] as? String {
        model.channelId = channelId
      }
      if let requestId = json["requestId"] as? String {
        model.requestId = requestId
      }
      if let customInfo = json["customInfo"] as? String {
        model.customInfo = customInfo
      }
      if let offlineEnabled = json["offlineEnabled"] as? Bool {
        model.offlineEnabled = offlineEnabled
      }
      if let pushConfig = json["pushConfig"] as? [String: Any] {
        model.push = NIMSignalingPushInfo.fromDic(pushConfig)
      }
      return model
    }
    return NIMSignalingInviteRequest()
  }
}

extension NIMSignalingCancelInviteRequest {
  static func fromDic(_ json: [String: Any]) -> NIMSignalingCancelInviteRequest {
    if let model = NIMSignalingCancelInviteRequest.yx_model(with: json) {
      if let accId = json["accountId"] as? String {
        model.accountId = accId
      }
      if let channelId = json["channelId"] as? String {
        model.channelId = channelId
      }
      if let requestId = json["requestId"] as? String {
        model.requestId = requestId
      }
      if let customInfo = json["customInfo"] as? String {
        model.customInfo = customInfo
      }
      if let offlineEnabled = json["offlineEnabled"] as? Bool {
        model.offlineEnabled = offlineEnabled
      }
      return model
    }
    return NIMSignalingCancelInviteRequest()
  }
}

extension NIMSignalingRejectRequest {
  static func fromDic(_ json: [String: Any]) -> NIMSignalingRejectRequest {
    if let model = NIMSignalingRejectRequest.yx_model(with: json) {
      if let accId = json["accountId"] as? String {
        model.accountId = accId
      }
      if let channelId = json["channelId"] as? String {
        model.channelId = channelId
      }
      if let requestId = json["requestId"] as? String {
        model.requestId = requestId
      }
      if let customInfo = json["customInfo"] as? String {
        model.customInfo = customInfo
      }
      if let offlineEnabled = json["offlineEnabled"] as? Bool {
        model.offlineEnabled = offlineEnabled
      }
      return model
    }
    return NIMSignalingRejectRequest()
  }
}

extension NIMSignalingAcceptRequest {
  static func fromDic(_ json: [String: Any]) -> NIMSignalingAcceptRequest {
    if let model = NIMSignalingAcceptRequest.yx_model(with: json) {
      if let accId = json["accountId"] as? String {
        model.accountId = accId
      }
      if let channelId = json["channelId"] as? String {
        model.channelId = channelId
      }
      if let requestId = json["requestId"] as? String {
        model.requestId = requestId
      }
      if let customInfo = json["customInfo"] as? String {
        model.acceptCustomInfo = customInfo
      }
      if let offlineEnabled = json["offlineEnabled"] as? Bool {
        model.offlineEnabled = offlineEnabled
      }
      return model
    }
    return NIMSignalingAcceptRequest()
  }
}

extension NIMSignalingCallRequest {
  static func fromDic(_ json: [String: Any]) -> NIMSignalingCallRequest {
    if let model = NIMSignalingCallRequest.yx_model(with: json) {
      if let channelType = json["channelType"] as? String {
        if let type = FLTSignalingChannelType(rawValue: channelType)?
          .convertNIMSignalingChannelType() {
          model.channelType = type
        }
      }

      if let accId = json["accountId"] as? String {
        model.accountId = accId
      }
      if let selfUid = json["selfUid"] as? UInt64 {
        model.uid = selfUid
      }
      if let requestId = json["requestId"] as? String {
        model.requestId = requestId
      }

      if let channelName = json["channelName"] as? String {
        model.channelName = channelName
      }

      if let channelExt = json["channelExt"] as? String {
        model.channelExt = channelExt
      }

      if let customInfo = json["customInfo"] as? String {
        model.customInfo = customInfo
      }
      if let offlineEnabled = json["offlineEnable"] as? Bool {
        model.offlineEnabled = offlineEnabled
      }
      if let pushConfig = json["pushConfig"] as? [String: Any] {
        model.push = NIMSignalingPushInfo.fromDic(pushConfig)
      }
      return model
    }
    return NIMSignalingCallRequest()
  }
}
