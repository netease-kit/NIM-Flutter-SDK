// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMDeleteMessageOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMDeleteMessageOption.removeFromDB): "removeFromDB"]
  }
}

extension NIMDeleteMessagesOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMDeleteMessagesOption.removeTable): "removeTable",
     #keyPath(NIMDeleteMessagesOption.removeSession): "removeSession"]
  }
}

extension NIMBatchDeleteMessagesOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMBatchDeleteMessagesOption.start): "start",
     #keyPath(NIMBatchDeleteMessagesOption.end): "end"]
  }
}

extension NIMHistoryMessageSearchOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMHistoryMessageSearchOption.startTime): "startTime",
     #keyPath(NIMHistoryMessageSearchOption.endTime): "endTime",
     #keyPath(NIMHistoryMessageSearchOption.limit): "limit",
     #keyPath(NIMHistoryMessageSearchOption.order): "order",
     #keyPath(NIMHistoryMessageSearchOption.currentMessage): "currentMessage",
     #keyPath(NIMHistoryMessageSearchOption.sync): "sync",
     #keyPath(NIMHistoryMessageSearchOption.messageTypes): "messageTypes",
     #keyPath(NIMHistoryMessageSearchOption.customFilter): "customFilter",
     #keyPath(NIMHistoryMessageSearchOption.serverId): "serverId",
     #keyPath(NIMHistoryMessageSearchOption.createRecentSessionIfNotExists):
       "createRecentSessionIfNotExists",
     #keyPath(NIMHistoryMessageSearchOption.syncMessageTypes): "syncMessageTypes"]
  }
}

extension NIMClearMessagesOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMClearMessagesOption.removeRoam): "removeRoam"]
  }
}

extension NIMSessionDeleteAllRemoteMessagesOptions {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [
      #keyPath(NIMSessionDeleteAllRemoteMessagesOptions.removeOtherClients): "removeOtherClients",
      #keyPath(NIMSessionDeleteAllRemoteMessagesOptions.ext): "ext",
    ]
  }
}

extension NIMMessageSearchOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMMessageSearchOption.startTime): "startTime",
     #keyPath(NIMMessageSearchOption.endTime): "endTime",
     #keyPath(NIMMessageSearchOption.limit): "limit",
     #keyPath(NIMMessageSearchOption.order): "order",
     #keyPath(NIMMessageSearchOption.messageTypes): "msgTypeList",
     #keyPath(NIMMessageSearchOption.messageSubTypes): "messageSubTypes",
     #keyPath(NIMMessageSearchOption.allMessageTypes): "allMessageTypes",
     #keyPath(NIMMessageSearchOption.searchContent): "searchContent",
     #keyPath(NIMMessageSearchOption.fromIds): "fromIds",
     #keyPath(NIMMessageSearchOption.enableContentTransfer): "enableContentTransfer"]
  }
}

extension NIMMessageServerRetrieveOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMMessageServerRetrieveOption.startTime): "startTime",
     #keyPath(NIMMessageServerRetrieveOption.endTime): "endTime",
     #keyPath(NIMMessageServerRetrieveOption.limit): "limit",
     #keyPath(NIMMessageServerRetrieveOption.order): "order",
     #keyPath(NIMMessageServerRetrieveOption.keyword): "keyword"]
  }
}

extension NIMMessageFullKeywordSearchOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    [#keyPath(NIMMessageFullKeywordSearchOption.startTime): "fromTime",
     #keyPath(NIMMessageFullKeywordSearchOption.endTime): "toTime",
     #keyPath(NIMMessageFullKeywordSearchOption.keyword): "keyword",
     #keyPath(NIMMessageFullKeywordSearchOption.msgLimit): "msgLimit",
     #keyPath(NIMMessageFullKeywordSearchOption.sessionLimit): "sessionLimit",
     #keyPath(NIMMessageFullKeywordSearchOption.asc): "asc",
     #keyPath(NIMMessageFullKeywordSearchOption.p2pArray): "p2pList",
     #keyPath(NIMMessageFullKeywordSearchOption.teamArray): "teamList",
     #keyPath(NIMMessageFullKeywordSearchOption.senderArray): "senderList",
     #keyPath(NIMMessageFullKeywordSearchOption.msgTypeArray): "msgTypeArray", // 单独处理该字段
     #keyPath(NIMMessageFullKeywordSearchOption.msgSubtypeArray): "msgSubtypeList"]
  }
}
