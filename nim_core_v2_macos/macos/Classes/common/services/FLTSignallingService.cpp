// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#include "FLTSignallingService.h"

using namespace nim;

FLTSignallingService::FLTSignallingService() {
  m_serviceName = "SignallingService";

  listener.onOnlineEvent = [this](const v2::V2NIMSignallingEvent& event) {
    flutter::EncodableMap resultMap = convertSignallingEvent(event);
    notifyEvent("onOnlineEvent", resultMap);
  };

  listener.onOfflineEvent =
      [this](const nstd::vector<v2::V2NIMSignallingEvent>& datas) {
        flutter::EncodableList dataList;
        for (auto data : datas) {
          dataList.emplace_back(convertSignallingEvent(data));
        }

        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("offlineEvents", dataList));
        notifyEvent("onOfflineEvent", resultMap);
      };

  listener.onMultiClientEvent = [this](const v2::V2NIMSignallingEvent& event) {
    flutter::EncodableMap resultMap = convertSignallingEvent(event);
    notifyEvent("onMultiClientEvent", resultMap);
  };

  listener.onSyncRoomInfoList =
      [this](const nstd::vector<v2::V2NIMSignallingRoomInfo>& datas) {
        flutter::EncodableList dataList;
        for (auto data : datas) {
          dataList.emplace_back(convertSignallingRoomInfo(data));
        }

        flutter::EncodableMap resultMap;
        resultMap.insert(std::make_pair("syncRoomInfoList", dataList));
        notifyEvent("onSyncRoomInfoList", resultMap);
      };

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();

  signallingService.addSignallingListener(listener);
}

FLTSignallingService::~FLTSignallingService() {
  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();

  signallingService.removeSignallingListener(listener);
}

void FLTSignallingService::onMethodCalled(
    const std::string& method, const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  switch (utils::hash_(method.c_str())) {
    case "call"_hash:
      call(arguments, result);
      return;

    case "callSetup"_hash:
      callSetup(arguments, result);
      return;

    case "createRoom"_hash:
      createRoom(arguments, result);
      return;

    case "closeRoom"_hash:
      closeRoom(arguments, result);
      return;

    case "joinRoom"_hash:
      joinRoom(arguments, result);
      return;

    case "leaveRoom"_hash:
      leaveRoom(arguments, result);
      return;

    case "invite"_hash:
      invite(arguments, result);
      return;

    case "cancelInvite"_hash:
      cancelInvite(arguments, result);
      return;

    case "rejectInvite"_hash:
      rejectInvite(arguments, result);
      return;

    case "acceptInvite"_hash:
      acceptInvite(arguments, result);
      return;

    case "sendControl"_hash:
      sendControl(arguments, result);
      return;

    case "getRoomInfoByChannelName"_hash:
      getRoomInfoByChannelName(arguments, result);
      return;

    default:
      break;
  }
  if (result) result->NotImplemented();
}

/// 直接呼叫对方加入房间
/// 信令正常流程为
///  - 创建房间（createRoom），房间创建默认有效时间 2 个小时，
///  - 自己加入房间（join）
///  - 邀请对方加入房间（invite）
/// 上述的房间是信令的房间，不是音视频的房间，因此需要三次向服务器交互才能建立相关流程
/// call
/// 接口同时由服务器实现了上述三个接口的功能，可以加速呼叫流程，如果你需要精确控制每一步，则需要调用上述每一个接口
/// @param params 呼叫参数
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::call(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSignallingCallParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSignallingCallParams(&paramsMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.call(
      params,
      [result](const v2::V2NIMSignallingCallResult& res) {
        flutter::EncodableMap resultMap = convertSignallingCallResult(res);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// 呼叫建立，包括加入信令频道房间，同时接受对方呼叫
///  - 组合接口（join+accept）
///  - 如果需要详细处理每一步骤，则可以单独调用 join 接口，之后再调用 accept
///  接口
/// @param params 建立呼叫参数
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::callSetup(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSignallingCallSetupParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSignallingCallSetupParams(&paramsMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.callSetup(
      params,
      [result](const v2::V2NIMSignallingCallSetupResult& res) {
        flutter::EncodableMap resultMap = convertSignallingCallSetupResult(res);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// 创建信令房间
/// 频道与房间一一对应，可以理解为同一概念，相同的频道名，在服务器同时只能存在一个
/// 房间创建默认有效时间 2 个小时，房间人数默认上限 100 人
/// @param channelType 频道类型
/// @param channelName 频道名称， 建议使用与业务有相关场景的名称，便于页面显示
/// @param channelExtension 频道相关扩展字段，长度限制 4096，与频道绑定，JSON
/// 格式
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::createRoom(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSignallingChannelType channelType;
  nstd::optional<nstd::string> channelName;
  nstd::optional<nstd::string> channelExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("channelType")) {
      channelType = v2::V2NIMSignallingChannelType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("channelName")) {
      channelName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("channelExtension")) {
      channelExtension = std::get<std::string>(iter->second);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.createRoom(
      channelType, channelName, channelExtension,
      [result](const v2::V2NIMSignallingChannelInfo& res) {
        flutter::EncodableMap resultMap = convertSignallingChannelInfo(res);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// 关闭信令房间接口
/// 该接口调用后会触发关闭通知给房间内所有人，房间内的所有人均可以调用该接口
/// 信令房间如果没有主动调用接口关闭，会等待 2 个小时，2
/// 个小时没有新的用户加入，则服务器自行销毁对应的信令房间
/// @param channelId 频道 ID
/// @param offlineEnabled
/// 是否支持离线推送，如果支持离线推送，用户离线后，仍然可以收到信令通知
/// @param serverExtension 服务器扩展字段，长度限制 4096，JSON 格式
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::closeRoom(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nstd::string channelId;
  nstd::optional<bool> offlineEnabled;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("channelId")) {
      channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("offlineEnabled")) {
      offlineEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.closeRoom(
      channelId, offlineEnabled, serverExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// 加入信令房间接口
/// 该接口调用后会触发加入通知给房间内所有人，默认有效期为 5 分钟
/// @param params 加入房间参数
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::joinRoom(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSignallingJoinParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSignallingJoinParams(&paramsMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.joinRoom(
      params,
      [result](const v2::V2NIMSignallingJoinResult& res) {
        flutter::EncodableMap resultMap = convertSignallingJoinResult(res);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// 离开信令房间接口
/// 该接口调用后会触发离开通知给房间内所有人
/// @param channelId 频道 ID
/// @param offlineEnabled
/// 是否支持离线推送，如果支持离线推送，用户离线后，仍然可以收到信令通知
/// @param serverExtension 服务器扩展字段，长度限制 4096，JSON 格式
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::leaveRoom(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nstd::string channelId;
  nstd::optional<bool> offlineEnabled;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("channelId")) {
      channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("offlineEnabled")) {
      offlineEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.leaveRoom(
      channelId, offlineEnabled, serverExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// @brief 邀请成员加入信令房间接口，房间内的人均可以发送邀请
/// 该接口调用后会触发邀请通知给对方，
/// 发送方可以配置是否需要发送推送，默认情况下不推送
/// @param params 邀请参数
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::invite(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSignallingInviteParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSignallingInviteParams(&paramsMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.invite(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// @brief 取消之前的邀请成员加入信令房间接口
///  - 该接口调用后会触发取消邀请通知给对方
///  - 只能取消自己的邀请请求
/// @param params 取消邀请参数
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::cancelInvite(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSignallingCancelInviteParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSignallingCancelInviteParams(&paramsMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.cancelInvite(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// @brief 拒绝别人的邀请加入信令房间请求，该接口调用后会触发拒绝邀请通知给对方
/// @param params 拒绝邀请参数
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::rejectInvite(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSignallingRejectInviteParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSignallingRejectInviteParams(&paramsMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.rejectInvite(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// @brief 接受别人的邀请加入信令房间请求，该接口调用后会触发接受邀请通知给对方
/// @param params 接受邀请参数
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::acceptInvite(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  v2::V2NIMSignallingAcceptInviteParams params;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("params")) {
      auto paramsMap = std::get<flutter::EncodableMap>(iter->second);
      params = getSignallingAcceptInviteParams(&paramsMap);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.acceptInvite(
      params, [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// @brief 发送自定义控制指令，可以实现自定义相关的业务逻辑
/// 可以发送给指定用户，如果不指定，则发送给信令房间内的所有人
/// 该接口不做成员校验，允许非频道房间内的成员调用，但是接受者必须在频道房间内或者是创建者
/// 接口调用后会发送一个控制通知
///  - 如果指定了接受者： 则通知发送给接受者
///  - 如果未指定接受者：则发送给房间内的所有人
///  - 通知仅发在线
/// @param channelId 频道 ID
/// @param receiverAccountId 接受者账号 ID，如果不指定，则发送给房间内的所有人
/// @param serverExtension 服务器扩展字段，长度限制 4096，JSON 格式
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::sendControl(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nstd::string channelId;
  nstd::optional<nstd::string> receiverAccountId;
  nstd::optional<nstd::string> serverExtension;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("channelId")) {
      channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("receiverAccountId")) {
      receiverAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      serverExtension = std::get<std::string>(iter->second);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.sendControl(
      channelId, receiverAccountId, serverExtension,
      [result]() { result->Success(NimResult::getSuccessResult()); },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

/// @brief 根据频道名称查询频道房间信息
/// @param channelName 频道名称
/// @param success 成功回调
/// @param failure 失败回调
/// @return void
void FLTSignallingService::getRoomInfoByChannelName(
    const flutter::EncodableMap* arguments,
    std::shared_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (!arguments) {
    return;
  }

  nstd::string channelName;

  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }

    if (iter->first == flutter::EncodableValue("channelName")) {
      channelName = std::get<std::string>(iter->second);
    }
  }

  auto& client = v2::V2NIMClient::get();
  auto& signallingService = client.getSignallingService();
  signallingService.getRoomInfoByChannelName(
      channelName,
      [result](const v2::V2NIMSignallingRoomInfo& res) {
        flutter::EncodableMap resultMap = convertSignallingRoomInfo(res);
        result->Success(NimResult::getSuccessResult(resultMap));
      },
      [result](v2::V2NIMError error) {
        result->Error("", error.desc,
                      NimResult::getErrorResult(error.code, error.desc));
      });
}

v2::V2NIMSignallingCallParams getSignallingCallParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingCallParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("calleeAccountId")) {
      object.calleeAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("requestId")) {
      object.requestId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("channelType")) {
      object.channelType =
          v2::V2NIMSignallingChannelType(std::get<int>(iter->second));
    } else if (iter->first == flutter::EncodableValue("channelName")) {
      object.channelName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("channelExtension")) {
      object.channelExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("signallingConfig")) {
      auto signallingConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.signallingConfig = getSignallingConfig(&signallingConfigMap);
    } else if (iter->first == flutter::EncodableValue("pushConfig")) {
      auto pushConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.pushConfig = getSignallingPushConfig(&pushConfigMap);
    } else if (iter->first == flutter::EncodableValue("rtcConfig")) {
      auto rtcConfiggMap = std::get<flutter::EncodableMap>(iter->second);
      object.rtcConfig = getSignallingRtcConfig(&rtcConfiggMap);
    }
  }
  return object;
}

v2::V2NIMSignallingCallSetupParams getSignallingCallSetupParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingCallSetupParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("channelId")) {
      object.channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("callerAccountId")) {
      object.callerAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("requestId")) {
      object.requestId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("signallingConfig")) {
      auto signallingConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.signallingConfig = getSignallingConfig(&signallingConfigMap);
    } else if (iter->first == flutter::EncodableValue("rtcConfig")) {
      auto rtcConfiggMap = std::get<flutter::EncodableMap>(iter->second);
      object.rtcConfig = getSignallingRtcConfig(&rtcConfiggMap);
    }
  }
  return object;
}

v2::V2NIMSignallingConfig getSignallingConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("offlineEnabled")) {
      object.offlineEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("unreadEnabled")) {
      object.unreadEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("selfUid")) {
      object.selfUid = iter->second.LongValue();
    }
  }
  return object;
}

v2::V2NIMSignallingPushConfig getSignallingPushConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingPushConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("pushEnabled")) {
      object.pushEnabled = std::get<bool>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushTitle")) {
      object.pushTitle = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushContent")) {
      object.pushContent = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("pushPayload")) {
      object.pushPayload = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMSignallingRtcConfig getSignallingRtcConfig(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingRtcConfig object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("rtcChannelName")) {
      object.rtcChannelName = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("rtcTokenTtl")) {
      object.rtcTokenTtl = iter->second.LongValue();
    } else if (iter->first == flutter::EncodableValue("rtcParams")) {
      object.rtcParams = std::get<std::string>(iter->second);
    }
  }
  return object;
}

v2::V2NIMSignallingCancelInviteParams getSignallingCancelInviteParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingCancelInviteParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("channelId")) {
      object.channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("inviteeAccountId")) {
      object.inviteeAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("requestId")) {
      object.requestId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("offlineEnabled")) {
      object.offlineEnabled = std::get<bool>(iter->second);
    }
  }
  return object;
}

v2::V2NIMSignallingJoinParams getSignallingJoinParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingJoinParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("channelId")) {
      object.channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("signallingConfig")) {
      auto signallingConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.signallingConfig = getSignallingConfig(&signallingConfigMap);
    } else if (iter->first == flutter::EncodableValue("rtcConfig")) {
      auto rtcConfiggMap = std::get<flutter::EncodableMap>(iter->second);
      object.rtcConfig = getSignallingRtcConfig(&rtcConfiggMap);
    }
  }
  return object;
}

v2::V2NIMSignallingInviteParams getSignallingInviteParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingInviteParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("channelId")) {
      object.channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("inviteeAccountId")) {
      object.inviteeAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("requestId")) {
      object.requestId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("signallingConfig")) {
      auto signallingConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.signallingConfig = getSignallingConfig(&signallingConfigMap);
    } else if (iter->first == flutter::EncodableValue("pushConfig")) {
      auto pushConfigMap = std::get<flutter::EncodableMap>(iter->second);
      object.pushConfig = getSignallingPushConfig(&pushConfigMap);
    }
  }
  return object;
}

v2::V2NIMSignallingRejectInviteParams getSignallingRejectInviteParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingRejectInviteParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("channelId")) {
      object.channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("inviterAccountId")) {
      object.inviterAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("requestId")) {
      object.requestId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("offlineEnabled")) {
      object.offlineEnabled = std::get<bool>(iter->second);
    }
  }
  return object;
}

v2::V2NIMSignallingAcceptInviteParams getSignallingAcceptInviteParams(
    const flutter::EncodableMap* arguments) {
  v2::V2NIMSignallingAcceptInviteParams object;
  auto iter = arguments->begin();
  for (iter; iter != arguments->end(); ++iter) {
    if (iter->second.IsNull()) {
      continue;
    }
    if (iter->first == flutter::EncodableValue("channelId")) {
      object.channelId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("inviterAccountId")) {
      object.inviterAccountId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("requestId")) {
      object.requestId = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("serverExtension")) {
      object.serverExtension = std::get<std::string>(iter->second);
    } else if (iter->first == flutter::EncodableValue("offlineEnabled")) {
      object.offlineEnabled = std::get<bool>(iter->second);
    }
  }
  return object;
}

flutter::EncodableMap convertSignallingCallResult(
    const v2::V2NIMSignallingCallResult object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(
      std::make_pair("callStatus", static_cast<int64_t>(object.callStatus)));
  resultMap.insert(
      std::make_pair("roomInfo", convertSignallingRoomInfo(object.roomInfo)));
  if (object.rtcInfo.has_value()) {
    resultMap.insert(std::make_pair(
        "rtcInfo", convertSignallingRtcInfo(object.rtcInfo.value())));
  }

  return resultMap;
}

flutter::EncodableMap convertSignallingJoinResult(
    const v2::V2NIMSignallingJoinResult object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(
      std::make_pair("roomInfo", convertSignallingRoomInfo(object.roomInfo)));

  if (object.rtcInfo.has_value()) {
    resultMap.insert(std::make_pair(
        "rtcInfo", convertSignallingRtcInfo(object.rtcInfo.value())));
  }

  return resultMap;
}

flutter::EncodableMap convertSignallingRoomInfo(
    const v2::V2NIMSignallingRoomInfo object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair(
      "channelInfo", convertSignallingChannelInfo(object.channelInfo)));

  flutter::EncodableList memberList;
  for (auto member : object.members) {
    memberList.emplace_back(convertSignallingMember(member));
  }
  resultMap.insert(std::make_pair("members", memberList));
  return resultMap;
}

flutter::EncodableMap convertSignallingMember(
    const v2::V2NIMSignallingMember object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("accountId", object.accountId));
  resultMap.insert(std::make_pair("uid", object.uid));
  resultMap.insert(
      std::make_pair("joinTime", static_cast<int64_t>(object.joinTime)));
  resultMap.insert(
      std::make_pair("expireTime", static_cast<int64_t>(object.expireTime)));
  resultMap.insert(std::make_pair("deviceId", object.deviceId));
  return resultMap;
}

flutter::EncodableMap convertSignallingChannelInfo(
    const v2::V2NIMSignallingChannelInfo object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("channelId", object.channelId));
  resultMap.insert(std::make_pair("channelType", object.channelType));
  resultMap.insert(
      std::make_pair("createTime", static_cast<int64_t>(object.createTime)));
  resultMap.insert(
      std::make_pair("expireTime", static_cast<int64_t>(object.expireTime)));
  resultMap.insert(std::make_pair("creatorAccountId", object.creatorAccountId));

  if (object.channelName.has_value()) {
    resultMap.insert(std::make_pair("channelName", object.channelName.value()));
  }

  if (object.channelExtension.has_value()) {
    resultMap.insert(
        std::make_pair("channelExtension", object.channelExtension.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertSignallingRtcInfo(
    const v2::V2NIMSignallingRtcInfo object) {
  flutter::EncodableMap resultMap;

  if (object.rtcToken.has_value()) {
    resultMap.insert(std::make_pair("rtcToken", object.rtcToken.value()));
  }

  if (object.rtcTokenTtl.has_value()) {
    resultMap.insert(std::make_pair(
        "rtcTokenTtl", static_cast<int64_t>(object.rtcTokenTtl.value())));
  }

  if (object.rtcParams.has_value()) {
    resultMap.insert(std::make_pair("rtcParams", object.rtcParams.value()));
  }
  return resultMap;
}

flutter::EncodableMap convertSignallingCallSetupResult(
    const v2::V2NIMSignallingCallSetupResult object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(
      std::make_pair("roomInfo", convertSignallingRoomInfo(object.roomInfo)));

  if (object.callStatus.has_value()) {
    resultMap.insert(std::make_pair(
        "callStatus", static_cast<int64_t>(object.callStatus.value())));
  }

  if (object.rtcInfo.has_value()) {
    resultMap.insert(std::make_pair(
        "rtcInfo", convertSignallingRtcInfo(object.rtcInfo.value())));
  }
  return resultMap;
}

flutter::EncodableMap convertSignallingEvent(
    const v2::V2NIMSignallingEvent object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("eventType", object.eventType));
  resultMap.insert(std::make_pair(
      "channelInfo", convertSignallingChannelInfo(object.channelInfo)));
  resultMap.insert(
      std::make_pair("operatorAccountId", object.operatorAccountId));
  resultMap.insert(std::make_pair("time", static_cast<int64_t>(object.time)));
  resultMap.insert(std::make_pair("requestId", object.requestId));

  if (object.serverExtension.has_value()) {
    resultMap.insert(
        std::make_pair("serverExtension", object.serverExtension.value()));
  }

  if (object.inviteeAccountId.has_value()) {
    resultMap.insert(
        std::make_pair("inviteeAccountId", object.inviteeAccountId.value()));
  }

  if (object.inviterAccountId.has_value()) {
    resultMap.insert(
        std::make_pair("inviterAccountId", object.inviterAccountId.value()));
  }

  if (object.pushConfig.has_value()) {
    resultMap.insert(std::make_pair(
        "pushConfig", convertSignallingPushConfig(object.pushConfig.value())));
  }

  if (object.unreadEnabled.has_value()) {
    resultMap.insert(
        std::make_pair("unreadEnabled", object.unreadEnabled.value()));
  }

  if (object.member.has_value()) {
    resultMap.insert(std::make_pair(
        "member", convertSignallingMember(object.member.value())));
  }
  return resultMap;
}

flutter::EncodableMap convertSignallingPushConfig(
    const v2::V2NIMSignallingPushConfig object) {
  flutter::EncodableMap resultMap;

  resultMap.insert(std::make_pair("pushEnabled", object.pushEnabled));

  if (object.pushTitle.has_value()) {
    resultMap.insert(std::make_pair("pushTitle", object.pushTitle.value()));
  }

  if (object.pushContent.has_value()) {
    resultMap.insert(std::make_pair("pushContent", object.pushContent.value()));
  }

  if (object.pushPayload.has_value()) {
    resultMap.insert(std::make_pair("pushPayload", object.pushPayload.value()));
  }
  return resultMap;
}