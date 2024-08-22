// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTInitializeService.h"

#if defined(_WIN32)
#include <windows.h>
#endif

#include "../NimResult.h"
#include "nim_cpp_wrapper/api/nim_cpp_client.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"

using namespace nim;

FLTInitializeService::FLTInitializeService() {
  m_serviceName = "InitializeService";
}

void FLTInitializeService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "initialize") {
    initializeSDK(arguments, result);
  } else if (method == "releaseDesktop") {
    v2::V2NIMClient::get().uninit();
    result->Success(NimResult::getSuccessResult());
    NimCore::getInstance()->cleanService();
  } else {
    result->NotImplemented();
  }
}

// 解析baseOption
v2::V2NIMBasicOption getBasicOption(const flutter::EncodableMap* arguments) {
  v2::V2NIMBasicOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("useHttps")) {
      option.useHttps = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("useHttpdns")) {
      option.useHttpdns = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customClientType")) {
      option.customClientType = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customTag")) {
      option.customTag = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("logReserveDays")) {
      option.logReserveDays = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sdkLogLevel")) {
      option.sdkLogLevel = v2::V2NIMSDKLogLevel(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("disableAppNap")) {
      option.disableAppNap = std::get<bool>(iter->second);
    }
  }
  option.sdkType = nim::kNIMSDKTypeFlutter;
  return option;
}

v2::V2NIMLinkOption getLinkOption(const flutter::EncodableMap* arguments) {
  v2::V2NIMLinkOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("linkTimeout")) {
      option.linkTimeout = std::get<int>(iter->second);
    } else if (iter->first == flutter::EncodableValue("protocolTimeout")) {
      option.protocolTimeout = std::get<int>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("asymmetricEncryptionAlgorithm")) {
      option.asymmetricEncryptionAlgorithm =
          v2::V2NIMAsymmetricEncryptionAlgorithm(std::get<int>(iter->second));
    } else if (iter->first ==
               flutter::EncodableValue("symmetricEncryptionAlgorithm")) {
      option.symmetricEncryptionAlgorithm =
          v2::V2NIMSymmetricEncryptionAlgorithm(std::get<int>(iter->second));
    }
  }
  return option;
}

v2::V2NIMFCSOption getFCSOption(const flutter::EncodableMap* arguments) {
  v2::V2NIMFCSOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("fcsAuthType")) {
      option.fcsAuthType = v2::V2NIMFCSAuthType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("customAuthRefer")) {
      option.customAuthRefer = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("customAuthUA")) {
      option.customAuthUA = std::get<std::string>(iter->second);
    }
  }

  return option;
}

v2::V2NIMDatabaseOption getDatabaseOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMDatabaseOption option;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("encryptionKey")) {
      option.encryptionKey = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("enableBackup")) {
      option.enableBackup = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("enableRestore")) {
      option.enableRestore = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("backupFolder")) {
      option.backupFolder = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("sqlcipherVersion")) {
      option.sqlcipherVersion =
          v2::V2NIMSQLCipherVersion(std::get<int>(iter->second));
    }
  }
  return option;
}

v2::V2NIMPrivateServerOption getPrivateServerOption(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMPrivateServerOption option;
  auto iter = arguments->begin();

  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("ipProtocolVersion")) {
      option.ipProtocolVersion =
          v2::V2NIMIPProtocolVersion(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("lbsAddresses")) {
      auto lbsAddresses = std::get<flutter::EncodableList>(iter->second);
      for (auto address : lbsAddresses) {
        std::string add = std::get<std::string>(address);
        option.lbsAddresses.append(add);
      }
    } else if (iter->first == flutter::EncodableValue("nosLbsAddress")) {
      option.nosLbsAddress = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("defaultLinkAddress")) {
      option.defaultLinkAddress = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("defaultLinkAddressIpv6")) {
      option.defaultLinkAddressIpv6 = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("defaultNosUploadAddress")) {
      option.defaultNosUploadAddress = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("defaultNosUploadHost")) {
      option.defaultNosUploadHost = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("nosDownloadAddress")) {
      option.nosDownloadAddress = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("nosAccelerateHosts")) {
      auto nosAccelerateHosts = std::get<flutter::EncodableList>(iter->second);
      for (auto address : nosAccelerateHosts) {
        std::string add = std::get<std::string>(address);
        option.nosAccelerateHosts.append(add);
      }
    } else if (iter->first == flutter::EncodableValue("nosAccelerateAddress")) {
      option.nosAccelerateAddress = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("probeIpv4Url")) {
      option.probeIpv4Url = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("probeIpv6Url")) {
      option.probeIpv6Url = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("asymmetricEncryptionKeyA")) {
      option.asymmetricEncryptionKeyA = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("asymmetricEncryptionKeyB")) {
      option.asymmetricEncryptionKeyB = std::get<std::string>(iter->second);
    } else if (iter->first ==
               flutter::EncodableValue("asymmetricEncryptionKeyVersion")) {
      option.asymmetricEncryptionKeyVersion = std::get<int>(iter->second);
    }
  }
  return option;
}

void FLTInitializeService::initializeSDK(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (arguments) {
    std::string appkey = "";
    std::string sdkRootDir = "";
    v2::V2NIMInitOption option;
    v2::V2NIMBasicOption basicOption;
    v2::V2NIMLinkOption linkOption;
    v2::V2NIMDatabaseOption databaseOption;
    v2::V2NIMFCSOption fcsOption;
    v2::V2NIMPrivateServerOption privateServerOption;

    auto iter = arguments->begin();
    for (iter; iter != arguments->end(); ++iter) {
      if (iter->second.IsNull()) {
        continue;
      }

      if (iter->first == flutter::EncodableValue("appKey")) {
        appkey = std::get<std::string>(iter->second);
        option.appkey = appkey;
        std::cout << "appkey: " << appkey << std::endl;
      } else if (iter->first == flutter::EncodableValue("sdkRootDir")) {
        sdkRootDir = std::get<std::string>(iter->second);
        std::cout << "sdkRootDir: " << sdkRootDir << std::endl;
      } else if (iter->first == flutter::EncodableValue("basicOption")) {
        auto params = std::get<flutter::EncodableMap>(iter->second);
        basicOption = getBasicOption(&params);
        option.basicOption = basicOption;
        std::cout << "basicOption: " << std::endl;
      } else if (iter->first == flutter::EncodableValue("linkOption")) {
        auto paramsLink = std::get<flutter::EncodableMap>(iter->second);
        linkOption = getLinkOption(&paramsLink);
        option.linkOption = linkOption;
        std::cout << "linkOption: " << std::endl;
      } else if (iter->first == flutter::EncodableValue("databaseOption")) {
        auto paramsDataBase = std::get<flutter::EncodableMap>(iter->second);
        databaseOption = getDatabaseOption(&paramsDataBase);
        option.databaseOption = databaseOption;
        std::cout << "databaseOption: " << std::endl;

      } else if (iter->first == flutter::EncodableValue("fcsOption")) {
        auto paramsFcs = std::get<flutter::EncodableMap>(iter->second);
        fcsOption = getFCSOption(&paramsFcs);
        option.fcsOption = fcsOption;
        std::cout << "fcsOption: " << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("privateServerOption")) {
        auto paramsPrivate = std::get<flutter::EncodableMap>(iter->second);
        privateServerOption = getPrivateServerOption(&paramsPrivate);
        option.privateServerOption = privateServerOption;
        std::cout << "privateServerOption: " << std::endl;
      }
    }
    NimCore::getInstance()->setAppkey(appkey);
    auto error = v2::V2NIMClient::get().init(option);
    if (error) {
      // handle error
      std::string msg = "IM init failed";
      result->Error("", "",
                    NimResult::getErrorResult(error->code, error->desc));
    } else {
      NimCore::getInstance()->regService();
      result->Success(NimResult::getSuccessResult());
    }
  }
}
