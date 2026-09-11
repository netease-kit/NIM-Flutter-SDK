// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTConversationGroupService.h"

#include "FLTConversationService.h"
#include "v2_nim_def_struct.hpp"

namespace {

constexpr int kInvalidParameterCode = 199414;
constexpr int kServiceDisabledCode = 199003;
constexpr char kServiceDisabledMessage[] =
    "Conversation group service is disabled. Enable cloud conversation first.";

using MethodResult =
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>>;

flutter::EncodableMap convertErrorToMap(const v2::V2NIMError& error) {
  flutter::EncodableMap detail;
  for (const auto& item : error.detail) {
    detail.insert(std::make_pair(item.first, item.second));
  }

  flutter::EncodableMap result;
  result.insert(std::make_pair("code", static_cast<int64_t>(error.code)));
  result.insert(std::make_pair("desc", error.desc));
  result.insert(std::make_pair("detail", detail));
  return result;
}

flutter::EncodableMap convertConversationOperationResultToMap(
    const v2::V2NIMConversationOperationResult& operationResult) {
  flutter::EncodableMap result;
  result.insert(
      std::make_pair("conversationId", operationResult.conversationId));
  result.insert(
      std::make_pair("error", convertErrorToMap(operationResult.error)));
  return result;
}

flutter::EncodableList convertConversationOperationResultsToList(
    const nstd::vector<v2::V2NIMConversationOperationResult>& results) {
  flutter::EncodableList resultList;
  for (const auto& result : results) {
    resultList.emplace_back(convertConversationOperationResultToMap(result));
  }
  return resultList;
}

flutter::EncodableMap convertConversationGroupToMap(
    const v2::V2NIMConversationGroup& group) {
  flutter::EncodableMap result;
  result.insert(std::make_pair("groupId", group.groupId));
  result.insert(std::make_pair("name", group.name));
  if (group.serverExtension.has_value()) {
    result.insert(
        std::make_pair("serverExtension", group.serverExtension.value()));
  } else {
    result.insert(std::make_pair("serverExtension", flutter::EncodableValue()));
  }
  result.insert(
      std::make_pair("createTime", static_cast<int64_t>(group.createTime)));
  result.insert(
      std::make_pair("updateTime", static_cast<int64_t>(group.updateTime)));
  return result;
}

flutter::EncodableList convertConversationGroupsToList(
    const nstd::vector<v2::V2NIMConversationGroup>& groups) {
  flutter::EncodableList resultList;
  for (const auto& group : groups) {
    resultList.emplace_back(convertConversationGroupToMap(group));
  }
  return resultList;
}

flutter::EncodableMap convertConversationGroupResultToMap(
    const v2::V2NIMConversationGroupResult& groupResult) {
  flutter::EncodableMap result;
  result.insert(std::make_pair(
      "group", convertConversationGroupToMap(groupResult.group)));
  result.insert(std::make_pair(
      "failedList",
      convertConversationOperationResultsToList(groupResult.failedList)));
  return result;
}

bool getStringArgument(const flutter::EncodableMap* arguments,
                       const std::string& key, std::string& value) {
  if (arguments == nullptr) {
    return false;
  }
  const auto iter = arguments->find(flutter::EncodableValue(key));
  if (iter == arguments->end() || iter->second.IsNull()) {
    return false;
  }
  const auto stringValue = std::get_if<std::string>(&iter->second);
  if (stringValue == nullptr) {
    return false;
  }
  value = *stringValue;
  return true;
}

nstd::optional<nstd::string> getOptionalStringArgument(
    const flutter::EncodableMap* arguments, const std::string& key) {
  std::string value;
  if (getStringArgument(arguments, key, value)) {
    return nstd::optional<nstd::string>(nstd::string(value));
  }
  return nstd::nullopt;
}

bool getStringListArgument(const flutter::EncodableMap* arguments,
                           const std::string& key,
                           nstd::vector<nstd::string>& values) {
  if (arguments == nullptr) {
    return false;
  }
  const auto iter = arguments->find(flutter::EncodableValue(key));
  if (iter == arguments->end() || iter->second.IsNull()) {
    return false;
  }
  const auto list = std::get_if<flutter::EncodableList>(&iter->second);
  if (list == nullptr) {
    return false;
  }
  for (const auto& item : *list) {
    const auto stringValue = std::get_if<std::string>(&item);
    if (stringValue == nullptr) {
      return false;
    }
    values.push_back(*stringValue);
  }
  return true;
}

void returnParameterError(const std::string& method, MethodResult result) {
  const auto message = method + " params error!";
  result->Error("", message,
                NimResult::getErrorResult(kInvalidParameterCode, message));
}

void returnSdkError(const v2::V2NIMError& error, MethodResult result) {
  result->Error("", error.desc,
                NimResult::getErrorResult(error.code, error.desc));
}

void returnServiceDisabledError(MethodResult result) {
  result->Error(
      "", kServiceDisabledMessage,
      NimResult::getErrorResult(kServiceDisabledCode, kServiceDisabledMessage));
}

}  // namespace

FLTConversationGroupService::FLTConversationGroupService(
    bool enableCloudConversation)
    : m_enableCloudConversation(enableCloudConversation) {
  m_serviceName = "V2NIMConversationGroupService";

  conversationGroupListener.onConversationGroupCreated =
      [this](const v2::V2NIMConversationGroup& group) {
        auto arguments = convertConversationGroupToMap(group);
        notifyEvent("onConversationGroupCreated", arguments);
      };
  conversationGroupListener.onConversationGroupDeleted =
      [this](const nstd::string& groupId) {
        flutter::EncodableMap arguments;
        arguments.insert(std::make_pair("groupId", groupId));
        notifyEvent("onConversationGroupDeleted", arguments);
      };
  conversationGroupListener.onConversationGroupChanged =
      [this](const v2::V2NIMConversationGroup& group) {
        auto arguments = convertConversationGroupToMap(group);
        notifyEvent("onConversationGroupChanged", arguments);
      };
  conversationGroupListener.onConversationsAddedToGroup =
      [this](const nstd::string& groupId,
             const nstd::vector<v2::V2NIMConversation>& conversations) {
        flutter::EncodableList conversationList;
        for (const auto& conversation : conversations) {
          conversationList.emplace_back(
              convertNIMConversation2Map(&conversation));
        }
        flutter::EncodableMap arguments;
        arguments.insert(std::make_pair("groupId", groupId));
        arguments.insert(std::make_pair("conversations", conversationList));
        notifyEvent("onConversationsAddedToGroup", arguments);
      };
  conversationGroupListener.onConversationsRemovedFromGroup =
      [this](const nstd::string& groupId,
             const nstd::vector<nstd::string>& conversationIds) {
        flutter::EncodableList conversationIdList;
        for (const auto& conversationId : conversationIds) {
          conversationIdList.emplace_back(conversationId);
        }
        flutter::EncodableMap arguments;
        arguments.insert(std::make_pair("groupId", groupId));
        arguments.insert(std::make_pair("conversationIds", conversationIdList));
        notifyEvent("onConversationsRemovedFromGroup", arguments);
      };

  if (m_enableCloudConversation) {
    v2::V2NIMClient::get()
        .getConversationGroupService()
        .addConversationGroupListener(conversationGroupListener);
  }
}

FLTConversationGroupService::~FLTConversationGroupService() {
  if (m_enableCloudConversation) {
    v2::V2NIMClient::get()
        .getConversationGroupService()
        .removeConversationGroupListener(conversationGroupListener);
  }
}

void FLTConversationGroupService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    MethodResult result) {
  if (!m_enableCloudConversation) {
    returnServiceDisabledError(result);
    return;
  }

  if (method == "createConversationGroup") {
    createConversationGroup(arguments, result);
  } else if (method == "deleteConversationGroup") {
    deleteConversationGroup(arguments, result);
  } else if (method == "updateConversationGroup") {
    updateConversationGroup(arguments, result);
  } else if (method == "addConversationsToGroup") {
    addConversationsToGroup(arguments, result);
  } else if (method == "removeConversationsFromGroup") {
    removeConversationsFromGroup(arguments, result);
  } else if (method == "getConversationGroup") {
    getConversationGroup(arguments, result);
  } else if (method == "getConversationGroupList") {
    getConversationGroupList(arguments, result);
  } else if (method == "getConversationGroupListByIds") {
    getConversationGroupListByIds(arguments, result);
  } else {
    result->NotImplemented();
  }
}

void FLTConversationGroupService::createConversationGroup(
    const flutter::EncodableMap* arguments, MethodResult result) {
  std::string name;
  nstd::vector<nstd::string> conversationIds;
  if (!getStringArgument(arguments, "name", name) ||
      !getStringListArgument(arguments, "conversationIds", conversationIds)) {
    returnParameterError("createConversationGroup", result);
    return;
  }
  const auto serverExtension =
      getOptionalStringArgument(arguments, "serverExtension");
  v2::V2NIMClient::get().getConversationGroupService().createConversationGroup(
      name, serverExtension, conversationIds,
      [result](const v2::V2NIMConversationGroupResult& groupResult) {
        result->Success(NimResult::getSuccessResult(
            convertConversationGroupResultToMap(groupResult)));
      },
      [result](const v2::V2NIMError& error) { returnSdkError(error, result); });
}

void FLTConversationGroupService::deleteConversationGroup(
    const flutter::EncodableMap* arguments, MethodResult result) {
  std::string groupId;
  if (!getStringArgument(arguments, "groupId", groupId)) {
    returnParameterError("deleteConversationGroup", result);
    return;
  }
  v2::V2NIMClient::get().getConversationGroupService().deleteConversationGroup(
      groupId, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](const v2::V2NIMError& error) { returnSdkError(error, result); });
}

void FLTConversationGroupService::updateConversationGroup(
    const flutter::EncodableMap* arguments, MethodResult result) {
  std::string groupId;
  if (!getStringArgument(arguments, "groupId", groupId)) {
    returnParameterError("updateConversationGroup", result);
    return;
  }
  const auto name = getOptionalStringArgument(arguments, "name");
  const auto serverExtension =
      getOptionalStringArgument(arguments, "serverExtension");
  v2::V2NIMClient::get().getConversationGroupService().updateConversationGroup(
      groupId, name, serverExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](const v2::V2NIMError& error) { returnSdkError(error, result); });
}

void FLTConversationGroupService::addConversationsToGroup(
    const flutter::EncodableMap* arguments, MethodResult result) {
  std::string groupId;
  nstd::vector<nstd::string> conversationIds;
  if (!getStringArgument(arguments, "groupId", groupId) ||
      !getStringListArgument(arguments, "conversationIds", conversationIds)) {
    returnParameterError("addConversationsToGroup", result);
    return;
  }
  v2::V2NIMClient::get().getConversationGroupService().addConversationsToGroup(
      groupId, conversationIds,
      [result](const nstd::vector<v2::V2NIMConversationOperationResult>&
                   operationResults) {
        flutter::EncodableMap data;
        data.insert(std::make_pair(
            "conversationOperationResults",
            convertConversationOperationResultsToList(operationResults)));
        result->Success(NimResult::getSuccessResult(data));
      },
      [result](const v2::V2NIMError& error) { returnSdkError(error, result); });
}

void FLTConversationGroupService::removeConversationsFromGroup(
    const flutter::EncodableMap* arguments, MethodResult result) {
  std::string groupId;
  nstd::vector<nstd::string> conversationIds;
  if (!getStringArgument(arguments, "groupId", groupId) ||
      !getStringListArgument(arguments, "conversationIds", conversationIds)) {
    returnParameterError("removeConversationsFromGroup", result);
    return;
  }
  v2::V2NIMClient::get()
      .getConversationGroupService()
      .removeConversationsFromGroup(
          groupId, conversationIds,
          [result](const nstd::vector<v2::V2NIMConversationOperationResult>&
                       operationResults) {
            flutter::EncodableMap data;
            data.insert(std::make_pair(
                "conversationOperationResults",
                convertConversationOperationResultsToList(operationResults)));
            result->Success(NimResult::getSuccessResult(data));
          },
          [result](const v2::V2NIMError& error) {
            returnSdkError(error, result);
          });
}

void FLTConversationGroupService::getConversationGroup(
    const flutter::EncodableMap* arguments, MethodResult result) {
  std::string groupId;
  if (!getStringArgument(arguments, "groupId", groupId)) {
    returnParameterError("getConversationGroup", result);
    return;
  }
  v2::V2NIMClient::get().getConversationGroupService().getConversationGroup(
      groupId,
      [result](const v2::V2NIMConversationGroup& group) {
        result->Success(
            NimResult::getSuccessResult(convertConversationGroupToMap(group)));
      },
      [result](const v2::V2NIMError& error) { returnSdkError(error, result); });
}

void FLTConversationGroupService::getConversationGroupList(
    const flutter::EncodableMap* arguments, MethodResult result) {
  v2::V2NIMClient::get().getConversationGroupService().getConversationGroupList(
      [result](const nstd::vector<v2::V2NIMConversationGroup>& groups) {
        flutter::EncodableMap data;
        data.insert(std::make_pair("conversationGroups",
                                   convertConversationGroupsToList(groups)));
        result->Success(NimResult::getSuccessResult(data));
      },
      [result](const v2::V2NIMError& error) { returnSdkError(error, result); });
}

void FLTConversationGroupService::getConversationGroupListByIds(
    const flutter::EncodableMap* arguments, MethodResult result) {
  nstd::vector<nstd::string> groupIds;
  if (!getStringListArgument(arguments, "groupIds", groupIds)) {
    returnParameterError("getConversationGroupListByIds", result);
    return;
  }
  v2::V2NIMClient::get()
      .getConversationGroupService()
      .getConversationGroupListByIds(
          groupIds,
          [result](const nstd::vector<v2::V2NIMConversationGroup>& groups) {
            flutter::EncodableMap data;
            data.insert(std::make_pair(
                "conversationGroups", convertConversationGroupsToList(groups)));
            result->Success(NimResult::getSuccessResult(data));
          },
          [result](const v2::V2NIMError& error) {
            returnSdkError(error, result);
          });
}
