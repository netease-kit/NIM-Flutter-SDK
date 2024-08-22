// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation
import NIMSDK

extension NIMSDKOption {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    let keyPaths = getKeyPaths(self)
    return keyPaths
  }
}

enum FLT_NIMAsymEncryptionType: String {
  case rsa

  case sm2

  case rsaOaep1

  case rsaOaep256

  func getNIMAsymEncryptionType() -> NIMAsymEncryptionType? {
    switch self {
    case .rsa:
      return NIMAsymEncryptionType.RSA

    case .sm2:
      return NIMAsymEncryptionType.SM2

    case .rsaOaep1:
      return NIMAsymEncryptionType.RSA

    case .rsaOaep256:
      return NIMAsymEncryptionType.RSA
    }
  }

  func getNIMRSAPaddingMode() -> NIMRSAPaddingMode? {
    switch self {
    case .rsa:
      return NIMRSAPaddingMode.PKCS1

    case .rsaOaep1:
      return NIMRSAPaddingMode.oaepWithSHA_1AndMGF1

    case .rsaOaep256:
      return NIMRSAPaddingMode.oaepWithSHA_256AndMGF1
    case .sm2:
      return nil
    }
  }
}

enum FLT_NIMLinkAddressType: String {
  case ipv4
  case ipv6
  case any

  func getNIMLinkAddressType() -> NIMLinkAddressType? {
    switch self {
    case .ipv4:
      return NIMLinkAddressType.ipv4
    case .ipv6:
      return NIMLinkAddressType.ipv6
    case .any:
      return NIMLinkAddressType.auto
    }
  }
}

enum FLT_NIMSymEncryptionType: String {
  case rc4

  case aes

  case sm4

  func getNIMSymEncryptionType() -> NIMSymEncryptionType? {
    switch self {
    case .rc4:
      return NIMSymEncryptionType.RC4

    case .aes:
      return NIMSymEncryptionType.AES

    case .sm4:
      return NIMSymEncryptionType.SM4
    }
  }
}

enum FLT_NIMHandshakeType: String {
  case v0

  case v1

  func getNIMHandshakeType() -> NIMHandshakeType? {
    switch self {
    case .v0:
      return NIMHandshakeType.basics
    case .v1:
      return NIMHandshakeType.advanced
    }
  }
}

extension NIMServerSetting {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    let keyPaths = getKeyPaths(self)
    return keyPaths
  }

  static func fromDic(_ json: [String: Any]) -> NIMServerSetting? {
    var model = NIMServerSetting()
    if let module = json["module"] as? String {
      model.module = module
    }

    if let publicKeyVersion = json["publicKeyVersion"] as? Int {
      model.version = publicKeyVersion
    }
    if let lbs = json["lbs"] as? String {
      model.lbsAddress = lbs
    }

    if let defaultLink = json["defaultLink"] as? String {
      model.linkAddress = defaultLink
    }

    if let nosUploadLbs = json["nosUploadLbs"] as? String {
      model.nosLbsAddress = nosUploadLbs
    }

    if let nosUploadDefaultLink = json["nosUploadDefaultLink"] as? String {
      model.nosUploadAddress = nosUploadDefaultLink
    }
    if let nosUpload = json["nosUpload"] as? String {
      model.nosUploadHost = nosUpload
    }
    if let nosSupportHttps = json["nosSupportHttps"] as? Bool {
      model.httpsEnabled = nosSupportHttps
    }
    if let nosDownloadUrlFormat = json["nosDownloadUrlFormat"] as? String {
      model.nosDownloadAddress = nosDownloadUrlFormat
    }
    if let nosDownload = json["nosDownload"] as? String {
      model.nosAccelerateHost = nosDownload
    }
    if let nosAccess = json["nosAccess"] as? String {
      model.nosAccelerateAddress = nosAccess
    }

    if let linkIpv6 = json["linkIpv6"] as? String {
      model.ipv6LinkAddress = linkIpv6
    }

    if let ipProtocolVersion = json["ipProtocolVersion"] as? String,
       let linkType = FLT_NIMLinkAddressType(rawValue: ipProtocolVersion)?.getNIMLinkAddressType() {
      model.lbsLinkAddressType = linkType
    }

    if let probeIpv4Url = json["probeIpv4Url"] as? String {
      model.lbsIpv4DetectAddress = probeIpv4Url
    }

    if let probeIpv6Url = json["probeIpv6Url"] as? String {
      model.lbsIpv6DetectAddress = probeIpv6Url
    }

    if let handshakeType = json["handshakeType"] as? String,
       let shakeType = FLT_NIMHandshakeType(rawValue: handshakeType)?.getNIMHandshakeType() {
      model.handshakeType = shakeType
    }

    if let nosCdnEnable = json["nosCdnEnable"] as? Bool {
      model.cdnEnable = nosCdnEnable
    }

    if let nosDownloadSet = json["nosDownloadSet"] as? [String] {
      model.nosAccelerateHosts = nosDownloadSet
    }

    var encryptionConfig = NIMEncryptionConfig()

    if let negoKeyNeca = json["negoKeyNeca"] as? String,
       let encryptionType = FLT_NIMAsymEncryptionType(rawValue: negoKeyNeca)?.getNIMAsymEncryptionType() {
      encryptionConfig.asymEncryptionType = encryptionType
      // ras 处理Option
      if encryptionType == NIMAsymEncryptionType.RSA {
        var nimRSAOption = NIMRSAOption()
        if let negoKeyEncaKeyVersion = json["negoKeyEncaKeyVersion"] as? Int {
          nimRSAOption.version = negoKeyEncaKeyVersion
        }
        if let padding = FLT_NIMAsymEncryptionType(rawValue: negoKeyNeca)?.getNIMRSAPaddingMode() {
          nimRSAOption.paddingMode = padding
        }
        if let negoKeyEncaKeyParta = json["negoKeyEncaKeyParta"] as? String {
          nimRSAOption.module = negoKeyEncaKeyParta
        }
        if let negoKeyEncaKeyPartb = json["negoKeyEncaKeyPartb"] as? String,
           let exp = UInt(negoKeyEncaKeyPartb) {
          nimRSAOption.exp = exp
        }
        encryptionConfig.update(nimRSAOption)
      }
      if encryptionType == NIMAsymEncryptionType.SM2 {
        var nimSM2Option = NIMSM2Option()
        if let negoKeyEncaKeyVersion = json["negoKeyEncaKeyVersion"] as? Int {
          nimSM2Option.version = negoKeyEncaKeyVersion
        }
        if let negoKeyEncaKeyParta = json["negoKeyEncaKeyParta"] as? String {
          nimSM2Option.sm2X = negoKeyEncaKeyParta
        }
        if let negoKeyEncaKeyPartb = json["negoKeyEncaKeyPartb"] as? String {
          nimSM2Option.sm2Y = negoKeyEncaKeyPartb
        }
        encryptionConfig.update(nimSM2Option)
      }
    }

    if let commEnca = json["commEnca"] as? String,
       let symEncryptionType = FLT_NIMSymEncryptionType(rawValue: commEnca)?.getNIMSymEncryptionType() {
      encryptionConfig.symEncryptionType = symEncryptionType
    }

    model.setValue(encryptionConfig, forKey: "_encryptConfig")

    return model
  }
}

extension NIMSDKConfig {
  @objc static func modelCustomPropertyMapper() -> [String: Any]? {
    var keyPaths = getKeyPaths(self)
    keyPaths[#keyPath(fetchAttachmentAutomaticallyAfterReceiving)] =
      "enablePreloadMessageAttachment"
    keyPaths[#keyPath(exceptionOptimizationEnabled)] = "enableReportLogAutomatically"
    keyPaths[#keyPath(customTag)] = "loginCustomTag"
    keyPaths[#keyPath(fetchAttachmentAutomaticallyAfterReceivingInChatroom)] =
      "enableFetchAttachmentAutomaticallyAfterReceivingInChatroom"
    keyPaths[#keyPath(fileProtectionNone)] = "enableFileProtectionNone"
    keyPaths[#keyPath(shouldCountTeamNotification)] = "shouldTeamNotificationMessageMarkUnread"
    keyPaths[#keyPath(animatedImageThumbnailEnabled)] = "enableAnimatedImageThumbnail"
    keyPaths[#keyPath(reconnectInBackgroundStateDisabled)] = "disableReconnectInBackgroundState"
    keyPaths[#keyPath(teamReceiptEnabled)] = "enableTeamReceipt"
    keyPaths[#keyPath(fileQuickTransferEnabled)] = "enableFileQuickTransfer"
    keyPaths[#keyPath(exceptionOptimizationEnabled)] = "enableReportLogAutomatically"
    keyPaths[#keyPath(asyncLoadRecentSessionEnabled)] = "enableAsyncLoadRecentSession"
    keyPaths.removeValue(forKey: #keyPath(NIMSDKConfig.delegate))
    return keyPaths
  }
}

extension NIMLoginClient: NimDataConvertProtrol {
  @objc static func modelPropertyBlacklist() -> [String] {
    [#keyPath(NIMLoginClient.type), #keyPath(NIMLoginClient.timestamp)]
  }

  func toDic() -> [String: Any]? {
    if var jsonObject = yx_modelToJSONObject() as? [String: Any] {
      let logintime = Int(timestamp * 1000)
      jsonObject["loginTime"] = logintime
      if let clientType = FLT_NIMLoginClientType.convertClientType(type)?.rawValue {
        jsonObject["clientType"] = clientType
      }

      return jsonObject
    }
    return nil
  }

  static func fromDic(_ json: [String: Any]) -> Any? {
    if let model = NIMLoginClient.yx_model(with: json) {
      if let loginTime = json["loginTime"] as? Int {
        model.setValue(Double(loginTime) / 1000, forKey: "_timestamp")
      }
      if let custom = json["customTag"] as? String {
        model.setValue(custom, forKey: "_customTag")
      }
      if let os = json["os"] as? String {
        model.setValue(os, forKey: "_os")
      }
      if let type = json["clientType"] as? String,
         let nimType = FLT_NIMLoginClientType(rawValue: type)?.getNIMLoginClientType() {
        model.setValue(nimType.rawValue, forKey: "_type")
      }
      return model
    }
    return nil
  }
}
