/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation
import NIMSDK

enum NOSType: String {
    case Upload = "upload"
}

class FLTNOSService: FLTBaseService, FLTService {
    
    // MARK: Service Protocol
    func serviceName() -> String {
        return ServiceType.NOSService.rawValue
    }
    
    func onMethodCalled(_ method: String, _ arguments: [String : Any], _ resultCallback: ResultCallback) {
        switch method {
        case NOSType.Upload.rawValue:
            upload(arguments, resultCallback)
        default:
            resultCallback.notImplemented()
            break
        }
    }
    
    func register(_ nimCore: NimCore) {
        self.nimCore = nimCore
        nimCore.addService(self)
    }
    
    func upload(_ arguments: [String : Any], _ resultCallback: ResultCallback) {
        guard let filePath = arguments["filePath"] as? String else {
            resultCallback.result(NimResult.error(-1, "upload but the filePath is empty!").toDic())
            return
        }
        _ = arguments["mimeType"] as? String ?? "image/jpeg"
        let sceneKey = arguments["sceneKey"] as? String
        let md5 = arguments["md5"] as? String
        
        let info = NIMResourceExtraInfo()
        info.md5 = md5
        info.scene = sceneKey
        
        NIMSDK.shared().resourceManager.upload(filePath, extraInfo: info) { progress in
            self.notifyEvent(self.serviceName(), "onNOSTransferProgress", ["progress" : progress])
        } completion: { url, error in
            if error != nil {
                let nserror = error! as NSError
                let result = NimResult(nil, NSNumber(value: nserror.code), nserror.description)
                resultCallback.result(result.toDic())
            } else {
                let result = NimResult(url, 0, nil)
                resultCallback.result(result.toDic())
            }
            if url == nil || url!.isEmpty {
                self.notifyEvent(self.serviceName(), "onNOSTransferStatus", nil)
            } else {
                var map: [String : Any] = ["transferType" : "upload"]
                if !filePath.isEmpty {
                    map["path"] = filePath
                }
                if md5 != nil && !md5!.isEmpty {
                    map["md5"] = md5
                }
                if url != nil && !url!.isEmpty {
                    map["url"] = url
                }
                map["status"] = error == nil ? "transferred" : "fail"
                self.notifyEvent(self.serviceName(), "onNOSTransferStatus", map)
            }
        }
    }
}
