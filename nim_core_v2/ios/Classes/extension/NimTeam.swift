// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMCreateTeamOption: NimDataConvertProtrol {
  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["teamType"] = FLT_NIMTeamType.convert(type)?.rawValue
      jsonObject["verifyType"] = FLT_NIMTeamJoinMode.convert(joinMode)?.rawValue
      jsonObject["inviteMode"] = FLT_NIMTeamInviteMode.convert(inviteMode)?.rawValue
      jsonObject["beInviteMode"] = FLT_NIMTeamBeInviteMode.convert(beInviteMode)?.rawValue
      jsonObject["updateInfoMode"] = FLT_NIMTeamUpdateInfoMode.convert(updateInfoMode)
      jsonObject["extensionUpdateMode"] = FLT_NIMTeamUpdateClientCustomMode
        .convert(updateClientCustomMode)?.rawValue
      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMCreateTeamOption.yx_model(with: json) {
      if let teamType = json["teamType"] as? String,
         let type = FLT_NIMTeamType(rawValue: teamType) {
        model.type = type.convertNIMTeamType()
      }
      if let verifyType = json["verifyType"] as? String,
         let type = FLT_NIMTeamJoinMode(rawValue: verifyType) {
        model.joinMode = type.convertNimTeamJoinModel()
      }
      if let inviteMode = json["inviteMode"] as? String,
         let type = FLT_NIMTeamInviteMode(rawValue: inviteMode) {
        model.inviteMode = type.convertNIMInviteModel()
      }
      if let beInviteMode = json["beInviteMode"] as? String,
         let type = FLT_NIMTeamBeInviteMode(rawValue: beInviteMode) {
        model.beInviteMode = type.convertNIMBeINviteMode()
      }
      if let updateInfoMode = json["updateInfoMode"] as? String,
         let type = FLT_NIMTeamUpdateInfoMode(rawValue: updateInfoMode) {
        model.updateInfoMode = type.convertNIMUpdateMode()
      }
      if let extensionUpdateMode = json["extensionUpdateMode"] as? String,
         let type = FLT_NIMTeamUpdateClientCustomMode(rawValue: extensionUpdateMode) {
        model.updateClientCustomMode = type.convertNIMCustomMode()
      }
      if let maxMemberCountLimitation = json["maxMemberCount"] as? UInt {
        model.maxMemberCountLimitation = maxMemberCountLimitation
      }
      if let clientCustomInfo = json["extension"] as? String {
        model.clientCustomInfo = clientCustomInfo
      }
      return model
    }
    return nil
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(NIMCreateTeamOption.intro)] = "introduce"
    keyPaths[#keyPath(NIMCreateTeamOption.maxMemberCountLimitation)] = "maxMemberCount"
    return keyPaths
  }
}

extension NIMTeam: NimDataConvertProtrol {
  dynamic var flt_type: FLT_NIMTeamMemberType? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_type".hashValue)!
      ) as? FLT_NIMTeamMemberType {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_type".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(NIMTeam.teamId)] = "id"
    keyPaths[#keyPath(NIMTeam.teamName)] = "name"
    keyPaths[#keyPath(NIMTeam.avatarUrl)] = "icon"
    keyPaths[#keyPath(NIMTeam.intro)] = "introduce"

    // read only
    keyPaths[#keyPath(NIMTeam.memberNumber)] = "memberCount"
    keyPaths[#keyPath(NIMTeam.owner)] = "creator"
    keyPaths[#keyPath(NIMTeam.level)] = "memberLimit"
    // createTime
    keyPaths[#keyPath(NIMTeam.serverCustomInfo)] = "extServer"
    keyPaths[#keyPath(NIMTeam.clientCustomInfo)] = "extension"
    return keyPaths
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      jsonObject["verifyType"] = FLT_NIMTeamJoinMode.convert(joinMode)?.rawValue
      jsonObject["messageNotifyType"] = FLT_NIMTeamNotifyState.convert(notifyStateForNewMsg)?
        .rawValue
      jsonObject["teamInviteMode"] = FLT_NIMTeamInviteMode.convert(inviteMode)?.rawValue
      jsonObject["teamBeInviteModeEnum"] = FLT_NIMTeamBeInviteMode.convert(beInviteMode)?
        .rawValue
      jsonObject["teamUpdateMode"] = FLT_NIMTeamUpdateInfoMode.convert(updateInfoMode)?
        .rawValue
      jsonObject["teamExtensionUpdateMode"] = FLT_NIMTeamUpdateClientCustomMode
        .convert(updateClientCustomMode)?.rawValue
      jsonObject["type"] = FLT_NIMTeamType.convert(type)?.rawValue
      jsonObject["isAllMute"] = inAllMuteMode()
      jsonObject["muteMode"] = inAllMuteMode() ? (type == NIMTeamType.super ? "muteNormal" : "muteAll") : "cancel"
      jsonObject["createTime"] = Int(createTime * 1000)

      if let tid = teamId {
        if type == NIMTeamType.super {
          jsonObject["isMyTeam"] = NIMSDK.shared().superTeamManager.isMyTeam(tid)
        } else {
          jsonObject["isMyTeam"] = NIMSDK.shared().teamManager.isMyTeam(tid)
        }
      }

      if serverCustomInfo == nil {
        jsonObject["extServer"] = ""
      }

      if clientCustomInfo == nil {
        jsonObject["extension"] = ""
      }

      if teamName == nil {
        jsonObject["name"] = ""
      }

      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMTeam.yx_model(with: json) {
      if let verifyType = json["verifyType"] as? String,
         let verify = FLT_NIMTeamJoinMode(rawValue: verifyType) {
        model.joinMode = verify.convertNimTeamJoinModel()
      }
      if let messageNotifyType = json["messageNotifyType"] as? String,
         let _ = FLT_NIMTeamNotifyState(rawValue: messageNotifyType) {
        // model.notifyStateForNewMsg = notifyType.convertNIMNotifyState()
      }
      if let teamInviteMode = json["teamInviteMode"] as? String,
         let beInviteMode = FLT_NIMTeamInviteMode(rawValue: teamInviteMode) {
        model.inviteMode = beInviteMode.convertNIMInviteModel()
      }
      if let teamBeInviteModeEnum = json["teamBeInviteModeEnum"] as? String,
         let teamBeInviteMode = FLT_NIMTeamBeInviteMode(rawValue: teamBeInviteModeEnum) {
        model.beInviteMode = teamBeInviteMode.convertNIMBeINviteMode()
      }
      if let teamUpdateMode = json["teamUpdateMode"] as? String,
         let updateMode = FLT_NIMTeamUpdateInfoMode(rawValue: teamUpdateMode) {
        model.updateInfoMode = updateMode.convertNIMUpdateMode()
      }
      if let teamExtensionUpdateMode = json["teamExtensionUpdateMode"] as? String,
         let extensionUpdateMode =
         FLT_NIMTeamUpdateClientCustomMode(rawValue: teamExtensionUpdateMode) {
        model.updateClientCustomMode = extensionUpdateMode.convertNIMCustomMode()
      }
      return model
    }
    return nil
  }
}

extension NIMTeamMember: NimDataConvertProtrol {
  dynamic var flt_type: FLT_NIMTeamMemberType? {
    get {
      if let T = objc_getAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_type".hashValue)!
      ) as? FLT_NIMTeamMemberType {
        return T
      } else {
        return nil
      }
    }
    set {
      objc_setAssociatedObject(
        self,
        UnsafeRawPointer(bitPattern: "flt_type".hashValue)!,
        newValue,
        objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
      )
    }
  }

  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = [String: Any]()
    keyPaths[#keyPath(NIMTeamMember.teamId)] = "id"
    keyPaths[#keyPath(NIMTeamMember.userId)] = "account"
    keyPaths[#keyPath(NIMTeamMember.isMuted)] = "isMute"
    keyPaths[#keyPath(NIMTeamMember.inviterAccid)] = "invitorAccid"

    return keyPaths
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      if let flt_type = FLT_NIMTeamMemberType.convert(type) {
        jsonObject["type"] = flt_type.rawValue
      }
      // iOS无此属性
      jsonObject["isInTeam"] = true
      jsonObject["joinTime"] = Int(createTime * 1000)
      jsonObject["teamNick"] = nickname ?? ""

      if let ext = customInfo {
        jsonObject["extension"] = getDictionaryFromJSONString(ext)
      }

      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMTeamMember.yx_model(with: json) {
      if let memberType = json["type"] as? String,
         let mType = FLT_NIMTeamMemberType(rawValue: memberType) {
        model.type = mType.convertNIMMemberType()
      }
      if let newInfo = json["extension"] as? [String: Any?],
         let data = try? JSONSerialization.data(withJSONObject: newInfo, options: []),
         let str = String(data: data, encoding: String.Encoding.utf8) {
        model.customInfo = str
      }
      return model
    }
    return nil
  }
}

extension NIMTeamSearchOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    let keyPaths = getKeyPaths(self)
    return keyPaths
  }
}
