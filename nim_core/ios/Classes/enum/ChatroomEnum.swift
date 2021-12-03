/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK

enum FLT_QueueModificationLevel: String {
    /// 所有人都可以修改聊天室队列
    case anyone = "anyone"
    /// 只有管理员可以修改聊天室队列
    case manager = "manager"
    
    func convertToNIMLevel() -> NIMChatroomQueueModificationLevel {
        switch self {
        case .anyone:
            return NIMChatroomQueueModificationLevel.anyone
        case .manager:
            return NIMChatroomQueueModificationLevel.manager
        }
    }
    
    static func convert(_ level: NIMChatroomQueueModificationLevel) -> FLT_QueueModificationLevel?{
        switch level {
        case .anyone:
            return FLT_QueueModificationLevel.anyone
        case .manager:
            return FLT_QueueModificationLevel.manager
        default:
            break
        }
        return nil
    }
}

enum FLT_NIMChatroomMemberType: String {
    /// 未知
    case  unknown = "unknown"

    /// 游客
    case  guest = "guest"
    
    /// 受限用户（非游客）= 被禁言 + 被拉黑的用户
    case  restricted = "restricted"

    /// 普通成员（非游客）
    case  normal = "normal"

    /// 创建者（非游客）
    case  creator = "creator"

    /// 管理员（非游客）
    case  manager = "manager"

    /// 匿名游客
    case  anonymous = "anonymous"
    
    func convertNIMMemberType() -> NIMChatroomMemberType? {
        switch self {
        case .unknown:
            return nil
        case .guest:
            return NIMChatroomMemberType.guest
        case .restricted:
            return NIMChatroomMemberType.limit
        case .normal:
            return NIMChatroomMemberType.normal
        case .creator:
            return NIMChatroomMemberType.creator
        case .manager:
            return NIMChatroomMemberType.manager
        case .anonymous:
            return NIMChatroomMemberType.anonymousGuest
        }
    }
    
    static func convert(_ type : NIMChatroomMemberType) -> FLT_NIMChatroomMemberType? {
        switch type {
        case NIMChatroomMemberType.guest:
            return .guest
        case NIMChatroomMemberType.limit:
            return .restricted
        case NIMChatroomMemberType.normal:
            return .normal
        case NIMChatroomMemberType.creator:
            return .creator
        case NIMChatroomMemberType.manager:
            return .manager
        case NIMChatroomMemberType.anonymousGuest:
            return .anonymous
        default:
            return .unknown
        }
        return nil
    }
}

enum FLT_NIMTeamUpdateClientCustomMode: String {
    
    /// 只有管理员/群主可以修改（默认）
    case  manager = "manager"

    /// 所有人可以修改
    case  all = "all"
    
    func convertNIMCustomMode() -> NIMTeamUpdateClientCustomMode {
        switch self {
        case .manager:
            return .manager
        case .all:
            return .all
        }
    }
        
    static func convert(_ mode:  NIMTeamUpdateClientCustomMode) -> FLT_NIMTeamUpdateClientCustomMode?{
        switch mode {
        case .all:
            return .all
        case .manager:
            return .manager
        default:
            break
        }
        return nil
    }
}

enum FLT_NIMChatroomConnectionState: String{
    
    /// 正在进入聊天室
    case  connecting = "connecting"

    /// 进入聊天室成功
    case  connected = "connected"

    /// 从聊天室断开
    case  disconnected = "disconnected"

    /// 连接失败
    case  failure = "failure"
    
    func convertNIMConnectState() -> NIMChatroomConnectionState {
        switch self {
        case .connecting:
            return .entering
        case .connected:
            return .enterOK
        case .disconnected:
            return .loseConnection
        case .failure:
            return .enterFailed
        }
    }
    
    static func convert(_ state: NIMChatroomConnectionState) -> FLT_NIMChatroomConnectionState? {
        switch state {
        case .entering:
            return .connecting
        case .enterOK:
            return .connected
        case .loseConnection:
            return .disconnected
        case .enterFailed:
            return .failure
        default:
            break
        }
        return nil
    }
}

enum FLT_NIMChatroomKickReason: String {
    
    /// 未知
    case unknown = "unknown"

    /// 聊天室已经被解散
    case dismissed = "dismissed"

    /// 被管理员踢出
    case byManager = "byManager"

    /// 被其他端踢出
    case byConflictLogin = "byConflictLogin"

    /// 被拉黑
    case blacklisted = "blacklisted"
    
    static func convert(_ state: NIMChatroomKickReason) -> FLT_NIMChatroomKickReason {
        
        switch state {
        case .byConflictLogin:
            return .byConflictLogin
        case .invalidRoom:
            return .dismissed
        case .byManager:
            return .byManager
        case .blacklist:
            return .blacklisted
        default:
            break
        }
        return .unknown
    }
}

enum FLT_NIMChatroomQueueChangeType: String {
    case undefined = "undefined"
    case offer = "offer"
    case poll = "poll"
    case drop = "drop"
    case partialClear = "partialClear"
    case batchUpdate = "batchUpdate"
    
    static func convert(_ type: NIMChatroomQueueChangeType) -> FLT_NIMChatroomQueueChangeType {
        
        switch type {
        case .invalid:
            return .undefined
        case .offer:
            return .offer
        case .poll:
            return .poll
        case .drop:
            return .drop
        case .update:
            return .batchUpdate
        case .batchOffer:
            return .partialClear
        default:
            break
        }
        return .undefined
    }
}

enum NIMChatroomMemberQueryType: Int {
     /// 固定成员（包括创建者,管理员,普通等级用户,受限用户(禁言+黑名单),即使非在线也可以在列表中看到,有数量限制 ）
     case allNormalMember

     /// 仅在线的固定成员
     case onlineNormalMember

     /// 非固定成员 (又称临时成员,只有在线时才能在列表中看到,数量无上限)
     /// 按照进入聊天室时间倒序排序，进入时间越晚的越靠前
     case onlineGuestMemberByEnterTimeDesc

     /// 非固定成员 (又称临时成员,只有在线时才能在列表中看到,数量无上限)
     /// 按照进入聊天室时间顺序排序，进入时间越早的越靠前
     case onlineGuestMemberByEnterTimeAsc
}
