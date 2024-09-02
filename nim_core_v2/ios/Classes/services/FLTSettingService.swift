// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum V2SettingType: String {
  case getDndConfig
  case getConversationMuteStatus
  case getP2PMessageMuteMode
  case getTeamMessageMuteMode
  case setDndConfig
  case setP2PMessageMuteMode
  case setPushMobileOnDesktopOnline
  case setTeamMessageMuteMode
  case getP2PMessageMuteList
}

let settingClassName = "FLTSettingsService"

class FLTSettingsService: FLTBaseService, FLTService, V2NIMSettingListener {
  func serviceName() -> String {
    ServiceType.SettingService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case V2SettingType.getDndConfig.rawValue:
      getDndConfig(arguments, resultCallback)
    case V2SettingType.getConversationMuteStatus.rawValue:
      getConversationMuteStatus(arguments, resultCallback)
    case V2SettingType.getP2PMessageMuteMode.rawValue:
      getP2PMessageMuteMode(arguments, resultCallback)
    case V2SettingType.getTeamMessageMuteMode.rawValue:
      getTeamMessageMuteMode(arguments, resultCallback)
    case V2SettingType.setDndConfig.rawValue:
      setDndConfig(arguments, resultCallback)
    case V2SettingType.setP2PMessageMuteMode.rawValue:
      setP2PMessageMuteMode(arguments, resultCallback)
    case V2SettingType.setPushMobileOnDesktopOnline.rawValue:
      setPushMobileOnDesktopOnline(arguments, resultCallback)
    case V2SettingType.setTeamMessageMuteMode.rawValue:
      setTeamMessageMuteMode(arguments, resultCallback)
    case V2SettingType.getP2PMessageMuteList.rawValue:
      getP2PMessageMuteList(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  public func getDndConfig(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let config = NIMSDK.shared().v2SettingService.getDndConfig()
    successCallBack(resultCallback, config?.toDictionary())
  }

  public func getConversationMuteStatus(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(settingClassName, desc: "getConversationMuteStatus argument \(arguments)")

    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    let muteStatus = NIMSDK.shared().v2SettingService.getConversationMuteStatus(conversationId)
    successCallBack(resultCallback, muteStatus)
  }

  public func getP2PMessageMuteMode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(settingClassName, desc: "getP2PMessageMuteMode argument \(arguments)")

    guard let accountId = arguments["accountId"] as? String else {
      parameterError(resultCallback)
      return
    }
    let mode = NIMSDK.shared().v2SettingService.getP2PMessageMuteMode(accountId)
    successCallBack(resultCallback, ["muteMode": mode.rawValue])
  }

  public func getTeamMessageMuteMode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(settingClassName, desc: "getTeamMessageMuteMode argument \(arguments)")

    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let teamTypeEnum = V2NIMTeamType(rawValue: teamType) else {
      parameterError(resultCallback)
      return
    }
    let mode = NIMSDK.shared().v2SettingService.getTeamMessageMuteMode(teamId, teamType: teamTypeEnum)
    successCallBack(resultCallback, ["muteMode": mode.rawValue])
  }

  public func setDndConfig(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(settingClassName, desc: "setDndConfig argument \(arguments)")

    guard let config = arguments["config"] as? [String: Any] else {
      parameterError(resultCallback)
      return
    }
    let apnsDndConfig = V2NIMDndConfig()
    if let showDetail = config[#keyPath(V2NIMDndConfig.showDetail)] as? Bool {
      apnsDndConfig.showDetail = showDetail
    }
    if let dndOn = config[#keyPath(V2NIMDndConfig.dndOn)] as? Bool {
      apnsDndConfig.dndOn = dndOn
    }
    if let fromH = config[#keyPath(V2NIMDndConfig.fromH)] as? Int {
      apnsDndConfig.fromH = fromH
    }
    if let fromM = config[#keyPath(V2NIMDndConfig.fromM)] as? Int {
      apnsDndConfig.fromM = fromM
    }
    if let toH = config[#keyPath(V2NIMDndConfig.toH)] as? Int {
      apnsDndConfig.toH = toH
    }
    if let toM = config[#keyPath(V2NIMDndConfig.toM)] as? Int {
      apnsDndConfig.toM = toM
    }
    weak var weakSelf = self
    NIMSDK.shared().v2SettingService.setDndConfig(apnsDndConfig) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(settingClassName, desc: "setDndConfig error \(error.nserror.localizedDescription)")
    }
  }

  public func setP2PMessageMuteMode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(settingClassName, desc: "setP2PMessageMuteMode argument \(arguments)")

    guard let accountId = arguments["accountId"] as? String, let muteMode = arguments["muteMode"] as? Int, let muteModeEnum = V2NIMP2PMessageMuteMode(rawValue: muteMode) else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2SettingService.setP2PMessageMuteMode(accountId, muteMode: muteModeEnum) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(settingClassName, desc: "setP2PMessageMuteMode error \(error.nserror.localizedDescription)")
    }
  }

  public func setPushMobileOnDesktopOnline(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(settingClassName, desc: "setPushMobileOnDesktopOnline argument \(arguments)")

    guard let need = arguments["need"] as? Bool else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2SettingService.setPushMobileOnDesktopOnline(need) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(settingClassName, desc: "setPushMobileOnDesktopOnline error \(error.nserror.localizedDescription)")
    }
  }

  public func setTeamMessageMuteMode(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    FLTALog.infoLog(settingClassName, desc: "setTeamMessageMuteMode argument \(arguments)")

    guard let teamId = arguments["teamId"] as? String, let teamType = arguments["teamType"] as? Int, let muteMode = arguments["muteMode"] as? Int, let teamTypeEnum = V2NIMTeamType(rawValue: teamType), let muteModeEnum = V2NIMTeamMessageMuteMode(rawValue: muteMode) else {
      parameterError(resultCallback)
      return
    }
    weak var weakSelf = self
    NIMSDK.shared().v2SettingService.setTeamMessageMuteMode(teamId, teamType: teamTypeEnum, muteMode: muteModeEnum) {
      weakSelf?.successCallBack(resultCallback, nil)
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(settingClassName, desc: "setTeamMessageMuteMode error \(error.nserror.localizedDescription)")
    }
  }

  public func getP2PMessageMuteList(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    weak var weakSelf = self
    FLTALog.infoLog(settingClassName, desc: "getP2PMessageMuteList argument \(arguments)")

    NIMSDK.shared().v2SettingService.getP2PMessageMuteList { muteList in
      weakSelf?.successCallBack(resultCallback, ["muteList": muteList])
    } failure: { error in
      weakSelf?.errorCallBack(resultCallback, error.nserror.localizedDescription, Int(error.code))
      FLTALog.errorLog(settingClassName, desc: "getP2PMessageMuteList error \(error.nserror.localizedDescription)")
    }
  }

  override func onInitialized() {
    NIMSDK.shared().v2SettingService.add(self)
  }

  deinit {
    NIMSDK.shared().v2SettingService.remove(self)
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  /**
   *  群组消息免打扰回调
   *
   *  @param teamId 群组id
   *  @param teamType 群组类型
   *  @param muteMode 群组免打扰模式
   */
  func onTeamMessageMuteModeChanged(_ teamId: String, teamType: V2NIMTeamType, muteMode: V2NIMTeamMessageMuteMode) {
    notifyEvent(serviceName(), "onTeamMessageMuteModeChanged", ["teamType": teamType.rawValue, "teamId": teamId, "muteMode": muteMode.rawValue])
  }

  /**
   *  点对点消息免打扰回调
   *
   *  @param accountId 账号id
   *  @param muteMode 用户免打扰模式
   */

  func onP2PMessageMuteModeChanged(_ accountId: String, muteMode: V2NIMP2PMessageMuteMode) {
    print("onP2PMessageMuteModeChanged account id \(accountId) mute model \(muteMode.rawValue)")
    notifyEvent(serviceName(), "onP2PMessageMuteModeChanged", ["accountId": accountId, "muteMode": muteMode.rawValue])
  }
}
