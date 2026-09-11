/*
 *
 *  * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 *  * Use of this source code is governed by a MIT license that can be
 *  * found in the LICENSE file.
 *
 *
 */

import { Any } from '@ohos/flutter_ohos';
import {
  V2NIMAntispamConfig,
  V2NIMMessageAttachment,
  V2NIMMessageAttachmentUploadState,
  V2NIMMessageRouteConfig,
  V2NIMMessageSendingState,
  V2NIMMessageType,
  V2NIMQueryDirection
} from '@nimsdk/base';
import {
  V2NIMChatroomLocationConfig,
  V2NIMChatroomMember,
  V2NIMChatroomMemberListResult,
  V2NIMChatroomMemberQueryOption,
  V2NIMChatroomMemberRole,
  V2NIMChatroomMemberRoleUpdateParams,
  V2NIMChatroomMessage,
  V2NIMChatroomMessageConfig,
  V2NIMChatroomMessageListOption,
  V2NIMChatroomNotificationAttachment,
  V2NIMChatroomSelfMemberUpdateParams,
  V2NIMChatroomTagMemberOption,
  V2NIMChatroomTagMessageOption,
  V2NIMChatroomTagsUpdateParams,
  V2NIMChatroomTagTempChatBannedParams,
  V2NIMChatroomUpdateParams,
  V2NIMLocationInfo,
  V2NIMSendChatroomMessageParams,
  V2NIMSendChatroomMessageResult,
  V2NIMUserInfoConfig
} from '@nimsdk/chatroom/Index';
import {
  convertAttachmentToMap,
  convertMap2MessageAttachment
} from '../message/messageAttachment/V2NIMMessageAttachment';
import { convertMap2MessageAudioAttachment } from '../message/messageAttachment/V2NIMMessageAudioAttachment';
import { convertMap2MessageCallAttachment } from '../message/messageAttachment/V2NIMMessageCallAttachment';
import { convertMap2MessageFileAttachment } from '../message/messageAttachment/V2NIMMessageFileAttachment';
import { convertMap2MessageImageAttachment } from '../message/messageAttachment/V2NIMMessageImageAttachment';
import { convertMap2MessageLocationAttachment } from '../message/messageAttachment/V2NIMMessageLocationAttachment';
import {
  convertMap2MessageNotificationAttachment
} from '../message/messageAttachment/V2NIMMessageNotificationAttachment';
import { convertMap2MessageVideoAttachment } from '../message/messageAttachment/V2NIMMessageVideoAttachment';
import { convertMap2MessageConfig } from '../message/V2NIMMessageConfig';
import { convertMap2MessageRouteConfig } from '../message/V2NIMMessageRouteConfig';
import { convertMap2MessageAntispamConfig } from '../message/V2NIMMessageAntispamConfig';

export function convertObjectToMap(value: Object | undefined | null): Map<string, Any> {
  if (value === undefined || value === null) {
    return new Map<string, Any>();
  }
  return new Map<string, Any>(Object.entries(value));
}

function convertObjectToMapOrUndefined(value: Object | undefined | null): Map<string, Any> | undefined {
  if (value === undefined || value === null) {
    return undefined;
  }
  return convertObjectToMap(value);
}

export function convertToChatroomUpdateParams(map: Map<string, Any>): V2NIMChatroomUpdateParams {
  // 显式初始化所有可选属性为undefined，与接口定义保持一致
  const updateParams: V2NIMChatroomUpdateParams = {};

  // 处理聊天室名称
  if (map.get("roomName") !== undefined && map.get("roomName") !== null) {
    updateParams.roomName = map.get("roomName") as string;
  }

  // 处理聊天室公告
  if (map.get("announcement") !== undefined && map.get("announcement") !== null) {
    updateParams.announcement = map.get("announcement") as string;
  }

  // 处理聊天室直播地址
  if (map.get("liveUrl") !== undefined && map.get("liveUrl") !== null) {
    updateParams.liveUrl = map.get("liveUrl") as string;
  }

  // 处理聊天室扩展字段
  if (map.get("serverExtension") !== undefined && map.get("serverExtension") !== null) {
    updateParams.serverExtension = map.get("serverExtension") as string;
  }

  // 处理是否需要通知
  if (map.get("notificationEnabled") !== undefined && map.get("notificationEnabled") !== null) {
    updateParams.notificationEnabled = map.get("notificationEnabled") as boolean;
  }

  // 处理通知扩展字段
  if (map.get("notificationExtension") !== undefined && map.get("notificationExtension") !== null) {
    updateParams.notificationExtension = map.get("notificationExtension") as string;
  }

  return updateParams;
}


/**
 * 将Map转换为V2NIMChatroomLocationConfig对象
 * @param map 包含位置配置信息的Map
 * @returns 类型安全的V2NIMChatroomLocationConfig对象
 */
export function convertToLocationConfig(map: Map<string, Any>): V2NIMChatroomLocationConfig {

  if (map.get("locationInfo") !== undefined || map.get("locationInfo") !== null) {
    // 初始化locationInfo子对象，显式设置可选属性为undefined
    const locationInfo: V2NIMLocationInfo = convertToLocationInfo(map.get("locationInfo") as Map<string,Any>);
    // 初始化主配置对象，distance为必填属性需校验
    const locationConfig: V2NIMChatroomLocationConfig = {
      locationInfo: locationInfo,
      distance: 0 // 临时默认值，后续会被有效数据覆盖
    };
    // 处理distance（必填属性，严格校验非空）
    if (map.get("distance") === undefined || map.get("distance") === null) {
      throw new Error("Missing or invalid required field: distance");
    }
    locationConfig.distance = map.get("distance") as number;

    return locationConfig;
  }

  return {
    locationInfo: {
      x: undefined,
      y: undefined,
      z: undefined,
    },
    distance: map.get("distance") as number,
  };
}


export function convertToLocationInfo(map: Map<string, Any>): V2NIMLocationInfo {
  // 显式初始化所有可选属性为undefined，匹配接口定义
  const locationInfo: V2NIMLocationInfo = {
    x: undefined,
    y: undefined,
    z: undefined
  };

  // 处理X坐标
  if (map.get("x") !== undefined && map.get("x") !== null) {
    locationInfo.x = map.get("x") as number;
  }

  // 处理Y坐标
  if (map.get("y") !== undefined && map.get("y") !== null) {
    locationInfo.y = map.get("y") as number;
  }

  // 处理Z坐标
  if (map.get("z") !== undefined && map.get("z") !== null) {
    locationInfo.z = map.get("z") as number;
  }

  return locationInfo;
}

export function convertToUserInfoConfig(map: Map<string, Any>): V2NIMUserInfoConfig {
  // 显式初始化所有属性为undefined，与接口的可选性保持一致
  const config: V2NIMUserInfoConfig = {
    userInfoTimestamp: undefined,
    senderNick: undefined,
    senderAvatar: undefined,
    senderExtension: undefined
  };

  // 处理用户信息时间戳
  if (map.get("userInfoTimestamp") !== undefined && map.get("userInfoTimestamp") !== null) {
    config.userInfoTimestamp = map.get("userInfoTimestamp") as number;
  }

  // 处理发送者昵称
  if (map.get("senderNick") !== undefined && map.get("senderNick") !== null) {
    config.senderNick = map.get("senderNick") as string;
  }

  // 处理发送者头像
  if (map.get("senderAvatar") !== undefined && map.get("senderAvatar") !== null) {
    config.senderAvatar = map.get("senderAvatar") as string;
  }

  // 处理发送者扩展字段
  if (map.get("senderExtension") !== undefined && map.get("senderExtension") !== null) {
    config.senderExtension = map.get("senderExtension") as string;
  }

  return config;
}

/**

 将 Map 转换为聊天室标签更新参数对象
 @param map 包含标签更新参数的 Map
 @returns 类型安全的 V2NIMChatroomTagsUpdateParams 对象
 */
export function convertToChatroomTagsUpdateParams (map: Map<string, Any>): V2NIMChatroomTagsUpdateParams {
  // 显式初始化所有属性为 undefined，匹配接口的可选性定义
  const updateParams: V2NIMChatroomTagsUpdateParams = {};

  // 处理标签列表
  if (map.get ("tags") !== undefined && map.get ("tags") !== null) {
    updateParams.tags = map.get ("tags") as string [];
  }

  // 处理通知目标标签
  if (map.get ("notifyTargetTags") !== undefined && map.get ("notifyTargetTags") !== null) {
    updateParams.notifyTargetTags = map.get ("notifyTargetTags") as string;
  }

  // 处理是否启用通知
  if (map.get ("notificationEnabled") !== undefined && map.get ("notificationEnabled") !== null) {
    updateParams.notificationEnabled = map.get ("notificationEnabled") as boolean;
  }

  // 处理通知扩展字段
  if (map.get ("notificationExtension") !== undefined && map.get ("notificationExtension") !== null) {
    updateParams.notificationExtension = map.get ("notificationExtension") as string;
  }

  return updateParams;
}

export function convertToChatroomMessage(argumentsMap: Map<string, Any>): V2NIMChatroomMessage {

  let message: V2NIMChatroomMessage = {
    messageClientId: "",
    createTime: 0,
    senderId: "",
    isSelf: false,
    sendingState: V2NIMMessageSendingState.V2NIM_MESSAGE_SENDING_STATE_UNKNOWN,
    messageType: V2NIMMessageType.V2NIM_MESSAGE_TYPE_INVALID,
    senderClientType: 0,
    roomId: ''
  }

  if (argumentsMap === undefined || argumentsMap === null) {
    return message
  }

  if (argumentsMap.get("messageClientId") !== undefined && argumentsMap.get("messageClientId") !== null) {
    message.messageClientId = argumentsMap.get("messageClientId") as string
  }

  if (argumentsMap.get("senderClientType") !== undefined && argumentsMap.get("senderClientType") !== null) {
    message.senderClientType = argumentsMap.get("senderClientType") as number
  }

  if (argumentsMap.get("createTime") !== undefined && argumentsMap.get("createTime") !== null) {
    message.createTime = argumentsMap.get("createTime") as number
  }

  if (argumentsMap.get("senderId") !== undefined && argumentsMap.get("senderId") !== null) {
    message.senderId = argumentsMap.get("senderId") as string
  }

  if (argumentsMap.get("roomId") !== undefined && argumentsMap.get("roomId") !== null) {
    message.roomId = argumentsMap.get("roomId") as string
  }

  if (argumentsMap.get("isSelf") !== undefined && argumentsMap.get("isSelf") !== null) {
    message.isSelf = argumentsMap.get("isSelf") as boolean
  }

  if (argumentsMap.get("attachmentUploadState") !== undefined && argumentsMap.get("attachmentUploadState") != null) {
    message.attachmentUploadState = argumentsMap.get("attachmentUploadState") as V2NIMMessageAttachmentUploadState
  }

  if (argumentsMap.get("sendingState") !== undefined && argumentsMap.get("sendingState") != null) {
    message.sendingState = argumentsMap.get("sendingState") as V2NIMMessageSendingState
  }

  if (argumentsMap.get("messageType") !== undefined && argumentsMap.get("messageType") != null) {
    message.messageType = argumentsMap.get("messageType") as number
  }

  if (argumentsMap.get("subType") !== undefined && argumentsMap.get("subType") != null) {
    message.subType = argumentsMap.get("subType") as number
  }

  if (argumentsMap.get("text") !== undefined && argumentsMap.get("text") != null) {
    message.text = argumentsMap.get("text") as string
  }

  if (argumentsMap.get("attachment") !== undefined && argumentsMap.get("attachment") != null) {
    let attachmentMap: Map<string, Any> = argumentsMap.get("attachment") as Map<string, Any>
    switch (message.messageType) {
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_AUDIO:
        message.attachment = convertMap2MessageAudioAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_FILE:
        message.attachment = convertMap2MessageFileAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_IMAGE:
        message.attachment = convertMap2MessageImageAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_VIDEO:
        message.attachment = convertMap2MessageVideoAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_LOCATION:
        message.attachment = convertMap2MessageLocationAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION:
        message.attachment = convertMap2MessageNotificationAttachment(attachmentMap)
        break
      case V2NIMMessageType.V2NIM_MESSAGE_TYPE_CALL:
        message.attachment = convertMap2MessageCallAttachment(attachmentMap)
        break
      default:
        message.attachment = convertMap2MessageAttachment(attachmentMap)
        break
    }
  }

  if (argumentsMap.get("serverExtension") !== undefined && argumentsMap.get("serverExtension") != null) {
    message.serverExtension = argumentsMap.get("serverExtension") as string
  }

  if (argumentsMap.get("callbackExtension") !== undefined && argumentsMap.get("callbackExtension") != null) {
    message.callbackExtension = argumentsMap.get("callbackExtension") as string
  }

  if (argumentsMap.get("messageConfig") !== undefined && argumentsMap.get("messageConfig") != null) {
    message.messageConfig = convertMap2MessageConfig(argumentsMap.get("messageConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("routeConfig") !== undefined && argumentsMap.get("routeConfig") != null) {
    message.routeConfig = convertMap2MessageRouteConfig(argumentsMap.get("routeConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("antispamConfig") !== undefined && argumentsMap.get("antispamConfig") != null) {
    message.antispamConfig = convertMap2MessageAntispamConfig(argumentsMap.get("antispamConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("notifyTargetTags") !== undefined && argumentsMap.get("notifyTargetTags") != null) {
    message.notifyTargetTags = argumentsMap.get("notifyTargetTags") as string
  }

  if (argumentsMap.get("userInfoConfig") !== undefined && argumentsMap.get("userInfoConfig") != null) {
    message.userInfoConfig = convertToUserInfoConfig(argumentsMap.get("userInfoConfig") as Map<string, Any>)
  }

  if (argumentsMap.get("locationInfo") !== undefined && argumentsMap.get("locationInfo") != null) {
    message.locationInfo = convertToLocationInfo(argumentsMap.get("locationInfo") as Map<string, Any>)
  }

  return message;

}

export function convertToSendChatroomMessageParams(map: Map<string, Any>): V2NIMSendChatroomMessageParams {
  let messageParams: V2NIMSendChatroomMessageParams = {}
  // 处理 messageConfig 参数
  if (map.get("messageConfig") !== undefined && map.get("messageConfig") !== null) {
    messageParams.messageConfig = convertToChatroomMessageConfig(map.get("messageConfig") as Map<string, Any>);
  }

  // 处理 routeConfig 参数
  if (map.get("routeConfig") !== undefined && map.get("routeConfig") !== null) {
    messageParams.routeConfig = convertToMessageRouteConfig(map.get("routeConfig") as Map<string, Any>);
  }

  // 处理 antispamConfig 参数
  if (map.get("antispamConfig") !== undefined && map.get("antispamConfig") !== null) {
    messageParams.antispamConfig = convertToAntispamConfig(map.get("antispamConfig") as Map<string, Any>);
  }

  // 处理 clientAntispamEnabled 参数
  if (map.get("clientAntispamEnabled") !== undefined && map.get("clientAntispamEnabled") !== null) {
    messageParams.clientAntispamEnabled = map.get("clientAntispamEnabled") as boolean;
  }

  // 处理 clientAntispamReplace 参数
  if (map.get("clientAntispamReplace") !== undefined && map.get("clientAntispamReplace") !== null) {
    messageParams.clientAntispamReplace = map.get("clientAntispamReplace") as string;
  }

  // 处理 receiverIds 参数
  if (map.get("receiverIds") !== undefined && map.get("receiverIds") !== null) {
    messageParams.receiverIds = map.get("receiverIds") as string[];
  }

  // 处理 notifyTargetTags 参数
  if (map.get("notifyTargetTags") !== undefined && map.get("notifyTargetTags") !== null) {
    messageParams.notifyTargetTags = map.get("notifyTargetTags") as string;
  }

  // 处理 locationInfo 参数
  if (map.get("locationInfo") !== undefined && map.get("locationInfo") !== null) {
    messageParams.locationInfo = map.get("locationInfo") as V2NIMLocationInfo;
  }
  return messageParams;
}

export function convertToChatroomMessageConfig(map: Map<string, Any>): V2NIMChatroomMessageConfig {
  const config: V2NIMChatroomMessageConfig = {};
  // 处理是否需要保存历史消息的配置
  const historyEnabled: Any = map.get('historyEnabled');
  if (historyEnabled !== null && historyEnabled !== undefined) {
    config.historyEnabled = historyEnabled as boolean;
  }
  // 处理是否为高优先级消息的配置
  const highPriority: Any = map.get('highPriority');
  if (highPriority !== null && highPriority !== undefined) {
    config.highPriority = highPriority as boolean;
  }
  return config;
}

export function convertToMessageRouteConfig(map: Map<string, Any>): V2NIMMessageRouteConfig {
  const routeConfig: V2NIMMessageRouteConfig = {};
  // 处理是否需要路由消息的配置
  const routeEnabled: Any = map.get('routeEnabled');
  if (routeEnabled !== null && routeEnabled !== undefined) {
    routeConfig.routeEnabled = routeEnabled as boolean;
  }
  // 处理路由环境变量配置
  const routeEnvironment: Any = map.get('routeEnvironment');
  if (routeEnvironment !== null && routeEnvironment !== undefined) {
    routeConfig.routeEnvironment = routeEnvironment as string;
  }
  return routeConfig;
}

/**
 * 转换为反垃圾配置对象
 * @param map 包含反垃圾配置的Map
 * @returns 类型安全的V2NIMAntispamConfig对象
 */
export function convertToAntispamConfig(map: Map<string, Any>): V2NIMAntispamConfig {
  // 显式初始化属性为undefined，匹配接口可选性
  const antispamConfig: V2NIMAntispamConfig = {
    antispamBusinessId: ''
  };

  // 仅在存在有效数据时赋值
  if (map.get("antispamBusinessId") !== undefined && map.get("antispamBusinessId") !== null) {
    antispamConfig.antispamBusinessId = map.get("antispamBusinessId") as string;
  }

  return antispamConfig;
}

/**
 * 转换为聊天室消息列表查询选项
 * @param map 包含查询选项的Map
 * @returns 类型安全的V2NIMChatroomMessageListOption对象
 */
export function convertToMessageListOption(map: Map<string, Any>): V2NIMChatroomMessageListOption {
  // 显式初始化所有可选属性
  const messageListOption: V2NIMChatroomMessageListOption = {
    direction: undefined,
    messageTypes: undefined,
    beginTime: undefined,
    limit: undefined
  };

  // 处理查询方向
  if (map.get("direction") !== undefined && map.get("direction") !== null) {
    messageListOption.direction = map.get("direction") as V2NIMQueryDirection;
  }

  // 处理消息类型过滤
  if (map.get("messageTypes") !== undefined && map.get("messageTypes") !== null) {
    messageListOption.messageTypes = map.get("messageTypes") as V2NIMMessageType[];
  }

  // 处理开始时间
  if (map.get("beginTime") !== undefined && map.get("beginTime") !== null) {
    messageListOption.beginTime = map.get("beginTime") as number;
  }

  // 处理分页大小
  if (map.get("limit") !== undefined && map.get("limit") !== null) {
    messageListOption.limit = map.get("limit") as number;
  }

  return messageListOption;
}

/**
 * 转换为聊天室成员查询选项
 * @param map 包含查询选项的Map
 * @returns 类型安全的V2NIMChatroomMemberQueryOption对象
 */
export function convertToMemberQueryOption(map: Map<string, Any>): V2NIMChatroomMemberQueryOption {
  // 显式初始化所有可选属性
  const memberQueryOption: V2NIMChatroomMemberQueryOption = {
    memberRoles: undefined,
    onlyBlocked: undefined,
    onlyChatBanned: undefined,
    onlyOnline: undefined,
    pageToken: '',
    limit: 100
  };

  // 处理成员角色过滤
  if (map.get("memberRoles") !== undefined && map.get("memberRoles") !== null) {
    memberQueryOption.memberRoles = map.get("memberRoles") as V2NIMChatroomMemberRole[];
  }

  // 处理黑名单过滤
  if (map.get("onlyBlocked") !== undefined && map.get("onlyBlocked") !== null) {
    memberQueryOption.onlyBlocked = map.get("onlyBlocked") as boolean;
  }

  // 处理禁言用户过滤
  if (map.get("onlyChatBanned") !== undefined && map.get("onlyChatBanned") !== null) {
    memberQueryOption.onlyChatBanned = map.get("onlyChatBanned") as boolean;
  }

  // 处理在线用户过滤
  if (map.get("onlyOnline") !== undefined && map.get("onlyOnline") !== null) {
    memberQueryOption.onlyOnline = map.get("onlyOnline") as boolean;
  }

  // 处理分页偏移量
  if (map.get("pageToken") !== undefined && map.get("pageToken") !== null) {
    memberQueryOption.pageToken = map.get("pageToken") as string;
  }

  // 处理分页大小
  if (map.get("limit") !== undefined && map.get("limit") !== null) {
    memberQueryOption.limit = map.get("limit") as number;
  }

  return memberQueryOption;
}

/**
 * 转换为聊天室标签消息查询选项
 * @param map 包含查询参数的Map
 * @returns 类型安全的V2NIMChatroomTagMessageOption对象
 */
export function convertToTagMessageOption(map: Map<string, Any>): V2NIMChatroomTagMessageOption {
  const option: V2NIMChatroomTagMessageOption = {
    tags: undefined,
    messageTypes: undefined,
    beginTime: undefined,
    endTime: undefined,
    limit: undefined,
    direction: undefined
  };

  if (map.get("tags") !== undefined && map.get("tags") !== null) {
    option.tags = map.get("tags") as string[];
  }

  if (map.get("messageTypes") !== undefined && map.get("messageTypes") !== null) {
    option.messageTypes = map.get("messageTypes") as V2NIMMessageType[];
  }

  if (map.get("beginTime") !== undefined && map.get("beginTime") !== null) {
    option.beginTime = map.get("beginTime") as number;
  }

  if (map.get("endTime") !== undefined && map.get("endTime") !== null) {
    option.endTime = map.get("endTime") as number;
  }

  if (map.get("limit") !== undefined && map.get("limit") !== null) {
    option.limit = map.get("limit") as number;
  }

  if (map.get("direction") !== undefined && map.get("direction") !== null) {
    option.direction = map.get("direction") as V2NIMQueryDirection;
  }

  return option;
}

/**
 * 转换为聊天室成员角色更新参数
 * @param map 包含更新参数的Map
 * @returns 类型安全的V2NIMChatroomMemberRoleUpdateParams对象
 */
export function convertToMemberRoleUpdateParams(map: Map<string, Any>): V2NIMChatroomMemberRoleUpdateParams {
  const params: V2NIMChatroomMemberRoleUpdateParams = {
    memberRole: V2NIMChatroomMemberRole.V2NIM_CHATROOM_MEMBER_ROLE_NORMAL
  };

  if (map.get("memberRole") !== undefined && map.get("memberRole") !== null) {
    params.memberRole = map.get("memberRole") as V2NIMChatroomMemberRole;
  }

  if (map.get("memberLevel") !== undefined && map.get("memberLevel") !== null) {
    params.memberLevel = map.get("memberLevel") as number;
  }

  if (map.get("notificationExtension") !== undefined && map.get("notificationExtension") !== null) {
    params.notificationExtension = map.get("notificationExtension") as string;
  }

  return params;
}

/**
 * 转换为聊天室自身成员信息更新参数
 * @param map 包含更新参数的Map
 * @returns 类型安全的V2NIMChatroomSelfMemberUpdateParams对象
 */
export function convertToSelfMemberUpdateParams(map: Map<string, Any>): V2NIMChatroomSelfMemberUpdateParams {
  const params: V2NIMChatroomSelfMemberUpdateParams = {
    roomNick: undefined,
    roomAvatar: undefined,
    serverExtension: undefined,
    notificationEnabled: undefined,
    notificationExtension: undefined,
    persistence: undefined
  };

  if (map.get("roomNick") !== undefined && map.get("roomNick") !== null) {
    params.roomNick = map.get("roomNick") as string;
  }

  if (map.get("roomAvatar") !== undefined && map.get("roomAvatar") !== null) {
    params.roomAvatar = map.get("roomAvatar") as string;
  }

  if (map.get("serverExtension") !== undefined && map.get("serverExtension") !== null) {
    params.serverExtension = map.get("serverExtension") as string;
  }

  if (map.get("notificationEnabled") !== undefined && map.get("notificationEnabled") !== null) {
    params.notificationEnabled = map.get("notificationEnabled") as boolean;
  }

  if (map.get("notificationExtension") !== undefined && map.get("notificationExtension") !== null) {
    params.notificationExtension = map.get("notificationExtension") as string;
  }

  if (map.get("persistence") !== undefined && map.get("persistence") !== null) {
    params.persistence = map.get("persistence") as boolean;
  }

  return params;
}

/**
 * 转换为聊天室标签成员查询选项
 * @param map 包含查询参数的Map
 * @returns 类型安全的V2NIMChatroomTagMemberOption对象
 */
export function convertToTagMemberOption(map: Map<string, Any>): V2NIMChatroomTagMemberOption {
  const option: V2NIMChatroomTagMemberOption = {
    tag: '',
    pageToken: undefined,
    limit: undefined
  };

  if (map.get("tag") !== undefined && map.get("tag") !== null) {
    option.tag = map.get("tag") as string;
  }

  if (map.get("pageToken") !== undefined && map.get("pageToken") !== null) {
    option.pageToken = map.get("pageToken") as string;
  }

  if (map.get("limit") !== undefined && map.get("limit") !== null) {
    option.limit = map.get("limit") as number;
  }

  return option;
}

/**
 * 转换为聊天室标签临时禁言参数
 * @param map 包含禁言参数的Map
 * @returns 类型安全的V2NIMChatroomTagTempChatBannedParams对象
 */
export function convertToTagTempChatBannedParams(map: Map<string, Any>): V2NIMChatroomTagTempChatBannedParams {
  // 显式初始化所有可选属性为undefined，匹配接口定义
  const params: V2NIMChatroomTagTempChatBannedParams = {
    targetTag: '',
    notifyTargetTags: undefined,
    duration: undefined,
    notificationEnabled: undefined,
    notificationExtension: undefined
  };

  // 处理目标标签
  if (map.get("targetTag") !== undefined && map.get("targetTag") !== null) {
    params.targetTag = map.get("targetTag") as string;
  }

  // 处理通知目标标签
  if (map.get("notifyTargetTags") !== undefined && map.get("notifyTargetTags") !== null) {
    params.notifyTargetTags = map.get("notifyTargetTags") as string;
  }

  // 处理禁言时长
  if (map.get("duration") !== undefined && map.get("duration") !== null) {
    params.duration = map.get("duration") as number;
  }

  // 处理是否启用通知
  if (map.get("notificationEnabled") !== undefined && map.get("notificationEnabled") !== null) {
    params.notificationEnabled = map.get("notificationEnabled") as boolean;
  }

  // 处理通知扩展字段
  if (map.get("notificationExtension") !== undefined && map.get("notificationExtension") !== null) {
    params.notificationExtension = map.get("notificationExtension") as string;
  }

  return params;
}

export function convertToMemberMap(member: V2NIMChatroomMember | undefined): Map<string, Any> {
  const map: Map<string, Any> = new Map<string, Any>();
  if (member === undefined || member === null) {
    map.set("multiEnterInfo", []);
    return map;
  }

  map.set("roomId", member.roomId);
  map.set("accountId", member.accountId);
  map.set("memberRole", member.memberRole);
  map.set("memberLevel", member.memberLevel);
  map.set("roomNick", member.roomNick);
  map.set("roomAvatar", member.roomAvatar);
  map.set("serverExtension", member.serverExtension);
  map.set("isOnline", member.isOnline);
  map.set("blocked", member.blocked);
  map.set("chatBanned", member.chatBanned);
  map.set("tempChatBanned", member.tempChatBanned);
  map.set("tempChatBannedDuration", member.tempChatBannedDuration);
  map.set("tags", member.tags);
  map.set("notifyTargetTags", member.notifyTargetTags);
  map.set("enterTime", member.enterTime);
  map.set("updateTime", member.updateTime);
  map.set("valid", member.valid);
  let enterInfo: Any[] = member.multiEnterInfo ? member.multiEnterInfo.map(info => convertObjectToMap(info)) : [];
  map.set("multiEnterInfo", enterInfo);
  return map;
}

export function convertToChatroomMessageMap(message: V2NIMChatroomMessage | undefined): Map<string, Any> {
  const map: Map<string, Any> = new Map<string, Any>();
  if (message === undefined || message === null) {
    return map;
  }

  map.set("messageClientId", message.messageClientId);
  map.set("senderClientType", message.senderClientType);
  map.set("createTime", message.createTime);
  map.set("senderId", message.senderId);
  map.set("roomId", message.roomId);
  map.set("isSelf", message.isSelf);
  map.set("attachmentUploadState", message.attachmentUploadState?.valueOf());
  map.set("sendingState", message.sendingState?.valueOf());
  map.set("messageType", message.messageType?.valueOf());
  map.set("subType", message.subType?.valueOf());
  map.set("text", message.text);
  map.set("attachment", convertChatroomAttachmentToMap(message.attachment, message.messageType));
  map.set("serverExtension", message.serverExtension);
  map.set("callbackExtension", message.callbackExtension);
  let messageConfig: Map<string, Any> | undefined = convertObjectToMapOrUndefined(message.messageConfig);
  if (messageConfig) {
    map.set("messageConfig", messageConfig);
  }
  let routeConfig: Map<string, Any> | undefined = convertObjectToMapOrUndefined(message.routeConfig);
  if (routeConfig) {
    map.set("routeConfig", routeConfig);
  }
  let antispamConfig: Map<string, Any> | undefined = convertObjectToMapOrUndefined(message.antispamConfig);
  if (antispamConfig) {
    map.set("antispamConfig", antispamConfig);
  }
  map.set("notifyTargetTags", message.notifyTargetTags);
  if (message.userInfoConfig) {
    map.set("userInfoConfig", convertUserInfoConfigToMap(message.userInfoConfig));
  }
  if (message.locationInfo) {
    map.set("locationInfo",  convertLocationInfoToMap(message.locationInfo));
  }
  return map;
}

export function convertChatroomAttachmentToMap(attachment?: V2NIMMessageAttachment,
  messageType?: V2NIMMessageType): Map<string, Any> | undefined {
  if (!attachment) {
    return undefined;
  }
  if (messageType == V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION) {
    let notiAttach = attachment as V2NIMChatroomNotificationAttachment
    return convertChatroomNotificationAttachment2Map(notiAttach)
  } else {
    return convertAttachmentToMap(attachment, messageType)
  }
}

export function convertChatroomNotificationAttachment2Map(result: V2NIMChatroomNotificationAttachment | undefined): Map<string, Any> {
  let resMap: Map<string, Any> = convertObjectToMap(result)
  resMap.set("nimCoreMessageType", V2NIMMessageType.V2NIM_MESSAGE_TYPE_NOTIFICATION)
  return resMap
}

export function convertToMemberListResultMap(result: V2NIMChatroomMemberListResult | undefined): Map<string, Any> {
  const map: Map<string, Any> = new Map<string, Any>();
  if (result === undefined || result === null) {
    map.set("memberList", []);
    return map;
  }

  map.set("pageToken", result.pageToken);
  map.set("finished", result.finished);
  const memberList: Any[] = result.memberList ? result.memberList.map(m => convertToMemberMap(m)) : [];
  map.set("memberList", memberList);
  return map;
}

export function convertToSendMessageResultMap(result: V2NIMSendChatroomMessageResult | undefined): Map<string, Any> {
  const map: Map<string, Any> = new Map<string, Any>();
  if (result === undefined || result === null) {
    return map;
  }

  map.set("message", convertToChatroomMessageMap(result.message));
  map.set("antispamResult", result.antispamResult);
  let clientAntispamResult: Map<string, Any> | undefined = convertObjectToMapOrUndefined(result.clientAntispamResult);
  if (clientAntispamResult) {
    map.set("clientAntispamResult", clientAntispamResult);
  }
  return map;
}

export function convertLocationInfoToMap(location: V2NIMLocationInfo | undefined): Map<string, Any> {
  return convertObjectToMap(location);
}

/**

 将 V2NIMUserInfoConfig 对象转换为 Map<string, Any>
 @param config 要转换的用户信息配置对象
 @returns 转换后的 Map 对象
 */
export function convertUserInfoConfigToMap (config: V2NIMUserInfoConfig): Map<string, Any> {
  const resultMap:Map<string, Any> = new Map<string, Any>();

  // 处理用户信息时间戳
  if (config.userInfoTimestamp !== undefined && config.userInfoTimestamp !== null) {
    resultMap.set ('userInfoTimestamp', config.userInfoTimestamp);
  }

  // 处理发送者昵称
  if (config.senderNick !== undefined && config.senderNick !== null) {
    resultMap.set ('senderNick', config.senderNick);
  }

  // 处理发送者头像
  if (config.senderAvatar !== undefined && config.senderAvatar !== null) {
    resultMap.set ('senderAvatar', config.senderAvatar);
  }

  // 处理发送者扩展字段
  if (config.senderExtension !== undefined && config.senderExtension !== null) {
    resultMap.set ('senderExtension', config.senderExtension);
  }

  return resultMap;
}
