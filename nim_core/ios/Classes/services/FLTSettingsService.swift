/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK

enum SettingType: String {
    case EnableMobilePushWhenPCOnline = "enableMobilePushWhenPCOnline"
    case IsMobilePushEnabledWhenPCOnline = "isMobilePushEnabledWhenPCOnline"
    case SetPushNoDisturbConfig = "setPushNoDisturbConfig"
    case GetPushNoDisturbConfig = "getPushNoDisturbConfig"
    case IsPushShowDetailEnabled = "isPushShowDetailEnabled"
    case EnablePushShowDetail = "enablePushShowDetail"
    case UpdateAPNSToken = "updateAPNSToken"
    case UpdatePushKitToken = "updatePushKitToken"
    case UploadLogs = "uploadLogs"
    case ArchiveLogs = "archiveLogs"
}

class FLTSettingsService: FLTBaseService, FLTService {
    
    func serviceName() -> String {
        return ServiceType.SettingService.rawValue
    }
    
    func onMethodCalled(_ method: String, _ arguments: [String : Any], _ resultCallback: ResultCallback) {
        switch method {
        case SettingType.EnableMobilePushWhenPCOnline.rawValue: enableMobilePushWhenPCOnline(arguments, resultCallback)
        case SettingType.IsMobilePushEnabledWhenPCOnline.rawValue: isMobilePushEnabledWhenPCOnline(arguments, resultCallback)
        case SettingType.SetPushNoDisturbConfig.rawValue: setPushNoDisturbConfig(arguments, resultCallback)
        case SettingType.GetPushNoDisturbConfig.rawValue: getPushNoDisturbConfig(arguments, resultCallback)
        case SettingType.IsPushShowDetailEnabled.rawValue: isPushShowDetailEnabled(arguments, resultCallback)
        case SettingType.EnablePushShowDetail.rawValue: enablePushShowDetail(arguments, resultCallback)
        case SettingType.UpdateAPNSToken.rawValue: updateAPNSToken(arguments, resultCallback)
        case SettingType.UploadLogs.rawValue: uploadLogs(arguments, resultCallback)
        case SettingType.ArchiveLogs.rawValue: archiveLogs(arguments, resultCallback)
        case SettingType.UpdatePushKitToken.rawValue: updatePushKitToken(arguments, resultCallback)
        default:
            resultCallback.notImplemented()
        }
    }
    
    func register(_ nimCore: NimCore) {
        self.nimCore = nimCore
        nimCore.addService(self)
    }
    
    private func enableMobilePushWhenPCOnline(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        if let enable = arguments["enable"] as? Bool {
            weak var weakSelf = self
            let config = NIMPushNotificationMultiportConfig()
            config.shouldPushNotificationWhenPCOnline = enable
            NIMSDK.shared().apnsManager.updateApnsMultiportConfig(config) { error in
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult.error(ns_error.code, ns_error.description).toDic())
                }else {
                    weakSelf?.successCallBack(resultCallback, nil)
                }
            }
        }else {
            errorCallBack(resultCallback, "parameter is nil")
        }
    }
    
    private func isMobilePushEnabledWhenPCOnline(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        let enable = NIMSDK.shared().apnsManager.currentMultiportConfig()?.shouldPushNotificationWhenPCOnline
        resultCallback.result(NimResult.success(enable).toDic())
    }
    
    private func setPushNoDisturbConfig(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        if let enable = arguments["enable"] as? Bool,
           let startTime = arguments["startTime"] as? String,
           let endTime = arguments["endTime"] as? String {
            let settting = NIMPushNotificationSetting()
            settting.noDisturbing = enable
            let startSplits = startTime.components(separatedBy: ":")
            if startSplits.count == 2 {
                if let h = UInt(startSplits[0]){
                    settting.noDisturbingStartH = h
                }
                if let m = UInt(startSplits[1]){
                    settting.noDisturbingStartM = m
                }
            }
            
            let endSplits = endTime.components(separatedBy: ":")
            if endSplits.count == 2 {
                if let h = UInt(endSplits[0]){
                    settting.noDisturbingEndH = h
                }
                if let m = UInt(endSplits[1]){
                    settting.noDisturbingEndM = m
                }
            }
            
            weak var weakSelf = self
            NIMSDK.shared().apnsManager.updateApnsSetting(settting) { error in
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult.success(ns_error.code, ns_error.description).toDic())
                }else {
                    weakSelf?.successCallBack(resultCallback, nil)
                }
            }
        }
    }
    
    private func getPushNoDisturbConfig(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        let settting = NIMSDK.shared().apnsManager.currentSetting()
        var ret = [String: Any]()
        ret["enable"] = settting?.noDisturbing
        if let startH = settting?.noDisturbingStartH, let startM = settting?.noDisturbingStartM {
            ret["startTime"] = String(format: "%02d:%02d", arguments: [startH, startM])
        }
        if let endH = settting?.noDisturbingEndH, let endM = settting?.noDisturbingEndM {
            ret["endTime"] = String(format: "%02d:%02d", arguments: [endH, endM])
        }
        successCallBack(resultCallback, ret)
    }
    
    private func isPushShowDetailEnabled(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        let setting = NIMSDK.shared().apnsManager.currentSetting()
        
        var show = false
        if setting?.type == .detail {
            show = true
        }
        successCallBack(resultCallback, show)
    }
    
    private func enablePushShowDetail(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        if let enalbe = arguments["enable"] as? Bool {
            weak var weakSelf = self
            var setting = NIMSDK.shared().apnsManager.currentSetting()
            if setting == nil {
                setting = NIMPushNotificationSetting()
            }
            if enalbe == true {
                setting?.type = .detail
            }else {
                setting?.type = .noDetail
            }
            NIMSDK.shared().apnsManager.updateApnsSetting(setting!) { error in
                if let ns_error = error as NSError? {
                    resultCallback.result(NimResult.success(ns_error.code, ns_error.description).toDic())
                }else {
                    weakSelf?.successCallBack(resultCallback, nil)
                }
            }
        }
    }
    
    private func updateAPNSToken(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        if let token = arguments["token"] as? FlutterStandardTypedData {
            let key = arguments["key"] as? String
            NIMSDK.shared().updateApnsToken(token.data, customContentKey: key)
            successCallBack(resultCallback, nil)
        }else {
            errorCallBack(resultCallback, "parameter error")
        }
    }
    
    private func updatePushKitToken(_ arguments: [String : Any], _ resultCallback: ResultCallback){
        if let token = arguments["token"] as? String, let data = token.data(using: .utf8){
            NIMSDK.shared().updatePushKitToken(data)
            successCallBack(resultCallback, nil)
        }else {
            errorCallBack(resultCallback, "parameter error")
        }
    }
    
    func uploadLogs(_ arguments: [String : Any], _ resultCallback: ResultCallback) {
        let attach = arguments["comment"] as? String
        let roomId = arguments["chatroomId"] as? String
        NIMSDK.shared().uploadLogs(withAttach: attach, roomId: roomId, completion: { error, path in
            // error虽然没有用nullable修饰，实际可能是null
            if error != nil {
                let nserror = error as NSError
                let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
                resultCallback.result(result.toDic())
            } else {
                let result = NimResult(path, 0, nil)
                resultCallback.result(result.toDic())
            }
        })
    }
    
    func archiveLogs(_ arguments: [String : Any], _ resultCallback: ResultCallback) {
        NIMSDK.shared().archiveLogs { error, path in
            // error虽然没有用nullable修饰，实际可能是null
            if error != nil {
                let nserror = error as NSError
                let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
                resultCallback.result(result.toDic())
            } else {
                let result = NimResult(path, 0, nil)
                resultCallback.result(result.toDic())
            }
        }
    }
}
