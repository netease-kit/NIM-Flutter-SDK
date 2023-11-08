// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum ChatRoomType: String {
  case CreateMessage = "createMessage"
  case SendMessage = "sendMessage"

  case EnterChatroom = "enterChatroom" // 进入聊天室
  case ExitChatroom = "exitChatroom" // 离开聊天室
  case FetchMessageHistory = "fetchMessageHistory" // 查询云端历史消息
  case FetchChatroomInfo = "fetchChatroomInfo" // 获取聊天室信息
  case UpdateChatroomInfo = "updateChatroomInfo" // 修改聊天室信息
  case DownloadAttachment = "downloadAttachment"

  // 聊天室成员管理
  case FetchChatroomMembers = "fetchChatroomMembers" // 获取聊天室成员
  case FetchChatroomMembersByIds = "fetchChatroomMembersByAccount" // 获取指定聊天室成员
  case UpdateMyChatroomMemberInfo = "updateChatroomMyMemberInfo" // 修改自身信息
  case UpdateMemberBlack = "markChatroomMemberInBlackList" // 添加/移除黑名单用户
  case MarkMemberManager = "markChatroomMemberBeManager" // 添加/移除管理员
  case MarkNormalMember = "markChatroomMemberBeNormal" // 添加/移除普通成员
  case UpdateMemberMute = "markChatroomMemberMuted" // 添加/移除禁言用户
  case KickMember = "kickChatroomMember" // 踢出成员
  case UpdateMemberTempMute = "markChatroomMemberTempMuted" // 临时禁言成员

  // 聊天室队列
  case FetchChatroomQueue = "fetchChatroomQueue" // 获取聊天室队列
  case UpdateChatroomQueueObject = "updateChatroomQueueEntry" // 加入或者更新队列元素
  case BatchUpdateChatroomQueueObject = "batchUpdateChatroomQueue" // 批量更新队列元素
  case RemoveChatroomQueueObject = "pollChatroomQueueEntry" // 移除指定队列元素
  case dropChatroomQueue = "clearChatroomQueue" // 清空队列
}

class FLTChatRoomService: FLTBaseService, FLTService {
//    override init() {
//        super.init()
//        NIMSDK.shared().chatroomManager.add(self)
//    }

  override func onInitialized() {
    NIMSDK.shared().chatroomManager.add(self)
    NIMChatroomIndependentMode.registerRequestChatroomAddressesHandler { roomId, callback in
      self.notifyEvent(
        self.serviceName(),
        "getIndependentModeLinkAddress",
        ["roomId": roomId],
        result: { r in
          if let linkAddress = r as? [String] {
            callback(nil, linkAddress)
          } else {
            callback(nil, nil)
          }
        }
      )
    }
  }

  deinit {
    NIMSDK.shared().chatroomManager.remove(self)
  }

  func serviceName() -> String {
    ServiceType.ChatroomService.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any],
                      _ resultCallback: ResultCallback) {
    switch method {
    case ChatRoomType.CreateMessage.rawValue:
      if let messageService = nimCore?
        .getService(ServiceType.MessageService.rawValue) as? FLTMessageService {
        var args = arguments
        var attach = (arguments["messageAttachment"] as? [String: Any]) ?? [String: Any]()
        if let filePath = arguments["filePath"] as? String,
           let nosScene = arguments["nosScene"] as? String {
          attach["path"] = filePath
          attach["sen"] = nosScene
        }
        if let longitude = arguments["longitude"] as? Double,
           let latitude = arguments["latitude"] as? Double,
           let address = arguments["address"] as? String {
          attach["lng"] = longitude
          attach["lat"] = latitude
          attach["title"] = address
        }
        args["messageAttachment"] = attach.keys.count > 0 ? attach : nil
        messageService.onMethodCalled(method, args, resultCallback)
      } else {
        resultCallback.notImplemented()
      }
    case ChatRoomType.SendMessage.rawValue:
      if let messageService = nimCore?
        .getService(ServiceType.MessageService.rawValue) as? FLTMessageService {
        messageService.onMethodCalled(method, arguments, resultCallback)
      } else {
        resultCallback.notImplemented()
      }
    case ChatRoomType.EnterChatroom.rawValue: enterChatroom(arguments, resultCallback)
    case ChatRoomType.ExitChatroom.rawValue: exitChatroom(arguments, resultCallback)
    case ChatRoomType.FetchMessageHistory
      .rawValue: fetchMessageHistory(arguments, resultCallback)
    case ChatRoomType.FetchChatroomInfo.rawValue: fetchChatroomInfo(arguments, resultCallback)
    case ChatRoomType.UpdateChatroomInfo.rawValue: updateChatroomInfo(arguments, resultCallback)
    case ChatRoomType.DownloadAttachment.rawValue:
      if let messageService = nimCore?
        .getService(ServiceType.MessageService.rawValue) as? FLTMessageService {
        messageService.onMethodCalled(
          MessageType.DownloadAttachment.rawValue,
          arguments,
          resultCallback
        )
      } else {
        resultCallback.notImplemented()
      }

    // 聊天室成员管理
    case ChatRoomType.FetchChatroomMembers
      .rawValue: fetchChatroomMembers(arguments, resultCallback)
    case ChatRoomType.FetchChatroomMembersByIds
      .rawValue: fetchChatroomMembersByIds(arguments, resultCallback)
    case ChatRoomType.UpdateMyChatroomMemberInfo
      .rawValue: updateMyChatroomMemberInfo(arguments, resultCallback)
    case ChatRoomType.UpdateMemberBlack.rawValue: updateMemberBlack(arguments, resultCallback)
    case ChatRoomType.MarkMemberManager.rawValue: markMemberManager(arguments, resultCallback)
    case ChatRoomType.MarkNormalMember.rawValue: markNormalMember(arguments, resultCallback)
    case ChatRoomType.UpdateMemberMute.rawValue: updateMemberMute(arguments, resultCallback)
    case ChatRoomType.KickMember.rawValue: kickMember(arguments, resultCallback)
    case ChatRoomType.UpdateMemberTempMute
      .rawValue: updateMemberTempMute(arguments, resultCallback)

    // 聊天室队列
    case ChatRoomType.FetchChatroomQueue.rawValue: fetchChatroomQueue(arguments, resultCallback)
    case ChatRoomType.UpdateChatroomQueueObject
      .rawValue: updateChatroomQueueObject(arguments, resultCallback)
    case ChatRoomType.BatchUpdateChatroomQueueObject
      .rawValue: batchUpdateChatroomQueueObject(arguments, resultCallback)
    case ChatRoomType.RemoveChatroomQueueObject
      .rawValue: removeChatroomQueueObject(arguments, resultCallback)
    case ChatRoomType.dropChatroomQueue.rawValue: dropChatroomQueue(arguments, resultCallback)

    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  private func chatroomCallback(_ error: Error?, _ data: Any?, _ resultCallback: ResultCallback) {
    if let ns_error = error as NSError? {
      errorCallBack(resultCallback, ns_error.description, ns_error.code)
    } else {
      successCallBack(resultCallback, data)
    }
  }

  private func enterChatroom(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let request = NIMChatroomEnterRequest.fromDic(arguments) as? NIMChatroomEnterRequest
    else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }
    weak var weakSelf = self
    // todo SDK回调在主线程，应用卡死，等SDK修复后添加
//    request.dynamicTokenHandler = {
//      (roomId: String?, account: String?) -> String? in
//      // 处理获取聊天室动态令牌的逻辑，并返回令牌
//      let group = DispatchGroup()
//      group.enter()
//      var token = ""
//      weakSelf?.notifyEvent(
//        weakSelf?.serviceName() ?? "",
//        "getChatRoomDynamicToken",
//        ["account": account as Any, "roomId": roomId as Any],
//        result: { r in
//          token = r as? String ?? ""
//          group.leave()
//        }
//      )
//      group.wait()
//      return token
//    }
    NIMSDK.shared().chatroomManager.enterChatroom(request) { error, chatroom, member in
      var result = [String: Any]()
      if let roomid = chatroom?.roomId as? String,
         var roomInfo = chatroom?.toDic(),
         let member = member?.toDic(roomId: roomid) {
        result["roomId"] = roomid
        result["roomInfo"] = roomInfo
        result["member"] = member
      }
      weakSelf?.chatroomCallback(
        error,
        result,
        resultCallback
      )
    }
  }

  private func exitChatroom(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.exitChatroom(roomId) { error in
      weakSelf?.chatroomCallback(error, nil, resultCallback)
    }
  }

  private func fetchMessageHistory(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments),
          let option = NIMHistoryMessageSearchOption
          .fromDic(arguments) as? NIMHistoryMessageSearchOption else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager
      .fetchMessageHistory(roomId, option: option) { error, messages in
        let ret = messages?.map { message in
          message.toDic()
        }
        weakSelf?.chatroomCallback(error, ["messageList": ret], resultCallback)
      }
  }

  private func fetchChatroomInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.fetchChatroomInfo(roomId) { error, room in
      weakSelf?.chatroomCallback(error, room?.toDic(), resultCallback)
    }
  }

  private func updateChatroomInfo(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomUpdateRequest()
    request.roomId = roomId
    if let r = arguments["request"] as? [String: Any] {
      var info = [NSNumber: Any]()
      if let name = r["name"] as? String {
        info[NSNumber(value: NIMChatroomUpdateTag.name.rawValue)] = name
      }
      if let announcement = r["announcement"] as? String {
        info[NSNumber(value: NIMChatroomUpdateTag.announcement.rawValue)] = announcement
      }
      if let broadcastUrl = r["broadcastUrl"] as? String {
        info[NSNumber(value: NIMChatroomUpdateTag.broadcastUrl.rawValue)] = broadcastUrl
      }
      if let queueModificationLevel = r["queueModificationLevel"] as? String {
        if queueModificationLevel == "manager" {
          info[NSNumber(value: NIMChatroomUpdateTag.queueModificationLevel.rawValue)] =
            NSNumber(booleanLiteral: true)
        } else {
          info[NSNumber(value: NIMChatroomUpdateTag.queueModificationLevel.rawValue)] =
            NSNumber(booleanLiteral: false)
        }
      }
      if let extensionDic = r["extension"] as? [String: Any],
         let extensionJsonString = getJsonStringFromDictionary(extensionDic) {
        info[NSNumber(value: NIMChatroomUpdateTag.ext.rawValue)] = extensionJsonString
      }
      request.updateInfo = info
    }
    if let notifyExtension = arguments["notifyExtension"] as? [String: Any],
       let extJsonString = getJsonStringFromDictionary(notifyExtension) {
      request.notifyExt = extJsonString
      request.needNotify = true
    }
    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.updateChatroomInfo(request) { error in
      weakSelf?.chatroomCallback(error, nil, resultCallback)
    }
  }

  // 聊天室成员管理
  private func fetchChatroomMembers(_ arguments: [String: Any],
                                    _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomMemberRequest()
    request.roomId = roomId
    if let limit = arguments["limit"] as? UInt {
      request.limit = limit
    }
    if let queryType = arguments["queryType"] as? Int,
       let type = NIMChatroomMemberQueryType(rawValue: queryType) {
      switch type {
      case .allNormalMember:
        request.type = .regular
      case .onlineNormalMember:
        request.type = .regularOnline
      case .onlineGuestMemberByEnterTimeAsc:
        request.type = .temp
      case .onlineGuestMemberByEnterTimeDesc:
        request.type = .unRegularReversedOrder
      }
    }
    weak var weakSelf = self

    if let lastMemberId = arguments["lastMemberAccount"] as? String {
      let idRequest = NIMChatroomMembersByIdsRequest()
      idRequest.roomId = roomId
      idRequest.userIds = [lastMemberId]
      NIMSDK.shared().chatroomManager
        .fetchChatroomMembers(byIds: idRequest) { error, members in
          if let ns_error = error as NSError? {
            weakSelf?.errorCallBack(resultCallback, ns_error.description, ns_error.code)
          } else {
            if let member = members?.first {
              request.lastMember = member
              NIMSDK.shared().chatroomManager
                .fetchChatroomMembers(request) { error, members in
                  let data = members?.compactMap { m in
                    m.toDic(roomId: roomId)
                  }
                  weakSelf?.chatroomCallback(error, ["memberList": data], resultCallback)
                }
            } else {
              weakSelf?.errorCallBack(resultCallback, "not find last member")
            }
          }
        }
    } else {
      NIMSDK.shared().chatroomManager.fetchChatroomMembers(request) { error, members in
        let data = members?.compactMap { m in
          m.toDic(roomId: roomId)
        }
        weakSelf?.chatroomCallback(error, ["memberList": data], resultCallback)
      }
    }
  }

  private func fetchChatroomMembersByIds(_ arguments: [String: Any],
                                         _ resultCallback: ResultCallback) {
    guard let request = NIMChatroomMembersByIdsRequest
      .fromDic(arguments) as? NIMChatroomMembersByIdsRequest else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.fetchChatroomMembers(byIds: request) { error, members in
      let data = members?.compactMap { m in
        m.toDic(roomId: request.roomId)
      }
      weakSelf?.chatroomCallback(error, ["memberList": data], resultCallback)
    }
  }

  private func updateMyChatroomMemberInfo(_ arguments: [String: Any],
                                          _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomMemberInfoUpdateRequest()
    request.roomId = roomId
    if let needNotify = arguments["needNotify"] as? Bool {
      request.needNotify = needNotify
    }
    if let notifyExtension = arguments["notifyExtension"] as? [String: Any],
       let ext = getJsonStringFromDictionary(notifyExtension) {
      request.notifyExt = ext
    }

    if let infoRequest = arguments["request"] as? [String: Any] {
      if let save = infoRequest["needSave"] as? Bool {
        request.needSave = save
      }
      var updateInfo = [NSNumber: Any]()
      if let name = infoRequest["nickname"] as? String {
        updateInfo[NSNumber(integerLiteral: NIMChatroomMemberInfoUpdateTag.nick.rawValue)] =
          name
      }
      if let avatar = infoRequest["avatar"] as? String {
        updateInfo[NSNumber(integerLiteral: NIMChatroomMemberInfoUpdateTag.avatar
            .rawValue)] = avatar
      }
      if let ext = infoRequest["extension"] as? [String: Any] {
        updateInfo[NSNumber(integerLiteral: NIMChatroomMemberInfoUpdateTag.ext
            .rawValue)] = getJsonStringFromDictionary(ext)
      }
      request.updateInfo = updateInfo
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.updateMyChatroomMemberInfo(request) { error in
      weakSelf?.chatroomCallback(error, nil, resultCallback)
    }
  }

  private func updateMemberBlack(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let options = arguments["options"] as? [String: Any] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomMemberUpdateRequest()
    if let isAdd = arguments["isAdd"] as? Bool {
      request.enable = isAdd
    }
    if let roomId = getRoomId(options) {
      request.roomId = roomId
    }
    if let userId = getUserId(options) {
      request.userId = userId
    }
    if let notifyExtension = options["notifyExtension"] as? [String: Any],
       let notifyJsonString = getJsonStringFromDictionary(notifyExtension) {
      request.notifyExt = notifyJsonString
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.updateMemberBlack(request) { error in
      if let ns_error = error as NSError? {
        weakSelf?.errorCallBack(resultCallback, ns_error.description, ns_error.code)
      } else {
        let ids = NIMChatroomMembersByIdsRequest()
        ids.roomId = request.roomId
        ids.userIds = [request.userId]
        NIMSDK.shared().chatroomManager.fetchChatroomMembers(byIds: ids) { err, members in
          if members?.isEmpty == false {
            weakSelf?.chatroomCallback(err, members![0].toDic(roomId: request.roomId), resultCallback)
          } else {
            weakSelf?.chatroomCallback(err, nil, resultCallback)
          }
        }
      }
    }
  }

  private func markMemberManager(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let options = arguments["options"] as? [String: Any] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomMemberUpdateRequest()
    if let isAdd = arguments["isAdd"] as? Bool {
      request.enable = isAdd
    }
    if let roomId = getRoomId(options) {
      request.roomId = roomId
    }
    if let userId = getUserId(options) {
      request.userId = userId
    }
    if let notifyExtension = options["notifyExtension"] as? [String: Any],
       let notifyJsonString = getJsonStringFromDictionary(notifyExtension) {
      request.notifyExt = notifyJsonString
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.markMemberManager(request) { error in
      if let ns_error = error as NSError? {
        weakSelf?.errorCallBack(resultCallback, ns_error.description, ns_error.code)
      } else {
        let ids = NIMChatroomMembersByIdsRequest()
        ids.roomId = request.roomId
        ids.userIds = [request.userId]
        NIMSDK.shared().chatroomManager.fetchChatroomMembers(byIds: ids) { err, members in
          if members?.isEmpty == false {
            weakSelf?.chatroomCallback(err, members![0].toDic(roomId: request.roomId), resultCallback)
          } else {
            weakSelf?.chatroomCallback(err, nil, resultCallback)
          }
        }
      }
    }
  }

  private func markNormalMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let options = arguments["options"] as? [String: Any] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomMemberUpdateRequest()
    if let isAdd = arguments["isAdd"] as? Bool {
      request.enable = isAdd
    }
    if let roomId = getRoomId(options) {
      request.roomId = roomId
    }
    if let userId = getUserId(options) {
      request.userId = userId
    }
    if let notifyExtension = options["notifyExtension"] as? [String: Any],
       let notifyJsonString = getJsonStringFromDictionary(notifyExtension) {
      request.notifyExt = notifyJsonString
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.markNormalMember(request) { error in
      if let ns_error = error as NSError? {
        weakSelf?.errorCallBack(resultCallback, ns_error.description, ns_error.code)
      } else {
        let ids = NIMChatroomMembersByIdsRequest()
        ids.roomId = request.roomId
        ids.userIds = [request.userId]
        NIMSDK.shared().chatroomManager.fetchChatroomMembers(byIds: ids) { err, members in
          if members?.isEmpty == false {
            weakSelf?.chatroomCallback(err, members![0].toDic(roomId: request.roomId), resultCallback)
          } else {
            weakSelf?.chatroomCallback(err, nil, resultCallback)
          }
        }
      }
    }
  }

  private func updateMemberMute(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let options = arguments["options"] as? [String: Any] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomMemberUpdateRequest()
    if let isAdd = arguments["isAdd"] as? Bool {
      request.enable = isAdd
    }
    if let roomId = getRoomId(options) {
      request.roomId = roomId
    }
    if let userId = getUserId(options) {
      request.userId = userId
    }
    if let notifyExtension = options["notifyExtension"] as? [String: Any],
       let notifyJsonString = getJsonStringFromDictionary(notifyExtension) {
      request.notifyExt = notifyJsonString
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.updateMemberMute(request) { error in
      weakSelf?.chatroomCallback(error, nil, resultCallback)
    }
  }

  private func kickMember(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments),
          let userid = getUserId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomMemberKickRequest()
    request.roomId = roomId
    request.userId = userid

    if let ext = arguments["notifyExtension"] as? [String: Any] {
      request.notifyExt = getJsonStringFromDictionary(ext)
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.kickMember(request) { error in
      weakSelf?.chatroomCallback(error, nil, resultCallback)
    }
  }

  private func updateMemberTempMute(_ arguments: [String: Any],
                                    _ resultCallback: ResultCallback) {
    guard let options = arguments["options"] as? [String: Any] else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let needNotify = arguments["needNotify"] as? Bool ?? false
    let duration = (arguments["duration"] as? UInt64 ?? 0) / 1000

    let request = NIMChatroomMemberUpdateRequest()
    request.enable = needNotify
    if let roomId = getRoomId(options) {
      request.roomId = roomId
    }
    if let userId = getUserId(options) {
      request.userId = userId
    }
    if let notifyExtension = options["notifyExtension"] as? [String: Any],
       let notifyJsonString = getJsonStringFromDictionary(notifyExtension) {
      request.notifyExt = notifyJsonString
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.updateMemberTempMute(request, duration: duration) { error in
      weakSelf?.chatroomCallback(error, nil, resultCallback)
    }
  }

  // 聊天室队列
  private func fetchChatroomQueue(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    print("ios native fetchChatroomQueue")
    guard let roomId = getRoomId(arguments), roomId.count > 0 else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.fetchChatroomQueue(roomId) { error, data in
      var mapList = [[String: String]]()
      data?.forEach { maps in
        maps.forEach { (key: String, value: String) in
          mapList.append(["key": key, "value": value])
        }
      }
      weakSelf?.chatroomCallback(error, ["entryList": mapList], resultCallback)
    }
  }

  private func updateChatroomQueueObject(_ arguments: [String: Any],
                                         _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomQueueUpdateRequest()
    request.roomId = roomId
    if let isTransient = arguments["isTransient"] as? Bool {
      request.transient = isTransient
    }
    if let entry = arguments["entry"] as? [String: Any] {
      if let key = entry["key"] as? String {
        request.key = key
      }
      if let value = entry["value"] as? String {
        request.value = value
      }
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.updateChatroomQueueObject(request) { error in
      weakSelf?.chatroomCallback(error, nil, resultCallback)
    }
  }

  private func batchUpdateChatroomQueueObject(_ arguments: [String: Any],
                                              _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    let request = NIMChatroomQueueBatchUpdateRequest()
    request.roomId = roomId
    if let entryList = arguments["entryList"] as? [[String: Any]] {
      var elements = [String: String]()
      for item in entryList {
        if let key = item["key"] as? String,
           let value = item["value"] as? String {
          elements[key] = value
        }
      }
      request.elements = elements
    }
    if let needNotify = arguments["needNotify"] as? Bool {
      request.needNotify = needNotify
    }

    if let notifyExtension = arguments["notifyExtension"] as? [String: Any],
       let ext = getJsonStringFromDictionary(notifyExtension) {
      request.notifyExt = ext
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.batchUpdateChatroomQueueObject(request) { error, data in
      weakSelf?.chatroomCallback(error, ["missingKeys": data], resultCallback)
    }
  }

  private func removeChatroomQueueObject(_ arguments: [String: Any],
                                         _ resultCallback: ResultCallback) {
    guard let request = NIMChatroomQueueRemoveRequest
      .fromDic(arguments) as? NIMChatroomQueueRemoveRequest else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }
    if let keyForQueue = arguments["key"] as? String {
      request.key = keyForQueue
    } else {
      request.key = ""
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.removeChatroomQueueObject(request) { error, data in
      var map = [String: Any]()
      if data != nil, data!.keys.count > 0 {
        map["key"] = data!.keys.first
        map["value"] = data!.values.first
      }
      weakSelf?.chatroomCallback(error, map, resultCallback)
    }
  }

  private func dropChatroomQueue(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let roomId = getRoomId(arguments) else {
      errorCallBack(resultCallback, "parameter is error")
      return
    }

    weak var weakSelf = self
    NIMSDK.shared().chatroomManager.dropChatroomQueue(roomId) { error in
      weakSelf?.chatroomCallback(error, nil, resultCallback)
    }
  }
}

extension FLTChatRoomService: NIMChatroomManagerDelegate {
  func chatroomBeKicked(_ result: NIMChatroomBeKickedResult) {
    notifyEvent(
      serviceName(),
      "onKickOut",
      [
        "roomId": result.roomId,
        "reason": FLT_NIMChatroomKickReason.convert(result.reason).rawValue,
        "extension": NSObject().getDictionaryFromJSONString(result.ext),
      ]
    )
  }

  func chatroom(_ roomId: String, autoLoginFailed error: Error) {}

  func chatroom(_ roomId: String, connectionStateChanged state: NIMChatroomConnectionState) {
    // 缺少code
    notifyEvent(
      serviceName(),
      "onStatusChanged",
      [
        "roomId": roomId,
        "status": FLT_NIMChatroomConnectionState.convert(state)?.rawValue as Any,
      ]
    )
  }
}
