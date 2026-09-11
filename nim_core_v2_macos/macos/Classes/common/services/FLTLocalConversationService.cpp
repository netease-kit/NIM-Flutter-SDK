
// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTLocalConversationService.h"

#include <sstream>

#include "../FLTService.h"
#include "FLTMessageService.h"
#include "v2_nim_api.hpp"
#include "v2_nim_def_callback.hpp"
#include "v2_nim_def_enum.hpp"
#include "v2_nim_def_struct.hpp"

FLTLocalConversationService::FLTLocalConversationService() {
  m_serviceName = "V2NIMLocalConversationService";

  conversationListener.onSyncStarted = [this]() {
    flutter::EncodableMap arguments;
    notifyEvent("onSyncStarted", arguments);
  };

  conversationListener.onSyncFailed = [this](v2::V2NIMError error) {
    flutter::EncodableMap arguments;
    flutter::EncodableMap errorMap;
    errorMap.insert(std::make_pair("code", static_cast<int64_t>(error.code)));
    errorMap.insert(std::make_pair("desc", error.desc));
    arguments.insert(std::make_pair("error", errorMap));
    notifyEvent("onSyncFailed", arguments);
  };

  conversationListener.onSyncFinished = [this]() {
    flutter::EncodableMap arguments;
    notifyEvent("onSyncFinished", arguments);
  };

  conversationListener.onConversationCreated =
      [this](v2::V2NIMLocalConversation conversation) {
        flutter::EncodableMap arguments =
            convertNIMLocalConversation2Map(&conversation);
        notifyEvent("onConversationCreated", arguments);
      };
  conversationListener.onConversationChanged =
      [this](nstd::vector<v2::V2NIMLocalConversation> conversationList) {
        flutter::EncodableMap arguments;
        flutter::EncodableList conversationListData_;
        for (auto conversation : conversationList) {
          flutter::EncodableMap conversationMap =
              convertNIMLocalConversation2Map(&conversation);
          conversationListData_.emplace_back(conversationMap);
        }

        arguments.insert(
            std::make_pair("conversationList",
                           flutter::EncodableValue(conversationListData_)));

        notifyEvent("onConversationChanged", arguments);
      };

  conversationListener.onConversationDeleted =
      [this](nstd::vector<nstd::string> idList) {
        flutter::EncodableMap arguments;
        flutter::EncodableList conversationIdList;
        for (auto conversationId : idList) {
          conversationIdList.emplace_back(conversationId);
        }
        arguments.insert(
            std::make_pair("conversationIdList", conversationIdList));
        notifyEvent("onConversationDeleted", arguments);
      };
  conversationListener.onTotalUnreadCountChanged =
      [this](uint32_t unreadCount) {
        flutter::EncodableMap arguments;
        arguments.insert(
            std::make_pair("unreadCount", static_cast<int64_t>(unreadCount)));
        notifyEvent("onTotalUnreadCountChanged", arguments);
      };

  conversationListener.onUnreadCountChangedByFilter =
      [this](v2::V2NIMLocalConversationFilter filter, uint32_t unreadCount) {
        flutter::EncodableMap arguments;
        flutter::EncodableMap fiterMap =
            convertNIMLocalConversationFilter2Map(filter);
        arguments.insert(
            std::make_pair("unreadCount", static_cast<int64_t>(unreadCount)));
        arguments.insert(std::make_pair("conversationFilter", fiterMap));
        notifyEvent("onUnreadCountChangedByFilter", arguments);
      };

  conversationListener.onConversationReadTimeUpdated =
      [this](const nstd::string& conversationId, uint64_t readTime) {
        flutter::EncodableMap arguments;
        arguments.insert(
            std::make_pair("readTime", static_cast<int64_t>(readTime)));
        arguments.insert(std::make_pair("conversationId", conversationId));
        notifyEvent("onConversationReadTimeUpdated", arguments);
      };

  auto& client = v2::V2NIMClient::get();
  client.getLocalConversationService().addConversationListener(
      conversationListener);
}

FLTLocalConversationService::~FLTLocalConversationService() {
  v2::V2NIMClient::get()
      .getLocalConversationService()
      .removeConversationListener(conversationListener);
}

void FLTLocalConversationService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method == "getConversationList") {
    getConversationList(arguments, result);
  } else if (method == "getConversationListByOption") {
    getConversationListByOption(arguments, result);
  } else if (method == "getConversation") {
    getConversation(arguments, result);
  } else if (method == "getConversationListByIds") {
    getConversationListByIds(arguments, result);
  } else if (method == "createConversation") {
    createConversation(arguments, result);
  } else if (method == "deleteConversation") {
    deleteConversation(arguments, result);
  } else if (method == "deleteConversationListByIds") {
    deleteConversationListByIds(arguments, result);
  } else if (method == "stickTopConversation") {
    stickTopConversation(arguments, result);
  } else if (method == "updateConversationLocalExtension") {
    updateConversationLocalExtension(arguments, result);
  } else if (method == "getTotalUnreadCount") {
    getTotalUnreadCount(arguments, result);
  } else if (method == "getUnreadCountByIds") {
    getUnreadCountByIds(arguments, result);
  } else if (method == "getUnreadCountByFilter") {
    getUnreadCountByFilter(arguments, result);
  } else if (method == "clearTotalUnreadCount") {
    clearTotalUnreadCount(arguments, result);
  } else if (method == "clearUnreadCountByIds") {
    clearUnreadCountByIds(arguments, result);
  } else if (method == "clearUnreadCountByTypes") {
    clearUnreadCountByTypes(arguments, result);
  } else if (method == "subscribeUnreadCountByFilter") {
    subscribeUnreadCountByFilter(arguments, result);
  } else if (method == "unsubscribeUnreadCountByFilter") {
    unsubscribeUnreadCountByFilter(arguments, result);
  } else if (method == "getConversationReadTime") {
    getConversationReadTime(arguments, result);
  } else if (method == "markConversationRead") {
    markConversationRead(arguments, result);
  } else if (method == "getStickTopConversationList") {
    getStickTopConversationList(arguments, result);
  } else if (method == "setCurrentConversation") {
    setCurrentConversation(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTLocalConversationService::getConversationList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  uint64_t offset = 0;
  uint32_t limit = 100;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;
    if (iter->first == flutter::EncodableValue("offset")) {
      offset = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("limit")) {
      limit = std::get<int32_t>(iter->second);
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.getConversationList(
      offset, limit,
      [result](const v2::V2NIMLocalConversationResult conversationResult) {
        flutter::EncodableMap resultMapData;
        resultMapData.insert(std::make_pair(
            "offset", static_cast<int64_t>(conversationResult.offset)));
        resultMapData.insert(
            std::make_pair("finished", conversationResult.finished));

        flutter::EncodableList conversationListData_;
        for (auto conversation : conversationResult.conversationList) {
          flutter::EncodableMap conversationMap =
              convertNIMLocalConversation2Map(&conversation);
          conversationListData_.emplace_back(conversationMap);
        }

        resultMapData.insert(
            std::make_pair("conversationList",
                           flutter::EncodableValue(conversationListData_)));
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code,
                                                "getConversationList failed"));
      });
}

void FLTLocalConversationService::getConversationListByOption(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  uint64_t offset = 0;
  uint32_t limit = 100;
  flutter::EncodableMap optionMapData;
  v2::V2NIMLocalConversationOption conversationOption;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) continue;
    if (iter->first == flutter::EncodableValue("offset")) {
      offset = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("limit")) {
      limit = std::get<int32_t>(iter->second);
    } else if (iter->first == flutter::EncodableValue("option")) {
      optionMapData = std::get<flutter::EncodableMap>(iter->second);
    }
  }

  for (auto optionIter : optionMapData) {
    if (optionIter.second.IsNull()) continue;
    if (optionIter.first == flutter::EncodableValue("onlyUnread")) {
      conversationOption.onlyUnread = std::get<bool>(optionIter.second);
    } else if (optionIter.first ==
               flutter::EncodableValue("conversationTypes")) {
      nstd::vector<v2::V2NIMConversationType> typeIds;
      auto typesParam = std::get<flutter::EncodableList>(optionIter.second);
      for (auto& typeId : typesParam) {
        uint32_t typeValue = std::get<int32_t>(typeId);
        typeIds.push_back(static_cast<v2::V2NIMConversationType>(typeValue));
      }
      conversationOption.conversationTypes = typeIds;
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.getConversationListByOption(
      offset, limit, conversationOption,
      [result](const v2::V2NIMLocalConversationResult conversationResult) {
        flutter::EncodableMap resultMapData;
        resultMapData.insert(std::make_pair(
            "offset", static_cast<int64_t>(conversationResult.offset)));
        resultMapData.insert(
            std::make_pair("finished", conversationResult.finished));

        flutter::EncodableList conversationListData_;
        for (auto conversation : conversationResult.conversationList) {
          flutter::EncodableMap conversationMap =
              convertNIMLocalConversation2Map(&conversation);
          conversationListData_.emplace_back(conversationMap);
        }

        resultMapData.insert(
            std::make_pair("conversationList",
                           flutter::EncodableValue(conversationListData_)));
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// @brief 获取会话
/// @return void
void FLTLocalConversationService::getConversation(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string conversationId;
  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.getConversation(
      conversationId,
      [result](const v2::V2NIMLocalConversation conversation) {
        flutter::EncodableMap resultMapData =
            convertNIMLocalConversation2Map(&conversation);
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::getConversationListByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nstd::vector<nstd::string> conversationIds;
  auto iter = arguments->find(flutter::EncodableValue("conversationIdList"));
  if (iter != arguments->end()) {
    auto conversationIdsParam = std::get<flutter::EncodableList>(iter->second);
    for (auto conversationId : conversationIdsParam) {
      conversationIds.push_back(std::get<std::string>(conversationId));
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.getConversationListByIds(
      conversationIds,
      [result](
          const nstd::vector<v2::V2NIMLocalConversation> conversationList) {
        flutter::EncodableMap resultMapData;
        flutter::EncodableList conversationListData_;
        for (auto conversation : conversationList) {
          flutter::EncodableMap conversationMap =
              convertNIMLocalConversation2Map(&conversation);
          conversationListData_.emplace_back(conversationMap);
        }

        resultMapData.insert(
            std::make_pair("conversationList",
                           flutter::EncodableValue(conversationListData_)));
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::createConversation(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string conversationId;
  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.createConversation(
      conversationId,
      [result](const v2::V2NIMLocalConversation conversation) {
        flutter::EncodableMap resultMapData =
            convertNIMLocalConversation2Map(&conversation);
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::deleteConversation(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string conversationId;
  bool clearMsg;
  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("clearMessage"));
  if (iter2 != arguments->end()) {
    clearMsg = std::get<bool>(iter2->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.deleteConversation(
      conversationId, clearMsg,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::deleteConversationListByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nstd::vector<nstd::string> conversationIds;
  bool clearMsg;
  auto iter2 = arguments->find(flutter::EncodableValue("clearMessage"));
  if (iter2 != arguments->end()) {
    clearMsg = std::get<bool>(iter2->second);
  }
  auto iter = arguments->find(flutter::EncodableValue("conversationIdList"));
  if (iter != arguments->end()) {
    auto conversationIdsParam = std::get<flutter::EncodableList>(iter->second);
    for (auto conversationId : conversationIdsParam) {
      conversationIds.push_back(std::get<std::string>(conversationId));
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.deleteConversationListByIds(
      conversationIds, clearMsg,
      [=](const nstd::vector<v2::V2NIMConversationOperationResult>
              conversationResultList) {
        flutter::EncodableMap resultMapData;
        flutter::EncodableList conversationListData_;
        for (auto conversation : conversationResultList) {
          flutter::EncodableMap conversationMap;
          conversationMap.insert(std::make_pair(
              "conversationId",
              flutter::EncodableValue(conversation.conversationId)));

          flutter::EncodableMap errorMap;
          errorMap.insert(std::make_pair(
              "code", static_cast<int64_t>(conversation.error.code)));
          errorMap.insert(std::make_pair("desc", conversation.error.desc));
          conversationMap.insert(std::make_pair("error", errorMap));
          conversationListData_.emplace_back(conversationMap);
        }

        resultMapData.insert(
            std::make_pair("conversationOperationResult",
                           flutter::EncodableValue(conversationListData_)));
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [=](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::stickTopConversation(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string conversationId;
  bool stickTop;
  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("stickTop"));
  if (iter2 != arguments->end()) {
    stickTop = std::get<bool>(iter2->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.stickTopConversation(
      conversationId, stickTop,
      [=]() { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::updateConversationLocalExtension(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string conversationId;
  std::string localExtension;
  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }
  auto iter2 = arguments->find(flutter::EncodableValue("localExtension"));
  if (iter2 != arguments->end()) {
    localExtension = std::get<std::string>(iter2->second);
  }
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.updateConversationLocalExtension(
      conversationId, localExtension,
      [=]() { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::getTotalUnreadCount(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  int count = conversationService.getTotalUnreadCount();
  result->Success(NimResult::getSuccessResult(count));
}

void FLTLocalConversationService::getUnreadCountByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nstd::vector<nstd::string> conversationIds;
  auto iter = arguments->find(flutter::EncodableValue("conversationIdList"));
  if (iter != arguments->end()) {
    auto conversationIdsParam = std::get<flutter::EncodableList>(iter->second);
    for (auto& conversationId : conversationIdsParam) {
      conversationIds.push_back(std::get<std::string>(conversationId));
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.getUnreadCountByIds(
      conversationIds,
      [=](const int unreadCount) {
        result->Success(NimResult::getSuccessResult(unreadCount));
      },
      [=](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::getUnreadCountByFilter(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto filterIter = arguments->find(flutter::EncodableValue("filter"));
  v2::V2NIMLocalConversationFilter filter;
  filter = createLocalConversationFilterFromMap(arguments);

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.getUnreadCountByFilter(
      filter,
      [=](const int unreadCount) {
        result->Success(
            NimResult::getSuccessResult(static_cast<int64_t>(unreadCount)));
      },
      [=](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::clearTotalUnreadCount(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.clearTotalUnreadCount(
      [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::clearUnreadCountByIds(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nstd::vector<nstd::string> conversationIds;
  auto iter = arguments->find(flutter::EncodableValue("conversationIdList"));
  if (iter != arguments->end()) {
    auto conversationIdsParam = std::get<flutter::EncodableList>(iter->second);
    for (auto& conversationId : conversationIdsParam) {
      conversationIds.push_back(std::get<std::string>(conversationId));
    }
  }
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.clearUnreadCountByIds(
      conversationIds,
      [=](const nstd::vector<v2::V2NIMConversationOperationResult>
              conversationResultList) {
        flutter::EncodableMap resultMapData;
        flutter::EncodableList conversationListData_;
        for (auto conversation : conversationResultList) {
          flutter::EncodableMap conversationMap;
          conversationMap.insert(std::make_pair(
              "conversationId",
              flutter::EncodableValue(conversation.conversationId)));

          flutter::EncodableMap errorMap;
          errorMap.insert(std::make_pair(
              "code", static_cast<int64_t>(conversation.error.code)));
          errorMap.insert(std::make_pair("desc", conversation.error.desc));
          conversationMap.insert(std::make_pair("error", errorMap));
          conversationListData_.emplace_back(conversationMap);
        }

        resultMapData.insert(
            std::make_pair("conversationOperationResult",
                           flutter::EncodableValue(conversationListData_)));
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [=](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::clearUnreadCountByTypes(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  nstd::vector<v2::V2NIMConversationType> typeIds;

  auto optionIter =
      arguments->find(flutter::EncodableValue("conversationTypeList"));
  if (optionIter != arguments->end()) {
    auto typesParam = std::get<flutter::EncodableList>(optionIter->second);
    for (auto& typeId : typesParam) {
      uint32_t typeValue = std::get<int32_t>(typeId);
      typeIds.push_back(static_cast<v2::V2NIMConversationType>(typeValue));
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.clearUnreadCountByTypes(
      typeIds, [=] { result->Success(NimResult::getSuccessResult()); },
      [=](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::subscribeUnreadCountByFilter(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto filterIter = arguments->find(flutter::EncodableValue("filter"));
  v2::V2NIMLocalConversationFilter filter;
  if (filterIter != arguments->end()) {
    flutter::EncodableMap filterParam =
        std::get<flutter::EncodableMap>(filterIter->second);
    filter = createLocalConversationFilterFromMap(&filterParam);
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  auto error = conversationService.subscribeUnreadCountByFilter(filter);

  if (error.has_value()) {
    result->Error("", error->desc,
                  NimResult::getErrorResult(error->code, error->desc));
  } else {
    result->Success(NimResult::getSuccessResult());
  }
}

void FLTLocalConversationService::unsubscribeUnreadCountByFilter(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto filterIter = arguments->find(flutter::EncodableValue("filter"));
  v2::V2NIMLocalConversationFilter filter;
  if (filterIter != arguments->end()) {
    flutter::EncodableMap filterParam =
        std::get<flutter::EncodableMap>(filterIter->second);
    filter = createLocalConversationFilterFromMap(&filterParam);
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  auto error = conversationService.unsubscribeUnreadCountByFilter(filter);
  if (error.has_value()) {
    result->Error("", error->desc,
                  NimResult::getErrorResult(error->code, error->desc));
  } else {
    result->Success(NimResult::getSuccessResult());
  }
}

void FLTLocalConversationService::getConversationReadTime(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string conversationId;
  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.getConversationReadTime(
      conversationId,
      [=](const time_t readTime) {
        std::int64_t readTimeInt = readTime;
        result->Success(NimResult::getSuccessResult(readTimeInt));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::markConversationRead(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  std::string conversationId;
  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end()) {
    conversationId = std::get<std::string>(iter->second);
  }

  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.markConversationRead(
      conversationId,
      [=](const time_t readTime) {
        std::int64_t readTimeInt = readTime;
        result->Success(NimResult::getSuccessResult(readTimeInt));
      },
      [=](v2::V2NIMError error) {
        result->Error("", "",
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

void FLTLocalConversationService::getStickTopConversationList(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();
  conversationService.getStickTopConversationList(
      [result](
          const nstd::vector<v2::V2NIMLocalConversation> conversationList) {
        flutter::EncodableMap resultMapData;
        flutter::EncodableList conversationListData_;
        for (auto conversation : conversationList) {
          flutter::EncodableMap conversationMap =
              convertNIMLocalConversation2Map(&conversation);
          conversationListData_.emplace_back(conversationMap);
        }

        resultMapData.insert(
            std::make_pair("conversationList",
                           flutter::EncodableValue(conversationListData_)));
        result->Success(NimResult::getSuccessResult(resultMapData));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(
                          error.code, "getStickTopConversationList failed"));
      });
}

/// @return void
void FLTLocalConversationService::setCurrentConversation(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  // 解析conversationId参数（可能为null，因为接口定义是optional）
  nstd::optional<std::string> conversationId;

  auto iter = arguments->find(flutter::EncodableValue("conversationId"));
  if (iter != arguments->end() && !iter->second.IsNull()) {
    conversationId = std::get<std::string>(iter->second);
  }

  // 获取服务实例并调用接口
  auto& client = v2::V2NIMClient::get();
  auto& conversationService = client.getLocalConversationService();

  auto error = conversationService.setCurrentConversation(conversationId);

  // 处理返回结果
  if (error.has_value()) {
    // 有错误时返回错误信息
    result->Error("", error->desc,
                  NimResult::getErrorResult(error->code, error->desc));
  } else {
    // 无错误时返回成功标识
    result->Success(NimResult::getSuccessResult());
  }
}

flutter::EncodableMap convertNIMLocalConversation2Map(
    const nstd::optional<v2::V2NIMLocalConversation> conversation) {
  flutter::EncodableMap resultMap;
  resultMap.insert(
      std::make_pair("conversationId", conversation->conversationId));
  resultMap.insert(
      std::make_pair("type", static_cast<int>(conversation->type)));
  if (conversation->name.has_value()) {
    resultMap.insert(std::make_pair("name", conversation->name.value()));
  }
  if (conversation->avatar.has_value()) {
    resultMap.insert(std::make_pair("avatar", conversation->avatar.value()));
  }
  resultMap.insert(std::make_pair("mute", conversation->mute));
  resultMap.insert(std::make_pair("stickTop", conversation->stickTop));
  if (conversation->localExtension.has_value()) {
    resultMap.insert(
        std::make_pair("localExtension", conversation->localExtension.value()));
  }
  if (conversation->lastMessage.has_value()) {
    flutter::EncodableMap lastMsgMap =
        convertNIMLocalLastMessage2Map(conversation->lastMessage.value());
    resultMap.insert(std::make_pair("lastMessage", lastMsgMap));
  }
  resultMap.insert(std::make_pair(
      "unreadCount", static_cast<int32_t>(conversation->unreadCount)));
  resultMap.insert(std::make_pair(
      "sortOrder", static_cast<int64_t>(conversation->sortOrder)));
  resultMap.insert(std::make_pair(
      "createTime", static_cast<int64_t>(conversation->createTime)));
  resultMap.insert(std::make_pair(
      "updateTime", static_cast<int64_t>(conversation->updateTime)));
  return resultMap;
};

flutter::EncodableMap convertNIMLocalLastMessage2Map(
    const nstd::optional<v2::V2NIMLastMessage> lastMessage) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair(
      "lastMessageState", static_cast<int64_t>(lastMessage->lastMessageState)));
  flutter::EncodableMap msgRefer =
      convertMessageRefer(lastMessage->messageRefer);
  resultMap.insert(std::make_pair("messageRefer", msgRefer));
  if (lastMessage->messageType.has_value()) {
    resultMap.insert(std::make_pair(
        "messageType", static_cast<int64_t>(lastMessage->messageType.value())));
  }
  if (lastMessage->subType.has_value()) {
    resultMap.insert(std::make_pair(
        "subType", static_cast<int64_t>(lastMessage->subType.value())));
  }
  if (lastMessage->sendingState.has_value()) {
    resultMap.insert(std::make_pair(
        "sendingState",
        static_cast<int64_t>(lastMessage->sendingState.value())));
  }
  resultMap.insert(std::make_pair("text", lastMessage->text));

  flutter::EncodableMap msgAttachment =
      convertMessageAttachment(lastMessage->attachment);
  resultMap.insert(std::make_pair("attachment", msgAttachment));

  resultMap.insert(
      std::make_pair("revokeAccountId", lastMessage->revokeAccountId.value()));
  if (lastMessage->revokeType.has_value()) {
    resultMap.insert(std::make_pair(
        "revokeType", static_cast<int64_t>(lastMessage->revokeType.value())));
  }
  resultMap.insert(
      std::make_pair("serverExtension", lastMessage->serverExtension.value()));
  resultMap.insert(std::make_pair("callbackExtension",
                                  lastMessage->callbackExtension.value()));
  resultMap.insert(
      std::make_pair("senderName", lastMessage->senderName.value()));

  return resultMap;
};

flutter::EncodableMap convertNIMLocalConversationFilter2Map(
    const nstd::optional<v2::V2NIMLocalConversationFilter> filter) {
  flutter::EncodableMap resultMap;
  flutter::EncodableList typeList;
  resultMap.insert(std::make_pair("ignoreMuted", filter->ignoreMuted));
  for (auto type : filter->conversationTypes) {
    typeList.emplace_back(static_cast<int64_t>(type));
  }
  resultMap.insert(std::make_pair("conversationTypes", typeList));
  return resultMap;
};

v2::V2NIMLocalConversationFilter createLocalConversationFilterFromMap(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMLocalConversationFilter filter;

  nstd::vector<v2::V2NIMConversationType> conversationTypes;
  auto iter2 = arguments->find(flutter::EncodableValue("conversationTypes"));
  if (iter2 != arguments->end() && !iter2->second.IsNull()) {
    auto conversationIdsParam = std::get<flutter::EncodableList>(iter2->second);
    if (!conversationIdsParam.empty()) {
      for (auto& conversationType : conversationIdsParam) {
        int64_t typeValue = conversationType.LongValue();
        conversationTypes.push_back(
            static_cast<v2::V2NIMConversationType>(typeValue));
      }
      filter.conversationTypes = conversationTypes;
    }
  }

  auto iter3 = arguments->find(flutter::EncodableValue("ignoreMuted"));
  if (iter3 != arguments->end() && !iter3->second.IsNull()) {
    filter.ignoreMuted = std::get<bool>(iter3->second);
  }
  return filter;
};
