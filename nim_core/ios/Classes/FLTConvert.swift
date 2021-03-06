/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import NIMSDK
import Foundation

enum FLTConvertError: Error {
    case runtimeError(String)
}

extension NIMMessageType  {
    
    static func getType(_ sType: String?) throws -> NIMMessageType? {
        switch sType {
        //        case "undef"
        //            return NIMMessageType.undef
        case "text":
            return NIMMessageType.text
        case "image":
            return NIMMessageType.image
        case "audio":
            return NIMMessageType.audio
        case "video":
            return NIMMessageType.video
        case "location":
            return NIMMessageType.location
        case "notification":
            return NIMMessageType.notification
        case "file":
            return NIMMessageType.file
        case "tip":
            return NIMMessageType.tip
        case "robot":
            return NIMMessageType.robot
        case "rtc":
            return NIMMessageType.rtcCallRecord
        case "custom":
            return NIMMessageType.custom
        default:
            break
        }
        throw  FLTConvertError.runtimeError("MsgTypeEnum not contains \(sType ?? "nuknow NIMSessionType")")
    }
    
}

extension NIMSessionType {
    
    static func getType(_ sType: String?) throws -> NIMSessionType?  {
        
        switch sType {
        //        case "none":
        //            return NIMSessionType.P2P
        case "p2p":
            return NIMSessionType.P2P
        case "team":
            return NIMSessionType.team
        case "superTeam":
            return NIMSessionType.superTeam
        case "system":
            return NIMSessionType.YSF
        case "chatRoom":
            return NIMSessionType.chatroom
        default:
            break
        }
        
        throw FLTConvertError.runtimeError("SessionTypeEnum not contains \(sType ?? "nuknow NIMSessionType")")
    }
}


enum NIMNosScene: String {
    /// ????????????????????????eg:??????
    case defaultProfile = "defaultProfile"
    
    /// ??????????????????????????????????????????????????????????????????..
    case defaultIm = "defaultIm"
    
    /// sdk?????????????????????eg:???????????????????????????????????????????????????
    case systemNosScene = "systemNosScene"
    
    /// ??????????????????sceneKey????????? ??????????????????????????????????????????
    case securityPrefix = "securityPrefix"
    
    func getScene() -> String {
        
        switch self {
        case .defaultProfile:
            return NIMNOSSceneTypeAvatar
            
        case .defaultIm:
            return NIMNOSSceneTypeMessage
            
        case .systemNosScene:
            return "nim_system"
            
        case .securityPrefix:
            return NIMNOSSceneTypeSecurity
        
        }
    }
}




