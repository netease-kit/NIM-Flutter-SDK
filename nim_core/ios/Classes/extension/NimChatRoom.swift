// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMChatroomEnterRequest: NimDataConvertProtrol {
  @objc static func modelPropertyBlacklist() -> [String] {
    [
      #keyPath(NIMChatroomEnterRequest.roomExt),
      #keyPath(NIMChatroomEnterRequest.roomNotifyExt),
      #keyPath(NIMChatroomEnterRequest.tags),
    ]
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(NIMChatroomEnterRequest.roomNickname)] = "nickname"
    keyPaths[#keyPath(NIMChatroomEnterRequest.roomAvatar)] = "avatar"
    return keyPaths
  }

  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomEnterRequest.yx_model(with: json) {
      if let tagList = json["tags"] as? [String],
         let tagsString = model.getJsonStringFromArray(tagList) {
        model.tags = tagsString
      }
      if let notifyExtension = json["notifyExtension"] as? [String: Any],
         let notifyExt = model.getJsonStringFromDictionary(notifyExtension) {
        model.roomNotifyExt = notifyExt
      }
      if let extensionDic = json["extension"] as? [String: Any],
         let roomExt = model.getJsonStringFromDictionary(extensionDic) {
        model.roomExt = roomExt
      }
      if let notifyTargetTags = json["notifyTargetTags"] as? String {
        model.notifyTargetTags = notifyTargetTags
      }
      if let independentMode = json["independentModeConfig"] as? [String: Any] {
        model.mode = NIMChatroomIndependentMode()
        model.mode!.username = independentMode["account"] as? String
        model.mode!.token = independentMode["token"] as? String
        model.mode!.chatroomAppKey = independentMode["appKey"] as? String
      }
      if let nickname = json["nickname"] as? String {
        model.roomNickname = nickname
      }
      if let avatar = json["avatar"] as? String {
        model.roomAvatar = avatar
      }
      if let retryCount = json["retryCount"] as? Int {
        model.retryCount = retryCount
      }
      if let loginAuthType = json["loginAuthType"] as? Int {
        model.loginAuthType = NIMChatroomLoginAuthType(rawValue: loginAuthType) ?? .default
      }
      return model
    }
    return nil
  }
}

extension NIMChatroom: NimDataConvertProtrol {
  dynamic var flt_queueModificationLevel: FLT_QueueModificationLevel? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_queueModificationLevel".hashValue)!
      ) as? FLT_QueueModificationLevel {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_queueModificationLevel".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

//    @objc static func modelCustomPropertyMapper() -> [String : Any]? {
//        var keyPaths = [String : Any]()
//        return keyPaths
//    }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["mute"] = inAllMuteMode() ? 1 : 0
      let flt_queue = FLT_QueueModificationLevel.convert(queueModificationLevel)
      jsonObject["queueModificationLevel"] = flt_queue?.rawValue
      if let extString = ext, let extDic = getDictionaryFromJSONString(extString) {
        jsonObject["extension"] = extDic
      }
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroom.yx_model(with: json) {
      if let level = json["queueModificationLevel"] as? String,
         let flt_level = FLT_QueueModificationLevel(rawValue: level) {
        model.flt_queueModificationLevel = flt_level
        model.queueModificationLevel = flt_level.convertToNIMLevel()
      }
      if let extensionDic = json["extension"] as? [String: Any] {
        model.ext = model.getJsonStringFromDictionary(extensionDic)
      }
      return model
    }
    return nil
  }
}

extension NIMChatroomMember: NimDataConvertProtrol {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(NIMChatroomMember.userId)] = "account"
    keyPaths[#keyPath(NIMChatroomMember.roomNickname)] = "nickname"
    keyPaths[#keyPath(NIMChatroomMember.roomAvatar)] = "avatar"
    keyPaths[#keyPath(NIMChatroomMember.enterTimeInterval)] = "enterTime"
    return keyPaths
  }

  func toDic(roomId: String?) -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["roomId"] = roomId
      jsonObject["account"] = userId
      jsonObject["memberType"] = FLT_NIMChatroomMemberType.convert(type)?.rawValue
      jsonObject["nickname"] = roomNickname != nil ? roomNickname : userId
      jsonObject["avatar"] = roomAvatar != nil ? roomAvatar : ""
      if let roomExtensionString = roomExt,
         let extensionDic = getDictionaryFromJSONString(roomExtensionString) {
        jsonObject["extension"] = extensionDic
      }
      if var tgs = tags {
        jsonObject["tags"] = getArrayFromJSONString(tgs)
      }
      jsonObject["enterTime"] = Int(enterTimeInterval * 1000)
      jsonObject["isValid"] = jsonObject["isVaild"]
      return jsonObject
    }
    return nil
  }

  func toDic() -> [String: Any]? {
    toDic(roomId: "")
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomMember.yx_model(with: json) {
      if let membeType = json["memberType"] as? String,
         let fltType = FLT_NIMChatroomMemberType(rawValue: membeType),
         let t = fltType.convertNIMMemberType() {
        if let extensionDic = json["extension"] as? [String: Any],
           let extensionString = model.getJsonStringFromDictionary(extensionDic) {
          model.roomExt = extensionString
        }
        model.type = t
      }
      return model
    }
    return nil
  }
}

extension NIMHistoryMessageSearchOption: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMHistoryMessageSearchOption.yx_model(with: json) {
      if let messageTypeList = json["messageTypeList"] as? [String] {
        var messageTypes = [NSNumber]()
        messageTypeList.forEach { value in
          if let type = FLT_NIMMessageType(rawValue: value)?.convertToNIMMessageType()?
            .rawValue {
            let num = NSNumber(integerLiteral: type)
            messageTypes.append(num)
          }
        }
        model.messageTypes = messageTypes
      }
      if let startTime = json["startTime"] as? Double {
        model.startTime = startTime / 1000.0
      }
      if let direction = json["direction"] as? Int {
        if direction == 1 {
          model.order = .asc
        } else {
          model.order = .desc
        }
      }
      return model
    }
    return nil
  }
}

extension NIMChatroomUpdateRequest: NimDataConvertProtrol {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(NIMChatroomMember.userId)] = "account"
    keyPaths[#keyPath(NIMChatroomMember.roomNickname)] = "nickname"
    keyPaths[#keyPath(NIMChatroomMember.roomAvatar)] = "avatar"
    keyPaths[#keyPath(NIMChatroomMember.enterTimeInterval)] = "enterTime"
    return keyPaths
  }

  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomUpdateRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}

extension NIMChatroomMemberRequest: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomMemberRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}

extension NIMChatroomMembersByIdsRequest: NimDataConvertProtrol {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(NIMChatroomMembersByIdsRequest.userIds)] = "accountList"
    return keyPaths
  }

  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomMembersByIdsRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}

extension NIMChatroomMemberInfoUpdateRequest: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomMemberInfoUpdateRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}

extension NIMChatroomMemberUpdateRequest: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomMemberUpdateRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}

extension NIMChatroomMemberKickRequest: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomMemberKickRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}

extension NIMChatroomQueueUpdateRequest: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomQueueUpdateRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}

extension NIMChatroomQueueBatchUpdateRequest: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomQueueBatchUpdateRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}

extension NIMChatroomQueueRemoveRequest: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if let jsonObject = yx_modelToJSONObject() as? [String: Any] {
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMChatroomQueueRemoveRequest.yx_model(with: json) {
      return model
    }
    return nil
  }
}
