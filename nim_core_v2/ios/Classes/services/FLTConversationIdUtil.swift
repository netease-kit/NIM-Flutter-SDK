// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

enum ConversationIdUtilType: String {
  case conversationId
  case p2pConversationId
  case teamConversationId
  case superTeamConversationId
  case conversationType
  case conversationTargetId
  case isConversationIdValid
  case sessionTypeV1
}

class FLTConversationIdUtil: FLTBaseService, FLTService {
  func serviceName() -> String {
    ServiceType.ConversationIdUtil.rawValue
  }

  func onMethodCalled(_ method: String, _ arguments: [String: Any], _ resultCallback: ResultCallback) {
    switch method {
    case ConversationIdUtilType.p2pConversationId.rawValue:
      p2pConversationId(arguments, resultCallback)
    case ConversationIdUtilType.teamConversationId.rawValue:
      teamConversationId(arguments, resultCallback)
    case ConversationIdUtilType.superTeamConversationId.rawValue:
      superTeamConversationId(arguments, resultCallback)
    case ConversationIdUtilType.conversationType.rawValue:
      conversationType(arguments, resultCallback)
    case ConversationIdUtilType.conversationTargetId.rawValue:
      conversationTargetId(arguments, resultCallback)
    default:
      resultCallback.notImplemented()
    }
  }

  func register(_ nimCore: NimCore) {
    self.nimCore = nimCore
    nimCore.addService(self)
  }

  func conversationId(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String, let conversationTypeInt = arguments["conversationType"] as? Int, let conversationType = V2NIMConversationType(rawValue: conversationTypeInt) else {
      parameterError(resultCallback)
      return
    }
  }

  func p2pConversationId(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let accountId = arguments["accountId"] as? String else {
      parameterError(resultCallback)
      return
    }
    let covnersationId = V2NIMConversationIdUtil.p2pConversationId(accountId)
    successCallBack(resultCallback, covnersationId)
  }

  func teamConversationId(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let teamId = arguments["teamId"] as? String else {
      parameterError(resultCallback)
      return
    }
    let covnersationId = V2NIMConversationIdUtil.teamConversationId(teamId)
    successCallBack(resultCallback, covnersationId)
  }

  func superTeamConversationId(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let superTeamId = arguments["superTeamId"] as? String else {
      parameterError(resultCallback)
      return
    }
    let covnersationId = V2NIMConversationIdUtil.superTeamConversationId(superTeamId)
    successCallBack(resultCallback, covnersationId)
  }

  func conversationType(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    let covnersationType = V2NIMConversationIdUtil.conversationType(conversationId)
    successCallBack(resultCallback, ["conversationType": covnersationType.rawValue])
  }

  func conversationTargetId(_ arguments: [String: Any], _ resultCallback: ResultCallback) {
    guard let conversationId = arguments["conversationId"] as? String else {
      parameterError(resultCallback)
      return
    }
    let covnersationTargetId = V2NIMConversationIdUtil.conversationTargetId(conversationId)
    successCallBack(resultCallback, covnersationTargetId)
  }

  func isConversationIdValid(_ arguments: [String: Any], _ resultCallback: ResultCallback) {}

  func sessionTypeV1(_ arguments: [String: Any], _ resultCallback: ResultCallback) {}
}
