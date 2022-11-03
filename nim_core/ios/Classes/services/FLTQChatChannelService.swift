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
}

class FLTQChatChannelService: FLTBaseService, FLTService {
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
    default:
      resultCallback.notImplemented()
    }
  }

  func qChatChannelCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      // 状态为“参数错误”时，SDK本应返回414，但是实际返回1，未与AOS对齐，此处进行手动对齐
      let code = ns_error.code == 1 ? 414 : ns_error.code
      errorCallBack(resultCallback, ns_error.description, code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  func qChatCreateChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatCreateChannelParam.fromDic(arguments)
    NIMSDK.shared().qchatChannelManager.createChannel(request) { error, result in
      self.qChatChannelCallback(error, ["channel": result?.toDict()], resultCallback)
    }
  }

  func qChatDeleteChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatDeleteChannelParam.fromDic(arguments)
    NIMSDK.shared().qchatChannelManager.deleteChannel(request) { error in
      self.qChatChannelCallback(error, nil, resultCallback)
    }
  }

  func qChatUpdateChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatUpdateChannelParam.fromDic(arguments)
    NIMSDK.shared().qchatChannelManager.updateChannel(request) { error, result in
      self.qChatChannelCallback(error, ["channel": result?.toDict()], resultCallback)
    }
  }

  func qChatGetChannels(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetChannelsParam.fromDic(arguments)
    NIMSDK.shared().qchatChannelManager.getChannels(request) { error, result in
      self.qChatChannelCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatGetChannelsByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetChannelsByPageParam.fromDic(arguments)
    NIMSDK.shared().qchatChannelManager.getChannelsByPage(request) { error, result in
      self.qChatChannelCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatGetChannelMembersByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetChannelMembersByPageParam.fromDic(arguments)
    NIMSDK.shared().qchatChannelManager.getChannelMembers(byPage: request) { error, result in
      self.qChatChannelCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatGetChannelUnreadInfos(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatGetChannelUnreadInfosParam.fromDic(arguments)
    NIMSDK.shared().qchatChannelManager.getChannelUnreadInfos(request) { error, result in
      self.qChatChannelCallback(error, ["unreadInfoList": result?.toDict()], resultCallback)
    }
  }

  func qChatSubscribeChannel(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatSubscribeChannelParam.fromDic(arguments)
    let targets = NIMQChatGetChannelUnreadInfosParam()
    targets.targets = request.targets
    var unreadInfoList = [[String: Any]?]()
    NIMSDK.shared().qchatChannelManager.getChannelUnreadInfos(targets) { error, result in
      if let err = error {
        print(
          "❌qChatSubscribeChannel() -> getChannelUnreadInfos() FAILED: \(err.localizedDescription)"
        )
      } else {
        if let res = result {
          unreadInfoList = res.toDict()
        }
      }
      NIMSDK.shared().qchatChannelManager.subscribeChannel(request) { error, result in
        self.qChatChannelCallback(
          error,
          ["unreadInfoList": unreadInfoList, "failedList": result?.toDict()],
          resultCallback
        )
      }
    }
  }

  func qChatSearchChannelByPage(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatSearchChannelByPageParam.fromDic(arguments)
//      request.endTime = NSNumber(value: 0)
    NIMSDK.shared().qchatChannelManager.searchChannel(byPage: request) { error, result in
      self.qChatChannelCallback(error, result?.toDict(), resultCallback)
    }
  }

  func qChatSearchChannelMembers(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    let request = NIMQChatSearchServerChannelMemberParam.fromDic(arguments)
    NIMSDK.shared().qchatServerManager.searchServerChannelMember(request) { error, result in
      self.qChatChannelCallback(error, result?.toDict(), resultCallback)
    }
  }
}

extension FLTQChatChannelService: NIMQChatChannelManagerDelegate {}
