// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import NIMSDK

enum QChatChannelMethod: String {
  case createChannel
  case deleteChannel
  case updateChannel
  case getChannels
  case getChannelsByPage
  case getChannelMembersByPage
  case getChannelUnreadInfos
  case subscribeChannel
  case searchChannelByPage
  case searchChannelMembers
  case updateChannelBlackWhiteRoles
  case getChannelBlackWhiteRolesByPage
  case getExistingChannelBlackWhiteRoles
  case updateChannelBlackWhiteMembers
  case getChannelBlackWhiteMembersByPage
  case getExistingChannelBlackWhiteMembers
  case updateUserChannelPushConfig
  case getUserChannelPushConfigs
  case getChannelCategoriesByPage
  case subscribeAsVisitor
}

class FLTQChatChannelService: FLTBaseService, FLTService {
  private let paramErrorTip = "参数错误"
  private let paramErrorCode = 414

  override func onInitialized() {
    NIMSDK.shared().qchatChannelManager.add(self)
  }

  deinit {
    NIMSDK.shared().qchatChannelManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.QChatChannelService.rawValue
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case QChatChannelMethod.createChannel.rawValue:
      qChatCreateChannel(arguments, resultCallback)
    case QChatChannelMethod.deleteChannel.rawValue:
      qChatDeleteChannel(arguments, resultCallback)
    case QChatChannelMethod.updateChannel.rawValue:
      qChatUpdateChannel(arguments, resultCallback)
    case QChatChannelMethod.getChannels.rawValue:
      qChatGetChannels(arguments, resultCallback)
    case QChatChannelMethod.getChannelsByPage.rawValue:
      qChatGetChannelsByPage(arguments, resultCallback)
    case QChatChannelMethod.getChannelMembersByPage.rawValue:
      qChatGetChannelMembersByPage(arguments, resultCallback)
    case QChatChannelMethod.getChannelUnreadInfos.rawValue:
      qChatGetChannelUnreadInfos(arguments, resultCallback)
    case QChatChannelMethod.subscribeChannel.rawValue:
      qChatSubscribeChannel(arguments, resultCallback)
    case QChatChannelMethod.searchChannelByPage.rawValue:
      qChatSearchChannelByPage(arguments, resultCallback)
    case QChatChannelMethod.searchChannelMembers.rawValue:
      qChatSearchChannelMembers(arguments, resultCallback)
    case QChatChannelMethod.updateChannelBlackWhiteRoles.rawValue:
      qChatUpdateChannelBlackWhiteRoles(arguments, resultCallback)
    case QChatChannelMethod.getChannelBlackWhiteRolesByPage.rawValue:
      qChatGetChannelBlackWhiteRolesByPage(arguments, resultCallback)
    case QChatChannelMethod.getExistingChannelBlackWhiteRoles.rawValue:
      qChatGetExistingChannelBlackWhiteRoles(arguments, resultCallback)
    case QChatChannelMethod.updateChannelBlackWhiteMembers.rawValue:
      qChatUpdateChannelBlackWhiteMembers(arguments, resultCallback)
    case QChatChannelMethod.getChannelBlackWhiteMembersByPage.rawValue:
      qChatGetChannelBlackWhiteMembersByPage(arguments, resultCallback)
    case QChatChannelMethod.getExistingChannelBlackWhiteMembers.rawValue:
      qChatGetExistingChannelBlackWhiteMembers(arguments, resultCallback)
    case QChatChannelMethod.updateUserChannelPushConfig.rawValue:
      qChatUpdateUserChannelPushConfig(arguments, resultCallback)
    case QChatChannelMethod.getUserChannelPushConfigs.rawValue:
      qChatGetUserChannelPushConfigs(arguments, resultCallback)
    case QChatChannelMethod.getChannelCategoriesByPage.rawValue:
      qChatGetChannelCategoriesByPage(arguments, resultCallback)
    case QChatChannelMethod.subscribeAsVisitor.rawValue:
      subscribeAsVisitor(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func qChatChannelCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func qChatCreateChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatCreateChannelParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager.createChannel(request) { [weak self] error, result in
      self?.qChatChannelCallback(error, ["channel": result?.toDict()], resultCallback)
    }
  }

  func qChatDeleteChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatDeleteChannelParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager.deleteChannel(request) { [weak self] error in
      self?.qChatChannelCallback(error, nil, resultCallback)
    }
  }

  func qChatUpdateChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatUpdateChannelParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager.updateChannel(request) { [weak self] error, result in
      self?.qChatChannelCallback(error, ["channel": result?.toDict()], resultCallback)
    }
  }

  func qChatGetChannels(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetChannelsParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager.getChannels(request) { [weak self] error, result in
      self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatGetChannelsByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetChannelsByPageParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager.getChannelsByPage(request) { [weak self] error, result in
      self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatGetChannelMembersByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetChannelMembersByPageParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager
      .getChannelMembers(byPage: request) { [weak self] error, result in
        self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatGetChannelUnreadInfos(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetChannelUnreadInfosParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager
      .getChannelUnreadInfos(request) { [weak self] error, result in
        self?.qChatChannelCallback(error, ["unreadInfoList": result?.toDict()], resultCallback)
      }
  }

  func qChatSubscribeChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatSubscribeChannelParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    var unreadInfoList = [[String: Any]?]()
    let subType = request.subscribeType
    let operationType = request.operationType
    // 先进行订阅消息操作，然后查询结果，需要根据订阅类型区分是否需要查询操作
    NIMSDK.shared().qchatChannelManager.subscribeChannel(request) { error, result in
      if let err = error {
        print(
          "@@#❌qChatSubscribeChannel() -> subscribeChannel() FAILED: \(err.localizedDescription)"
        )
        self.qChatChannelCallback(error, nil, resultCallback)
      } else {
        let failedList = result?.toDict()
        if operationType == NIMQChatSubscribeOperationType.subscribe, subType == NIMQChatSubscribeType.channelMsgUnreadCount || subType == NIMQChatSubscribeType.channelMsgUnreadStatus {
          let targets = NIMQChatGetChannelUnreadInfosParam()
          targets.targets = request.targets
          NIMSDK.shared().qchatChannelManager.getChannelUnreadInfos(targets) { [weak self] error, result in
            if let err = error {
              print(
                "@@#❌qChatSubscribeChannel() -> getChannelUnreadInfos() FAILED: \(err.localizedDescription)"
              )
              self?.qChatChannelCallback(error, nil, resultCallback)
            } else {
              if let res = result {
                unreadInfoList = res.toDict()
              }
              self?.qChatChannelCallback(
                error,
                ["unreadInfoList": unreadInfoList, "failedList": failedList],
                resultCallback
              )
            }
          }
        } else {
          self.qChatChannelCallback(
            error,
            ["unreadInfoList": unreadInfoList, "failedList": result?.toDict()],
            resultCallback
          )
        }
      }
    }
  }

  func qChatSearchChannelByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatSearchChannelByPageParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager
      .searchChannel(byPage: request) { [weak self] error, result in
        self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatSearchChannelMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMQChatSearchServerChannelMemberParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatServerManager
      .searchServerChannelMember(request) { [weak self] error, result in
        self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatUpdateChannelBlackWhiteRoles(_ arguments: [String: Any],
                                         _ resultCallback: ResultCallback) {
    guard let request = NIMQChatUpdateChannelBlackWhiteRoleParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager.updateBlackWhiteRole(request) { [weak self] error in
      self?.qChatChannelCallback(error, nil, resultCallback)
    }
  }

  func qChatGetChannelBlackWhiteRolesByPage(_ arguments: [String: Any],
                                            _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetChannelBlackWhiteRolesByPageParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager
      .getBlackWhiteRoles(byPage: request) { [weak self] error, result in
        self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatGetExistingChannelBlackWhiteRoles(_ arguments: [String: Any],
                                              _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetExistingChannelBlackWhiteRolesParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager
      .getExistingChannelBlackWhiteRoles(request) { [weak self] error, result in
        self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatUpdateChannelBlackWhiteMembers(_ arguments: [String: Any],
                                           _ resultCallback: ResultCallback) {
    guard let request = NIMQChatUpdateChannelBlackWhiteMembersParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager.updateBlackWhiteMembers(request) { [weak self] error in
      self?.qChatChannelCallback(error, nil, resultCallback)
    }
  }

  func qChatGetChannelBlackWhiteMembersByPage(_ arguments: [String: Any],
                                              _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetChannelBlackWhiteMembersByPageParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager
      .getBlackWhiteMembers(byPage: request) { [weak self] error, result in
        self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatGetExistingChannelBlackWhiteMembers(_ arguments: [String: Any],
                                                _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetExistingChannelBlackWhiteMembersParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager
      .getExistingChannelBlackWhiteMembers(request) { [weak self] error, result in
        self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
      }
  }

  func qChatUpdateUserChannelPushConfig(_ arguments: [String: Any],
                                        _ resultCallback: ResultCallback) {
    guard let pushMsgType = arguments["pushMsgType"] as? String,
          let profile = FLTQChatPushNotificationProfile(rawValue: pushMsgType)?
          .convertToPushNotificationProfile(),
          let serverId = arguments["serverId"] as? UInt64,
          let channelId = arguments["channelId"] as? UInt64 else {
      print("qChatGetUserChannelPushConfigs parameter error")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }

    let chan = NIMQChatChannelIdInfo(channelId: channelId, serverId: serverId)
    NIMSDK.shared().qchatApnsManager.update(profile, channel: chan) { [weak self] error in
      self?.qChatChannelCallback(error, nil, resultCallback)
    }
  }

  func qChatGetUserChannelPushConfigs(_ arguments: [String: Any],
                                      _ resultCallback: ResultCallback) {
    guard let channelIdInfos = arguments["channelIdInfos"] as? [[String: Any]] else {
      print("qChatGetUserChannelPushConfigs parameter error, channelIdInfos is nil")
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    let request = channelIdInfos.map { item in
      NIMQChatChannelIdInfo.fromDic(item)
    }
    NIMSDK.shared().qchatApnsManager
      .getUserPushNotificationConfig(byChannel: request) { [weak self] error, result in
        var resDict = [[String: Any]]()
        for item in result ?? [] {
          if let res = item.toDic() {
            resDict.append(res)
          }
        }
        self?.qChatChannelCallback(error, ["userPushConfigs": resDict], resultCallback)
      }
  }

  func qChatGetChannelCategoriesByPage(_ arguments: [String: Any],
                                       _ resultCallback: ResultCallback) {
    guard let request = NIMQChatGetCategoriesInServerByPageParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager
      .getCategoriesInServer(byPage: request) { [weak self] error, result in
        self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
      }
  }

  func subscribeAsVisitor(_ arguments: [String: Any],
                          _ resultCallback: ResultCallback) {
    guard let request = NIMQChatSubscribeChannelAsVisitorParam.fromDic(arguments) else {
      errorCallBack(resultCallback, paramErrorTip, paramErrorCode)
      return
    }
    NIMSDK.shared().qchatChannelManager.subscribe(asVisitor: request) { [weak self] error, result in
      self?.qChatChannelCallback(error, result?.toDict(), resultCallback)
    }
  }
}

extension FLTQChatChannelService: NIMQChatChannelManagerDelegate {}
