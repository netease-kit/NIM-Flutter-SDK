/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK

enum FLT_NIMMessageType: String  {
    
    // 未定义
    case  undef = "undef"
    // 文本类型消息
    case  text = "text"
    // 图片类型消息
    case  image = "image"
    // 声音类型消息
    case  audio = "audio"
    // 视频类型消息
    case  video = "video"
    // 位置类型消息
    case  location = "location"
    // 文件类型消息
    case  file = "file"
    // 音视频通话
    case  avchat = "avchat"
    // 通知类型消息
    case  notification = "notification"
    // 提醒类型消息
    case  tip = "tip"
    // Robot
    case  robot = "robot"
    // G2话单消息
    case  netcall = "netcall"
    // Custom
    case  custom = "custom"
    // 七鱼接入方自定义的消息
    case  appCustom = "appCustom"
    // 七鱼类型的 custom 消息
    case  qiyuCustom = "qiyuCustom"
    
    static func convert(_ type: NIMMessageType) -> FLT_NIMMessageType? {
        switch type {
        case NIMMessageType.image:
            return FLT_NIMMessageType.image
        case NIMMessageType.audio:
            return FLT_NIMMessageType.audio
        case NIMMessageType.video:
            return FLT_NIMMessageType.video
        case NIMMessageType.file:
            return FLT_NIMMessageType.file
        case NIMMessageType.location:
            return FLT_NIMMessageType.location
        case NIMMessageType.custom:
            return FLT_NIMMessageType.custom
        case NIMMessageType.text:
            return FLT_NIMMessageType.text
        case NIMMessageType.notification:
            return FLT_NIMMessageType.notification
        case NIMMessageType.tip:
            return FLT_NIMMessageType.tip
        case NIMMessageType.robot:
            return FLT_NIMMessageType.robot
        case NIMMessageType.rtcCallRecord:
            return FLT_NIMMessageType.netcall
        default:
            break
        }
        return nil
    }
    
    func convertToNIMMessageType() -> NIMMessageType? {
        
        switch self {
        case .undef:
            return nil
        case .text:
            return NIMMessageType.text
        case .image:
            return NIMMessageType.image
        case .audio:
            return NIMMessageType.audio
        case .video:
            return NIMMessageType.video
        case .location:
            return NIMMessageType.location
        case .file:
            return NIMMessageType.file
        case .avchat:
            return nil
        case .notification:
            return NIMMessageType.location
        case .tip:
            return NIMMessageType.tip
        case .robot:
            return NIMMessageType.robot
        case .netcall:
            return nil
        case .custom:
            return NIMMessageType.custom
        case .appCustom:
            return nil
        case .qiyuCustom:
            return nil
        }
    }
}

enum FLT_NIMSessionType: String {
    
    case none = "none"
    // 单聊
    case p2p = "p2p"
    // 群聊
    case team = "team"
    // 超大群
    case superTeam = "superTeam"
    // 系统消息
    case system = "system"
    // 云商服专用类型
    case ysf = "ysf"
    // 聊天室
    case chatRoom = "chatRoom"
    
    static func convertFLTSessionType(_ type : NIMSessionType) -> FLT_NIMSessionType?{
        switch type {
        case NIMSessionType.P2P:
            return FLT_NIMSessionType.p2p
        case NIMSessionType.team:
            return FLT_NIMSessionType.team
        case NIMSessionType.superTeam:
            return FLT_NIMSessionType.superTeam
        case NIMSessionType.YSF:
            return FLT_NIMSessionType.ysf
        case NIMSessionType.chatroom:
            return FLT_NIMSessionType.chatRoom
        default:
            break
        }
        return nil
    }
    
    func convertToNIMSessionType() -> NIMSessionType? {
        switch self {
        case .none:
            return nil
        case .p2p:
            return NIMSessionType.P2P
        case .team:
            return NIMSessionType.team
        case .superTeam:
            return NIMSessionType.superTeam
        case .system:
            return nil
        case .ysf:
            return NIMSessionType.YSF
        case .chatRoom:
            return NIMSessionType.chatroom
        }
    }
}

enum FLT_NIMMessageStatus: String {
    
    // 草稿(iOS无此状态)
    case draft = "draft"
    // 正在发送中
    case sending = "sending"
    // 发送成功
    case success = "success"
    // 发送失败
    case fail = "fail"
    /*消息已读
     发送消息时表示对方已看过该消息
     接收消息时表示自己已读过，一般仅用于音频消息
     */
    case read = "read"
    // 未读状态
    case unread = "unread"
    
    static func convertFLTStatus(_ type: NIMMessageDeliveryState) -> FLT_NIMMessageStatus? {
        switch type {
        case NIMMessageDeliveryState.failed:
            return FLT_NIMMessageStatus.fail
        case NIMMessageDeliveryState.delivering:
            return FLT_NIMMessageStatus.sending
        case NIMMessageDeliveryState.deliveried:
            return FLT_NIMMessageStatus.sending
        default:
            break
        }
        return nil
    }
    
    func convertDeliveryToNIMMessageDeliveryState() -> NIMMessageDeliveryState? {
        switch self {
        case .sending:
            return NIMMessageDeliveryState.delivering
        case .success:
            return NIMMessageDeliveryState.deliveried
        case .fail:
            return NIMMessageDeliveryState.failed
        default:
            break
        }
        return nil
    }
    
    static func convertFLTStatus(_ type: NIMMessageStatus) -> FLT_NIMMessageStatus?{
        switch type {
        case NIMMessageStatus.read:
            return FLT_NIMMessageStatus.read
        default:
            break
        }
        return nil
    }
    
    func convertToNIMMessageStatus() -> NIMMessageStatus? {
        switch self {
        case .read:
            return NIMMessageStatus.read
        case .unread:
            return NIMMessageStatus.none
        default:
            break
        }
        return nil
    }
}

/// 消息附件下载状态
enum FLT_NIMMessageAttachmentDownloadState: String {
    /// 初始状态，需要上传或下载
    case initial = "initial"
    
    /// 附件收取失败 (尝试下载过一次并失败)
    case failed = "failed"
    
    /// 附件下载中
    case transferring = "transferring"
    
    /// 附件下载成功/无附件
    case transferred = "transferred"
    
    /// 下载取消(iOS无此类型)
    case cancel = "cancel"
    
    static func convertFLTState(_ type: NIMMessageAttachmentDownloadState) -> FLT_NIMMessageAttachmentDownloadState? {
        switch type {
        case NIMMessageAttachmentDownloadState.downloaded:
            return FLT_NIMMessageAttachmentDownloadState.transferred
        case NIMMessageAttachmentDownloadState.downloading:
            return FLT_NIMMessageAttachmentDownloadState.transferring
        case NIMMessageAttachmentDownloadState.failed:
            return FLT_NIMMessageAttachmentDownloadState.failed
        case NIMMessageAttachmentDownloadState.needDownload:
            return FLT_NIMMessageAttachmentDownloadState.initial
        default:
            break
        }
        return nil
    }
    
    func convertToNIMMessageAttachmentDownloadState() -> NIMMessageAttachmentDownloadState? {
        switch self {
        case .initial:
            return NIMMessageAttachmentDownloadState.needDownload
        case .failed:
            return NIMMessageAttachmentDownloadState.failed
        case .transferring:
            return NIMMessageAttachmentDownloadState.downloading
        case .transferred:
            return NIMMessageAttachmentDownloadState.downloaded
        case .cancel:
            return nil
        }
    }
}

enum FLT_NIMMessageDirection: String {
    /// 发送消息
    case  outgoing = "outgoing"
    
    /// 接受消息
    case  received = "received"
}

enum FLT_NIMLoginClientType: String {
    /// 未知
    case unknown = "unknown"
    
    /// Android 客户端
    case android = "android"
    
    /// iOS 客户端
    case ios = "ios"
    
    /// Windows 客户端
    case windows = "windows"
    
    /// WP 客户端
    case wp = "wp"
    
    /// Web端
    case web = "web"
    
    /// RESTFUL API
    case rest = "rest"
    
    /// macOS客户端
    case macos = "macos"
    
    static func convertClientType(_ type: NIMLoginClientType) -> FLT_NIMLoginClientType? {
        
        switch type {
        case NIMLoginClientType.typeUnknown:
            return FLT_NIMLoginClientType.unknown
        case NIMLoginClientType.typeAOS:
            return FLT_NIMLoginClientType.android
        case NIMLoginClientType.typeiOS:
            return FLT_NIMLoginClientType.ios
        case NIMLoginClientType.typePC:
            return FLT_NIMLoginClientType.windows
        case NIMLoginClientType.typeWP:
            return FLT_NIMLoginClientType.wp
        case NIMLoginClientType.typeWeb:
            return FLT_NIMLoginClientType.rest
        case NIMLoginClientType.typeRestful:
            return FLT_NIMLoginClientType.rest
        case NIMLoginClientType.typemacOS:
            return FLT_NIMLoginClientType.macos
        default:
            break
        }
        return nil
    }
    
    func getNIMLoginClientType() -> NIMLoginClientType? {
        switch self {
        case .unknown:
            return NIMLoginClientType.typeUnknown
            
        case .android:
            return NIMLoginClientType.typeAOS
            
        case .ios:
            return NIMLoginClientType.typeiOS
            
        case .windows:
            return NIMLoginClientType.typePC
            
        case .wp:
            return NIMLoginClientType.typeWP
            
        case .web:
            return NIMLoginClientType.typeWeb
            
        case .rest:
            return NIMLoginClientType.typeRestful
            
        case .macos:
            return NIMLoginClientType.typemacOS
        }
    }
}
