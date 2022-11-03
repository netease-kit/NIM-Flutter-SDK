// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTInitializeService.h"

#if defined(_WIN32)
#include <windows.h>
#endif

#include "../NimResult.h"
#include "nim_cpp_wrapper/api/nim_cpp_client.h"

using namespace nim;

FLTInitializeService::FLTInitializeService() {
  m_serviceName = "InitializeService";
}

void FLTInitializeService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "initialize") {
    if (!m_appKey.empty()) {
      YXLOG(Info) << "initialize has been called." << YXLOGEnd;
      if (result) {
        std::string appKey;
        auto appKeyIt = arguments->find(flutter::EncodableValue("appKey"));
        if (appKeyIt != arguments->end() && !appKeyIt->second.IsNull()) {
          appKey = std::get<std::string>(appKeyIt->second);
        }

        if (m_appKey == appKey) {
          result->Success(NimResult::getSuccessResult());
        } else {
          result->Error(
              "", "",
              NimResult::getErrorResult(-2, "initialize has been called."));
        }
      }
      return;
    }
    // #if defined(_WIN32) && defined(_DEBUG)
    //         MessageBoxA(NULL, "Debug....", "Debug", 0);
    // #endif
    initializeSDK(arguments, result);
  } else if (method == "releaseDesktop") {
    if (!m_init) {
      result->Error("", "", NimResult::getErrorResult(-1, "IM release failed"));
      return;
    }
    nim::Client::Cleanup2();
    m_init = false;
    result->Success(NimResult::getSuccessResult());
  } else {
    result->NotImplemented();
  }
}

void FLTInitializeService::initializeSDK(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (arguments) {
    std::string appkey = "";
    std::string sdkRootDir = "";
    int customClientType = 0;
    bool shouldSyncStickTopSessionInfos = false;
    bool enableDatabaseBackup = false;
    bool shouldSyncUnreadCount = false;
    bool shouldConsiderRevokedMessageUnreadCount = false;
    bool enableTeamMessageReadReceipt = false;
    bool shouldTeamNotificationMessageMarkUnread = false;
    bool enableAnimatedImageThumbnail = false;
    bool enablePreloadMessageAttachment = false;

    std::string databaseEncryptKey = "";
    std::string preloadImageResize = "";
    std::string preloadImageNameTemplate = "";
    bool enableClientAntispam = false;
    bool enabledHttps = false;
    bool shouldVchatMissMessageMarkUnread = false;
    bool needUpdateLbsBeforeRelogin = false;
    int preloadImageQuality = 0;
    int maxAutoLoginRetryTimes = 0;

    SDKConfig sdkConfig;
    sdkConfig.sdk_type = nim::kNIMSDKTypeFlutter;

    auto iter = arguments->begin();
    for (iter; iter != arguments->end(); ++iter) {
      if (iter->second.IsNull()) {
        continue;
      }

      if (iter->first == flutter::EncodableValue("appKey")) {
        appkey = std::get<std::string>(iter->second);
        std::cout << "appkey: " << appkey << std::endl;
      } else if (iter->first == flutter::EncodableValue("sdkRootDir")) {
        sdkRootDir = std::get<std::string>(iter->second);
        std::cout << "sdkRootDir: " << sdkRootDir << std::endl;
      } else if (iter->first == flutter::EncodableValue("customClientType")) {
        customClientType = std::get<int>(iter->second);
        sdkConfig.SetCustomClientType(customClientType);
        std::cout << "customClientType: " << customClientType << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("shouldSyncStickTopSessionInfos")) {
        shouldSyncStickTopSessionInfos = std::get<bool>(iter->second);
        int value = shouldSyncStickTopSessionInfos ? 1 : 0;
        sdkConfig.sync_data_type_list_.insert(std::make_pair(28, value));
        std::cout << "shouldSyncStickTopSessionInfos: "
                  << shouldSyncStickTopSessionInfos << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("enableDatabaseBackup")) {
        enableDatabaseBackup = std::get<bool>(iter->second);
        sdkConfig.enable_user_datafile_backup_ = enableDatabaseBackup;
        std::cout << "enableDatabaseBackup: " << enableDatabaseBackup
                  << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("shouldSyncUnreadCount")) {
        std::cout << "shouldSyncUnreadCount" << std::endl;
        shouldSyncUnreadCount = std::get<bool>(iter->second);
        sdkConfig.sync_session_ack_ = shouldSyncUnreadCount;
        std::cout << "shouldSyncUnreadCount: " << shouldSyncUnreadCount
                  << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue(
                     "shouldConsiderRevokedMessageUnreadCount")) {
        shouldConsiderRevokedMessageUnreadCount = std::get<bool>(iter->second);
        sdkConfig.reset_unread_count_when_recall_ =
            shouldConsiderRevokedMessageUnreadCount;
        std::cout << "shouldConsiderRevokedMessageUnreadCount: "
                  << shouldConsiderRevokedMessageUnreadCount << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("enableTeamMessageReadReceipt")) {
        enableTeamMessageReadReceipt = std::get<bool>(iter->second);
        sdkConfig.team_msg_ack_ = enableTeamMessageReadReceipt;
        std::cout << "enableTeamMessageReadReceipt: "
                  << enableTeamMessageReadReceipt << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("enableAnimatedImageThumbnail")) {
        enableAnimatedImageThumbnail = std::get<bool>(iter->second);
        sdkConfig.animated_image_thumbnail_enabled_ =
            enableAnimatedImageThumbnail;
        std::cout << "enableAnimatedImageThumbnail: "
                  << enableAnimatedImageThumbnail << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("enablePreloadMessageAttachment")) {
        enablePreloadMessageAttachment = std::get<bool>(iter->second);
        sdkConfig.preload_attach_ = enablePreloadMessageAttachment;
        std::cout << "enablePreloadMessageAttachment: "
                  << enablePreloadMessageAttachment << std::endl;
      } else if (iter->first == flutter::EncodableValue("databaseEncryptKey")) {
        databaseEncryptKey = std::get<std::string>(iter->second);
        sdkConfig.database_encrypt_key_ = databaseEncryptKey;
        std::cout << "databaseEncryptKey: " << databaseEncryptKey << std::endl;
      } else if (iter->first == flutter::EncodableValue("preloadImageResize")) {
        preloadImageResize = std::get<std::string>(iter->second);
        sdkConfig.preload_image_resize_ = preloadImageResize;
        std::cout << "preloadImageResize: " << preloadImageResize << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("preloadImageNameTemplate")) {
        preloadImageNameTemplate = std::get<std::string>(iter->second);
        sdkConfig.preload_image_name_template_ = preloadImageNameTemplate;
        std::cout << "preloadImageNameTemplate: " << preloadImageNameTemplate
                  << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("enableClientAntispam")) {
        enableClientAntispam = std::get<bool>(iter->second);
        sdkConfig.client_antispam_ = enableClientAntispam;
        std::cout << "enableClientAntispam: " << enableClientAntispam
                  << std::endl;
      } else if (iter->first == flutter::EncodableValue("enabledHttps")) {
        enabledHttps = std::get<bool>(iter->second);
        sdkConfig.use_https_ = enabledHttps;
        std::cout << "enabledHttps: " << enabledHttps << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("shouldVchatMissMessageMarkUnread")) {
        shouldVchatMissMessageMarkUnread = std::get<bool>(iter->second);
        sdkConfig.vchat_miss_unread_count_ = shouldVchatMissMessageMarkUnread;
        std::cout << "shouldVchatMissMessageMarkUnread: "
                  << shouldVchatMissMessageMarkUnread << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("needUpdateLbsBeforeRelogin")) {
        needUpdateLbsBeforeRelogin = std::get<bool>(iter->second);
        sdkConfig.need_update_lbs_befor_relogin_ = needUpdateLbsBeforeRelogin;
        std::cout << "needUpdateLbsBeforeRelogin: "
                  << needUpdateLbsBeforeRelogin << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("preloadImageQuality")) {
        preloadImageQuality = std::get<int>(iter->second);
        sdkConfig.preload_image_quality_ = preloadImageQuality;
        std::cout << "preloadImageQuality: " << preloadImageQuality
                  << std::endl;
      } else if (iter->first ==
                 flutter::EncodableValue("maxAutoLoginRetryTimes")) {
        maxAutoLoginRetryTimes = std::get<int>(iter->second);
        sdkConfig.login_max_retry_times_ = maxAutoLoginRetryTimes;
        std::cout << "maxAutoLoginRetryTimes: " << maxAutoLoginRetryTimes
                  << std::endl;
      } else if (iter->first == flutter::EncodableValue("enableAppNap")) {
        sdkConfig.disable_app_nap_ = !std::get<bool>(iter->second);
      } else if (iter->first == flutter::EncodableValue("pushCertName")) {
        sdkConfig.push_cer_name_ = std::get<std::string>(iter->second);
      } else if (iter->first == flutter::EncodableValue("pushToken")) {
        sdkConfig.push_token_ = std::get<std::string>(iter->second);
      } else if (iter->first == flutter::EncodableValue("extras")) {
        auto extras = std::get<flutter::EncodableMap>(iter->second);
        auto it = extras.find(flutter::EncodableValue("versionName"));
        if (it != extras.end() && !it->second.IsNull()) {
          sdkConfig.sdk_human_version = std::get<std::string>(it->second);
        }

        it = extras.find(flutter::EncodableValue("versionCode"));
        if (it != extras.end() && !it->second.IsNull()) {
        }
      } else if (iter->first ==
                 flutter::EncodableValue("useAssetServerConfig")) {
        sdkConfig.use_private_server_ = std::get<bool>(iter->second);
      }
    }
    NimCore::getInstance()->setAppkey(appkey);
    if (nim::Client::Init(appkey, NimCore::getInstance()->getLogDir(), "",
                          sdkConfig)) {
      m_appKey = appkey;
      m_init = true;
      NimCore::getInstance()->regService();
      result->Success(NimResult::getSuccessResult());
    } else {
      std::string msg = "IM init failed";
      result->Error("", "", NimResult::getErrorResult(-1, msg));
    }
  }
}