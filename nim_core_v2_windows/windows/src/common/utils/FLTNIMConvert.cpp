// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTNIMConvert.h"

FLTNIMConvert::FLTNIMConvert() {}

// 解析baseOption
// v2::V2NIMBasicOption convertToBasicOption(
//    const flutter::EncodableMap* arguments) {
//  v2::V2NIMBasicOption option;
//  auto iter = arguments->begin();
//  for (iter; iter != arguments->end(); ++iter) {
//    if (iter->second.IsNull()) {
//      continue;
//    }
//    if (iter->first == flutter::EncodableValue("useHttps")) {
//      option.useHttps = std::get<bool>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("useHttpdns")) {
//      option.useHttpdns = std::get<bool>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("customClientType")) {
//      option.customClientType = std::get<int>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("customTag")) {
//      option.customTag = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("logReserveDays")) {
//      option.logReserveDays = std::get<int>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("sdkLogLevel")) {
//      option.sdkLogLevel = v2::V2NIMSDKLogLevel(std::get<int>(iter->second));
//    } else if (iter->first == flutter::EncodableValue("disableAppNap")) {
//      option.disableAppNap = std::get<bool>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("enableCloudConversation")) {
//      option.enableCloudConversation = std::get<bool>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("reduceUnreadOnMessageRecall")) {
//      option.reduceUnreadOnMessageRecall = std::get<bool>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("teamNotificationBadge")) {
//      option.teamNotificationBadge = std::get<bool>(iter->second);
//    }
//  }
//  option.sdkType = nim::kNIMSDKTypeFlutter;
//  return option;
//}
//
// v2::V2NIMLinkOption convertToLinkOption(
//    const flutter::EncodableMap* arguments) {
//  v2::V2NIMLinkOption option;
//  auto iter = arguments->begin();
//  for (iter; iter != arguments->end(); ++iter) {
//    if (iter->second.IsNull()) {
//      continue;
//    }
//    if (iter->first == flutter::EncodableValue("linkTimeout")) {
//      option.linkTimeout = std::get<int>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("protocolTimeout")) {
//      option.protocolTimeout = std::get<int>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("asymmetricEncryptionAlgorithm")) {
//      option.asymmetricEncryptionAlgorithm =
//          v2::V2NIMAsymmetricEncryptionAlgorithm(std::get<int>(iter->second));
//    } else if (iter->first ==
//               flutter::EncodableValue("symmetricEncryptionAlgorithm")) {
//      option.symmetricEncryptionAlgorithm =
//          v2::V2NIMSymmetricEncryptionAlgorithm(std::get<int>(iter->second));
//    }
//  }
//  return option;
//}
//
// v2::V2NIMFCSOption convertToFCSOption(const flutter::EncodableMap* arguments)
// {
//  v2::V2NIMFCSOption option;
//  auto iter = arguments->begin();
//  for (iter; iter != arguments->end(); ++iter) {
//    if (iter->second.IsNull()) {
//      continue;
//    }
//    if (iter->first == flutter::EncodableValue("fcsAuthType")) {
//      option.fcsAuthType = v2::V2NIMFCSAuthType(std::get<int>(iter->second));
//    } else if (iter->first == flutter::EncodableValue("customAuthRefer")) {
//      option.customAuthRefer = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("customAuthUA")) {
//      option.customAuthUA = std::get<std::string>(iter->second);
//    }
//  }
//
//  return option;
//}
//
// v2::V2NIMDatabaseOption convertToDatabaseOption(
//    const flutter::EncodableMap* arguments) {
//  v2::V2NIMDatabaseOption option;
//  auto iter = arguments->begin();
//  for (iter; iter != arguments->end(); ++iter) {
//    if (iter->second.IsNull()) {
//      continue;
//    }
//    if (iter->first == flutter::EncodableValue("encryptionKey")) {
//      option.encryptionKey = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("enableBackup")) {
//      option.enableBackup = std::get<bool>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("enableRestore")) {
//      option.enableRestore = std::get<bool>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("backupFolder")) {
//      option.backupFolder = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("sqlcipherVersion")) {
//      option.sqlcipherVersion =
//          v2::V2NIMSQLCipherVersion(std::get<int>(iter->second));
//    }
//  }
//  return option;
//}
//
// v2::V2NIMPrivateServerOption convertToPrivateServerOption(
//    const flutter::EncodableMap* arguments) {
//  v2::V2NIMPrivateServerOption option;
//  auto iter = arguments->begin();
//
//  for (iter; iter != arguments->end(); ++iter) {
//    if (iter->second.IsNull()) {
//      continue;
//    }
//    if (iter->first == flutter::EncodableValue("ipProtocolVersion")) {
//      option.ipProtocolVersion =
//          v2::V2NIMIPProtocolVersion(std::get<int>(iter->second));
//    } else if (iter->first == flutter::EncodableValue("lbsAddresses")) {
//      auto lbsAddresses = std::get<flutter::EncodableList>(iter->second);
//      for (auto address : lbsAddresses) {
//        std::string add = std::get<std::string>(address);
//        option.lbsAddresses.append(add);
//      }
//    } else if (iter->first == flutter::EncodableValue("nosLbsAddress")) {
//      option.nosLbsAddress = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("defaultLinkAddress")) {
//      option.defaultLinkAddress = std::get<std::string>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("defaultLinkAddressIpv6")) {
//      option.defaultLinkAddressIpv6 = std::get<std::string>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("defaultNosUploadAddress")) {
//      option.defaultNosUploadAddress = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("defaultNosUploadHost"))
//    {
//      option.defaultNosUploadHost = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("nosDownloadAddress")) {
//      option.nosDownloadAddress = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("nosAccelerateHosts")) {
//      auto nosAccelerateHosts =
//      std::get<flutter::EncodableList>(iter->second); for (auto address :
//      nosAccelerateHosts) {
//        std::string add = std::get<std::string>(address);
//        option.nosAccelerateHosts.append(add);
//      }
//    } else if (iter->first == flutter::EncodableValue("nosAccelerateAddress"))
//    {
//      option.nosAccelerateAddress = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("probeIpv4Url")) {
//      option.probeIpv4Url = std::get<std::string>(iter->second);
//    } else if (iter->first == flutter::EncodableValue("probeIpv6Url")) {
//      option.probeIpv6Url = std::get<std::string>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("asymmetricEncryptionKeyA")) {
//      option.asymmetricEncryptionKeyA = std::get<std::string>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("asymmetricEncryptionKeyB")) {
//      option.asymmetricEncryptionKeyB = std::get<std::string>(iter->second);
//    } else if (iter->first ==
//               flutter::EncodableValue("asymmetricEncryptionKeyVersion")) {
//      option.asymmetricEncryptionKeyVersion = std::get<int>(iter->second);
//    }
//  }
//  return option;
//}
//
// v2::V2NIMAntispamConfig convertToAntispamConfig(
//    const flutter::EncodableMap* params) {
//  v2::V2NIMAntispamConfig config;
//
//  if (!params) return config;
//
//  auto businessIdIter =
//      params->find(flutter::EncodableValue("antispamBusinessId"));
//  if (businessIdIter != params->end() && !businessIdIter->second.IsNull()) {
//    config.antispamBusinessId = std::get<std::string>(businessIdIter->second);
//  }
//
//  return config;
//};
//
// v2::V2NIMLocationInfo convertToLocationInfo(
//    const flutter::EncodableMap* params) {
//  v2::V2NIMLocationInfo info;
//
//  if (!params) return info;
//
//  // x 坐标
//  auto xIter = params->find(flutter::EncodableValue("x"));
//  if (xIter != params->end() && !xIter->second.IsNull()) {
//    info.x = std::get<double>(xIter->second);
//  }
//
//  // y 坐标
//  auto yIter = params->find(flutter::EncodableValue("y"));
//  if (yIter != params->end() && !yIter->second.IsNull()) {
//    info.y = std::get<double>(yIter->second);
//  }
//
//  // z 坐标
//  auto zIter = params->find(flutter::EncodableValue("z"));
//  if (zIter != params->end() && !zIter->second.IsNull()) {
//    info.z = std::get<double>(zIter->second);
//  }
//
//  return info;
//};
//
// v2::V2NIMChatroomLocationConfig convertToLocationConfig(
//    const flutter::EncodableMap* params) {
//  v2::V2NIMChatroomLocationConfig config;
//
//  if (!params) return config;
//
//  // locationInfo 嵌套结构体
//  auto iter = params->begin();
//  for (iter; iter != params->end(); ++iter) {
//    if (iter->second.IsNull()) {
//      continue;
//    }
//    if (iter->first == flutter::EncodableValue("locationInfo")) {
//      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
//      config.locationInfo = convertToLocationInfo(&paramsMap);
//    } else if (iter->first == flutter::EncodableValue("distance")) {
//      config.distance = std::get<double>(iter->second);
//    }
//  }
//
//  return config;
//}
//
// v2::V2NIMChatroomTagConfig convertToTagConfig(
//    const flutter::EncodableMap* params) {
//  v2::V2NIMChatroomTagConfig config;
//
//  if (!params) return config;
//  auto iter = params->begin();
//  for (iter; iter != params->end(); ++iter) {
//    if (iter->second.IsNull()) {
//      continue;
//    }
//    if (iter->first == flutter::EncodableValue("tags")) {
//      auto tagsList = std::get<flutter::EncodableList>(iter->second);
//
//      for (auto tag : tagsList) {
//        config.tags.push_back(std::get<std::string>(tag));
//      }
//
//    } else if (iter->first == flutter::EncodableValue("notifyTargetTags")) {
//      config.notifyTargetTags = std::get<std::string>(iter->second);
//    }
//  }
//
//  return config;
//}
//
//// 辅助转换函数
// v2::V2NIMChatroomLoginOption convertToLoginOption(
//     const flutter::EncodableMap* params) {
//   v2::V2NIMChatroomLoginOption option;
//
//   if (!params) return option;
//
//   auto authTypeIter = params->find(flutter::EncodableValue("authType"));
//   if (authTypeIter != params->end() && !authTypeIter->second.IsNull()) {
//     option.authType = static_cast<v2::V2NIMLoginAuthType>(
//         std::get<int32_t>(authTypeIter->second));
//   }
//
//   // 函数指针字段不通过 Flutter 传递
//   option.tokenProvider = nullptr;
//   option.loginExtensionProvider = nullptr;
//
//   return option;
// }
