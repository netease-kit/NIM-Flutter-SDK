/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK

enum FLT_NIMTeamMemberType: String {
    ///普通成员
    case normal = "normal"
    ///创建者
    case owner = "owner"
    ///管理员
    case manager = "manager"
    ///待审核的申请加入用户
    case apply = "apply"
    
    func convertNIMMemberType() -> NIMTeamMemberType {
        
        switch self {
        case .normal:
            return NIMTeamMemberType.normal
        case .owner:
            return NIMTeamMemberType.owner
        case .manager:
            return NIMTeamMemberType.manager
        case .apply:
            return NIMTeamMemberType.apply
        }
    }
    
    static func convert(_ type: NIMTeamMemberType) -> FLT_NIMTeamMemberType?{
        switch type {
        case NIMTeamMemberType.normal:
            return .normal
        case NIMTeamMemberType.owner:
            return .owner
        case NIMTeamMemberType.manager:
            return .manager
        case NIMTeamMemberType.apply:
            return .apply
        default:
            break
        }
        return nil
    }
}


enum FLT_NIMTeamType: String {
    case advanced = "advanced"
    case normal = "normal"
    // super是关键字
    case superTeam = "superTeam"
    
    func convertNIMTeamType() -> NIMTeamType {
        switch self {
        case .advanced:
            return NIMTeamType.advanced
        case .normal:
            return NIMTeamType.normal
        case .superTeam:
            return NIMTeamType.super
        }
    }
    
    static func convert(_ type: NIMTeamType) -> FLT_NIMTeamType? {
        switch type {
        case NIMTeamType.advanced:
            return .advanced
        case NIMTeamType.normal:
            return .normal
        case NIMTeamType.super:
            return .superTeam
        default:
            break
        }
        return nil
    }
}

enum FLT_NIMTeamJoinMode: String {
    ///可以自由加入，无需管理员验证
    case free = "free"
    
    ///需要先申请，管理员统一方可加入
    case apply = "apply"
    
    ///私有群，不接受申请，仅能通过邀请方式入群
    case Private = "private"
    
    func convertNimTeamJoinModel() -> NIMTeamJoinMode {
        switch self {
        case .free:
            return NIMTeamJoinMode.noAuth
        case .apply:
            return NIMTeamJoinMode.needAuth
        case .Private:
            return NIMTeamJoinMode.rejectAll
        }
    }
    
    static func convert(_ mode: NIMTeamJoinMode) -> FLT_NIMTeamJoinMode?{
        switch mode{
        case .noAuth:
            return .free
        case .needAuth:
            return .apply
        case .rejectAll:
            return .Private
        default:
            break
        }
        return nil
    }
    
}

enum FLT_NIMTeamNotifyState: String {
    ///群全部消息提醒
    case all = "all"
    
    ///管理员消息提醒
    case manager = "manager"
    
    ///群所有消息不提醒
    case mute = "mute"
    
    func convertNIMNotifyState() -> NIMTeamNotifyState{
        switch self {
        case .all:
            return .all
        case .manager:
            return .onlyManager
        case .mute:
            return .none
        }
    }
    
    static func convert(_ state: NIMTeamNotifyState) -> FLT_NIMTeamNotifyState?{
        switch state {
        case .all:
            return .all
        case .onlyManager:
            return .manager
        case .none:
            return .mute
        default:
            break
        }
        return nil
    }
}

enum FLT_NIMTeamInviteMode: String {
    ///只有管理员可以邀请其他人入群（默认）
    case manager = "manager"
    
    ///所有人都可以邀请其他人入群
    case all = "all"
    
    func convertNIMInviteModel() -> NIMTeamInviteMode {
        switch self {
        case .manager:
            return .manager
        case .all:
            return .all
        }
    }
    
    static func convert(_ mode: NIMTeamInviteMode) -> FLT_NIMTeamInviteMode?{
        
        switch mode {
        case .manager:
            return .manager
        case .all:
            return .all
        default:
            break
        }
        return nil
    }
}

enum FLT_NIMTeamBeInviteMode: String {
    ///需要被邀请方同意（默认）
    case needAuth = "needAuth"
    
    ///不需要被邀请方同意
    case noAuth = "noAuth"
    
    public func convertNIMBeINviteMode() -> NIMTeamBeInviteMode {
        switch self {
        case .needAuth:
            return .needAuth
        case .noAuth:
            return .noAuth
        }
    }
    
    static func convert(_ mode: NIMTeamBeInviteMode) -> FLT_NIMTeamBeInviteMode? {
        switch mode {
        case .needAuth:
            return .needAuth
        case .noAuth:
            return .noAuth
        default:
            break
        }
        return nil
    }
}

enum FLT_NIMTeamUpdateInfoMode: String {
    
    /// 只有管理员/群主可以修改（默认）
    case  manager = "manager"
    
    /// 所有人可以修改
    case all = "all"
    
    public func  convertNIMUpdateMode() -> NIMTeamUpdateInfoMode{
        switch self {
        case .manager:
            return .manager
        case .all:
            return .all
        }
    }
    
    static func convert(_ mode: NIMTeamUpdateInfoMode) -> FLT_NIMTeamUpdateInfoMode? {
        switch mode {
        case .manager:
            return .manager
        case .all:
            return .all
        default:
            break
        }
        return nil
    }
}

enum NIMTeamFieldEnum: Int {
    ///群公告
    case announcement
    ///群被邀请模式：被邀请人的同意方式
    case beInviteMode
    ///群扩展字段（客户端自定义信息）
    case extensionField
    ///群头像
    case icon
    ///群简介
    case introduce
    ///群邀请模式：谁可以邀请他人入群
    case inviteMode
    ///指定创建群组的最大群成员数量 ，MaxMemberCount不能超过应用级配置的最大人数
    case maxMemberCount
    ///群名
    case name
    ///群资料扩展字段修改模式：谁可以修改群自定义属性(扩展字段)
    case teamExtensionUpdateMode
    ///群资料修改模式：谁可以修改群资料
    case teamUpdateMode
    ///申请加入群组的验证模式
    case verifyType
}

enum FLT_NIMSuperTeamUpdateTag: String {
    case announcement = "announcement"
    case beInviteMode = "beInviteMode"
    case extensiontype = "extension"
    case icon = "icon"
    case introduce = "introduce"
    case name = "name"
    case teamExtensionUpdateMode = "teamExtensionUpdateMode"
    case verifyType = "verifyType"
    case muteMode = "muteMode"
    
    func convertToNIMTeamUpdateTag() -> NIMSuperTeamUpdateTag?{
        switch self {
        case .announcement:
            return .anouncement
        case .beInviteMode:
            return .beInviteMode
        case .extensiontype:
            return .clientCustom
        case .icon:
            return .avatar
        case .introduce:
            return .intro
        case .name:
            return .name
        case .teamExtensionUpdateMode:
            return .serverCustom
        case .verifyType:
            return .joinMode
        case .muteMode:
            return .muteMode
        }
    }
    
    static func convert(_ type: NIMSuperTeamUpdateTag) -> FLT_NIMSuperTeamUpdateTag? {
        switch type {
        case .beInviteMode:
            return .beInviteMode
        case .clientCustom:
            return .extensiontype
        case .avatar:
            return .icon
        case .intro:
            return .introduce
        case .name:
            return .name
        case .serverCustom:
            return .teamExtensionUpdateMode
        case .joinMode:
            return .verifyType
        case .muteMode:
            return .muteMode
        default:
            break
        }
        return nil
    }
}

enum FLT_NIMTeamUpdateTag: String {
    case announcement = "announcement"
    case beInviteMode = "beInviteMode"
    case extensiontype = "extension"
    case icon = "icon"
    case introduce = "introduce"
    case inviteMode = "inviteMode"
    case maxMemberCount = "maxMemberCount"
    case name = "name"
    case teamExtensionUpdateMode = "teamExtensionUpdateMode"
    case teamUpdateMode = "teamUpdateMode"
    case verifyType = "verifyType"
    case muteMode = "muteMode"
    
    func convertToNIMTeamUpdateTag() -> NIMTeamUpdateTag?{
        switch self {
        case .announcement:
            return .anouncement
        case .beInviteMode:
            return .beInviteMode
        case .extensiontype:
            return .clientCustom
        case .icon:
            return .avatar
        case .introduce:
            return .intro
        case .inviteMode:
            return .inviteMode
        case .maxMemberCount:
            return nil
        case .name:
            return .name
        case .teamExtensionUpdateMode:
            return .serverCustom
        case .teamUpdateMode:
            return .updateInfoMode
        case .verifyType:
            return .joinMode
        case .muteMode:
            return .muteMode
        }
    }
    
    static func convert(_ type: NIMTeamUpdateTag) -> FLT_NIMTeamUpdateTag? {
        switch type {
        case .beInviteMode:
            return .beInviteMode
        case .clientCustom:
            return .extensiontype
        case .avatar:
            return .icon
        case .intro:
            return .introduce
        case .inviteMode:
            return .inviteMode
        case .name:
            return .name
        case .serverCustom:
            return .teamExtensionUpdateMode
        case .updateInfoMode:
            return .teamUpdateMode
        case .joinMode:
            return .verifyType
        case .muteMode:
            return .muteMode
        default:
            break
        }
        return nil
    }
}

