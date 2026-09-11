/*
 *
 *  * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 *  * Use of this source code is governed by a MIT license that can be
 *  * found in the LICENSE file.
 *
 *
 */

import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import {
  V2NIMChatroomClient,
  V2NIMChatroomMember,
  V2NIMChatroomMemberRole,
  V2NIMChatroomMessage,
  V2NIMChatroomService
} from '@nimsdk/chatroom';
import { FLTService } from '../FLTService';
import { V2NIMMessageCustomAttachmentParser } from '@nimsdk/base';
import { V2NIMChatroomInfo } from '@nimsdk/chatroom/Index';
import {
  convertToAntispamConfig,
  convertToChatroomMessage,
  convertToChatroomMessageMap,
  convertToChatroomTagsUpdateParams,
  convertToChatroomUpdateParams,
  convertObjectToMap,
  convertToLocationConfig,
  convertToMemberMap,
  convertToMemberListResultMap,
  convertToMemberQueryOption,
  convertToMemberRoleUpdateParams,
  convertToMessageListOption,
  convertToSelfMemberUpdateParams,
  convertToSendChatroomMessageParams,
  convertToSendMessageResultMap,
  convertToTagMemberOption,
  convertToTagMessageOption,
  convertToTagTempChatBannedParams
} from '../model/chatroom/ChatroomExtension';
import { FLTChatroomClientService } from './FLTChatroomClientService';

export class FLTChatroomService extends FLTService {
  private serviceNameTag: string = "V2NIMChatroomService";

  get serviceName(): string {
    return this.serviceNameTag;
  }

  onInitialized(): void {
    Log.d(this.serviceName, "onInitialized");
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, `onMethodCall: ${method}`);
    switch (method) {
      case "sendMessage":
        this.sendMessage(args, result);
        break;
      case "cancelMessageAttachmentUpload":
        this.cancelMessageAttachmentUpload(args, result);
        break;
      case "getMemberListByOption":
        this.getMemberListByOption(args, result);
        break;
      case "getMessageList":
        this.getMessageList(args, result);
        break;
      case "updateMemberRole":
        this.updateMemberRole(args, result);
        break;
      case "setMemberBlockedStatus":
        this.setMemberBlockedStatus(args, result);
        break;
      case "setMemberChatBannedStatus":
        this.setMemberChatBannedStatus(args, result);
        break;
      case "setMemberTempChatBanned":
        this.setMemberTempChatBanned(args, result);
        break;
      case "updateChatroomInfo":
        this.updateChatroomInfo(args, result);
        break;
      case "updateSelfMemberInfo":
        this.updateSelfMemberInfo(args, result);
        break;
      case "updateChatroomLocationInfo":
        this.updateChatroomLocationInfo(args, result);
        break;
      case "updateChatroomTags":
        this.updateChatroomTags(args, result);
        break;
      case "getMemberByIds":
        this.getMemberByIds(args, result);
        break;
      case "kickMember":
        this.kickMember(args, result);
        break;
      case "getMessageListByTag":
        this.getMessageListByTag(args, result);
        break;
      case "setTempChatBannedByTag":
        this.setTempChatBannedByTag(args, result);
        break;
      case "getMemberListByTag":
        this.getMemberListByTag(args, result);
        break;
      case "getMemberCountByTag":
        this.getMemberCountByTag(args, result);
        break;
      case "registerCustomAttachmentParser":
        this.registerCustomAttachmentParser(args, result);
        break;
      case "unregisterCustomAttachmentParser":
        this.unregisterCustomAttachmentParser(args, result);
        break;
      case "addChatroomListener":
        this.addChatroomListener(args, result);
        break;
      case "removeChatroomListener":
        this.removeChatroomListener(args, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private addChatroomListener(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid instanceId");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      this.createChatroomListener(instanceId, chatroomService);
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private removeChatroomListener(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid instanceId");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }
      this.offChatroomListener(chatroomService);
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private updateChatroomInfo(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const updateParamsMap: Map<string, Any> = args.get("updateParams") as Map<string, Any>;
      const antispamConfigMap: Map<string, Any> = args.get("antispamConfig") as Map<string, Any>;

      if (instanceId === undefined || !updateParamsMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const updateParams = convertToChatroomUpdateParams(updateParamsMap);
      const antispamConfig = antispamConfigMap ? convertToAntispamConfig(antispamConfigMap) : undefined;

      chatroomService.updateChatroomInfo(updateParams, antispamConfig)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private updateChatroomLocationInfo(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const locationConfigMap: Map<string, Any> = args.get("locationConfig") as Map<string, Any>;

      if (instanceId === undefined || !locationConfigMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const locationConfig = convertToLocationConfig(locationConfigMap);

      chatroomService.updateChatroomLocationInfo(locationConfig)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private updateChatroomTags(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const updateParamsMap: Map<string, Any> = args.get("updateParams") as Map<string, Any>;

      if (instanceId === undefined || !updateParamsMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const updateParams = convertToChatroomTagsUpdateParams(updateParamsMap);

      chatroomService.updateChatroomTags(updateParams)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private sendMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const messageMap: Map<string, Any> = args.get("message") as Map<string, Any>;
      const paramsMap: Map<string, Any> = args.get("params") as Map<string, Any>;

      if (instanceId === undefined || !messageMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const message: V2NIMChatroomMessage | undefined = convertToChatroomMessage(messageMap);
      const params = paramsMap ? convertToSendChatroomMessageParams(paramsMap) : undefined;
      const progress = (percentage: number) => {
        const progressMap: Map<string, Any> = new Map<string, Any>();
        progressMap.set("instanceId", instanceId);
        progressMap.set("percentage", percentage);
        progressMap.set("messageClientId", message.messageClientId);
        this.notifyEvent("onSendMessageProgress", progressMap);
      };
      let senderId = FLTChatroomClientService.accountId(instanceId)
      if (senderId && message) {
        message.senderId = senderId
      }

      chatroomService.sendMessage(message, params, progress)
        .then((sendResult) => this.onSuccess(result, convertToSendMessageResultMap(sendResult)))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private registerCustomAttachmentParser(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;

      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const parser: V2NIMMessageCustomAttachmentParser = (subType, raw) => {
        const parseMap: Map<string, Any> = new Map<string, Any>();
        parseMap.set("instanceId", instanceId);
        parseMap.set("subType", subType);
        parseMap.set("attachRaw", raw);
        this.notifyEvent("onCustomAttachmentParse", parseMap);
        return { raw: raw };
      };

      chatroomService.registerCustomAttachmentParser(parser);
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private unregisterCustomAttachmentParser(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const parserId: string = args.get("parserId") as string;

      if (instanceId === undefined || !parserId) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const parser = this.getParser(instanceId, parserId);
      if (parser) {
        chatroomService.unregisterCustomAttachmentParser(parser);
        this.removeParser(instanceId, parserId);
      }
      this.onSuccess(result, null);
    } catch (e) {
      this.onError(result, e);
    }
  }

  private cancelMessageAttachmentUpload(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const messageMap: Map<string, Any> = args.get("message") as Map<string, Any>;

      if (instanceId === undefined || !messageMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const message = convertToChatroomMessage(messageMap);

      chatroomService.cancelMessageAttachmentUpload(message)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getMessageList(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const optionMap: Map<string, Any> = args.get("option") as Map<string, Any>;

      if (instanceId === undefined || !optionMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const option = convertToMessageListOption(optionMap);

      chatroomService.getMessageList(option)
        .then((messages) => {
          const messageMaps: Any[] = messages ? messages.map(m => convertToChatroomMessageMap(m)) : [];
          this.onSuccess(result, new Map<string, Any>().set("messageList", messageMaps));
        })
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getMemberListByOption(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const optionMap: Map<string, Any> = args.get("queryOption") as Map<string, Any>;

      if (instanceId === undefined || !optionMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const option = convertToMemberQueryOption(optionMap);

      chatroomService.getMemberListByOption(option)
        .then((memberResult) => this.onSuccess(result, convertToMemberListResultMap(memberResult)))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getMessageListByTag(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const optionMap: Map<string, Any> = args.get("messageOption") as Map<string, Any>;

      if (instanceId === undefined || !optionMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const option = convertToTagMessageOption(optionMap);

      chatroomService.getMessageListByTag(option)
        .then((messages) => {
          const messageMaps: Any[] = messages ? messages.map(m => convertToChatroomMessageMap(m)) : [];
          this.onSuccess(result, new Map<string, Any>().set("messageList", messageMaps));
        })
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private updateMemberRole(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const accountId: string = args.get("accountId") as string;
      const updateParamsMap: Map<string, Any> = args.get("updateParams") as Map<string, Any>;

      if (instanceId === undefined || !accountId || !updateParamsMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }


      if (updateParamsMap.get("memberRole") == undefined || updateParamsMap.get("memberRole") == null) {
        this.onErrorWithCode(result, 191004, "Invalid chatroomService instanceId");
        return;
      }

      const updateParams = convertToMemberRoleUpdateParams(updateParamsMap);

      chatroomService.updateMemberRole(accountId, updateParams)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private setMemberBlockedStatus(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const accountId: string = args.get("accountId") as string;
      const blocked: boolean = args.get("blocked") as boolean;
      const notificationExtension: string = args.get("notificationExtension") as string;

      if (instanceId === undefined || blocked === undefined) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomService.setMemberBlockedStatus(accountId, blocked, notificationExtension)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private setMemberChatBannedStatus(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const accountId: string = args.get("accountId") as string;
      const chatBanned: boolean = args.get("chatBanned") as boolean;
      const notificationExtension: string = args.get("notificationExtension") as string;

      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomService.setMemberChatBannedStatus(accountId, chatBanned, notificationExtension)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private setMemberTempChatBanned(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const accountId: string = args.get("accountId") as string;
      const tempChatBannedDuration: number = args.get("tempChatBannedDuration") as number;
      const notificationEnabled: boolean = args.get("notificationEnabled") as boolean;
      const notificationExtension: string = args.get("notificationExtension") as string;

      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomService.setMemberTempChatBanned(accountId, tempChatBannedDuration, notificationEnabled,
        notificationExtension)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private updateSelfMemberInfo(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const updateParamsMap: Map<string, Any> = args.get("updateParams") as Map<string, Any>;
      const antispamConfigMap: Map<string, Any> = args.get("antispamConfig") as Map<string, Any>;

      if (instanceId === undefined || !updateParamsMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const updateParams = convertToSelfMemberUpdateParams(updateParamsMap);
      const antispamConfig = antispamConfigMap ? convertToAntispamConfig(antispamConfigMap) : undefined;

      chatroomService.updateSelfMemberInfo(updateParams, antispamConfig)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getMemberByIds(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const accountIds: string[] = args.get("accountIds") as string[];

      if (instanceId === undefined || !accountIds) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomService.getMemberByIds(accountIds)
        .then((members) => {
          const memberMaps: Any[] = members ? members.map(m => convertToMemberMap(m)) : [];
          this.onSuccess(result, new Map<string, Any>().set("memberList", memberMaps));
        })
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private kickMember(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const accountId: string = args.get("accountId") as string;
      const notificationExtension: string = args.get("notificationExtension") as string;

      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomService.kickMember(accountId, notificationExtension)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private setTempChatBannedByTag(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const paramsMap: Map<string, Any> = args.get("params") as Map<string, Any>;

      if (instanceId === undefined || !paramsMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const params = convertToTagTempChatBannedParams(paramsMap);

      chatroomService.setTempChatBannedByTag(params)
        .then(() => this.onSuccess(result, null))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getMemberListByTag(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const optionMap: Map<string, Any> = args.get("option") as Map<string, Any>;

      if (instanceId === undefined || !optionMap) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      const option = convertToTagMemberOption(optionMap);

      chatroomService.getMemberListByTag(option)
        .then((memberResult) => this.onSuccess(result, convertToMemberListResultMap(memberResult)))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private getMemberCountByTag(args: Map<string, Any>, result: MethodResult): void {
    try {
      const instanceId: number = args.get("instanceId") as number;
      const tag: string = args.get("tag") as string;

      if (instanceId === undefined) {
        this.onErrorWithCode(result, -1, "Invalid params");
        return;
      }

      const chatroomService = V2NIMChatroomClient.getInstance(instanceId)?.chatroomService;
      if (!chatroomService) {
        this.onErrorWithCode(result, -1, "Invalid chatroomService instanceId");
        return;
      }

      chatroomService.getMemberCountByTag(tag)
        .then((count) => this.onSuccess(result, new Map<string, Any>().set("memberCount", count)))
        .catch((error: Any) => this.onErrorWithCode(result, error.code || -1, error.desc));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createChatroomListener(instanceId: number, chatroomService: V2NIMChatroomService) {
    chatroomService.on("onSendMessage", (message: V2NIMChatroomMessage) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("message", convertToChatroomMessageMap(message));
      this.notifyEvent("onSendMessage", resultMap);
    });

    chatroomService.on("onReceiveMessages", (messages: V2NIMChatroomMessage[]) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      let messagesArray: Any[] = messages ? messages.map(m => convertToChatroomMessageMap(m)) : [];
      resultMap.set("instanceId", instanceId);
      resultMap.set("messages", messagesArray);
      this.notifyEvent("onReceiveMessages", resultMap);
    });

    chatroomService.on("onMessageRevokedNotification", (messageClientId: string, messageTime: number) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("messageClientId", messageClientId);
      resultMap.set("messageTime", messageTime);
      this.notifyEvent("onMessageRevokedNotification", resultMap);
    });

    chatroomService.on("onChatroomMemberEnter", (member: V2NIMChatroomMember) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("member", convertToMemberMap(member));
      this.notifyEvent("onChatroomMemberEnter", resultMap);
    });

    chatroomService.on("onChatroomMemberExit", (accountId: string) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("accountId", accountId);
      this.notifyEvent("onChatroomMemberExit", resultMap);
    });

    chatroomService.on("onChatroomMemberRoleUpdated",
      (previousRole: V2NIMChatroomMemberRole, currentMember: V2NIMChatroomMember) => {
        const resultMap: Map<string, Any> = new Map<string, Any>();
        resultMap.set("instanceId", instanceId);
        resultMap.set("previousRole", previousRole.valueOf());
        resultMap.set("member", convertToMemberMap(currentMember));
        this.notifyEvent("onChatroomMemberRoleUpdated", resultMap);
      });

    chatroomService.on("onChatroomMemberInfoUpdated", (member: V2NIMChatroomMember) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("member", convertToMemberMap(member));
      this.notifyEvent("onChatroomMemberInfoUpdated", resultMap);
    });

    chatroomService.on("onSelfChatBannedUpdated", (chatBanned: boolean) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("chatBanned", chatBanned);
      this.notifyEvent("onSelfChatBannedUpdated", resultMap);
    });

    chatroomService.on("onSelfTempChatBannedUpdated", (tempChatBanned: boolean, tempChatBannedDuration: number) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("tempChatBanned", tempChatBanned);
      resultMap.set("tempChatBannedDuration", tempChatBannedDuration);
      this.notifyEvent("onSelfTempChatBannedUpdated", resultMap);
    });

    chatroomService.on("onChatroomInfoUpdated", (chatroomInfo: V2NIMChatroomInfo) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("info", convertObjectToMap(chatroomInfo));
      this.notifyEvent("onChatroomInfoUpdated", resultMap);
    });

    chatroomService.on("onChatroomChatBannedUpdated", (chatBanned: boolean) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("chatBanned", chatBanned);
      this.notifyEvent("onChatroomChatBannedUpdated", resultMap);
    });

    chatroomService.on("onChatroomTagsUpdated", (tags: string[]) => {
      const resultMap: Map<string, Any> = new Map<string, Any>();
      resultMap.set("instanceId", instanceId);
      resultMap.set("tags", tags);
      this.notifyEvent("onChatroomTagsUpdated", resultMap);
    });
  }

  private offChatroomListener(chatroomService: V2NIMChatroomService) {
    chatroomService.off("onSendMessage", null);
    chatroomService.off("onReceiveMessages", null);
    chatroomService.off("onMessageRevokedNotification", null);
    chatroomService.off("onChatroomMemberEnter", null);
    chatroomService.off("onChatroomMemberExit", null);
    chatroomService.off("onChatroomMemberRoleUpdated", null);
    chatroomService.off("onChatroomMemberInfoUpdated", null);
    chatroomService.off("onSelfChatBannedUpdated", null);
    chatroomService.off("onSelfTempChatBannedUpdated", null);
    chatroomService.off("onChatroomInfoUpdated", null);
    chatroomService.off("onChatroomChatBannedUpdated", null);
    chatroomService.off("onChatroomTagsUpdated", null);
  }

  // 用于存储解析器引用的临时存储
  private parserMap = new Map<string, V2NIMMessageCustomAttachmentParser>();

  private setParser(instanceId: number, parserId: string, parser: V2NIMMessageCustomAttachmentParser) {
    this.parserMap.set(`${instanceId}-${parserId}`, parser);
  }

  private getParser(instanceId: number, parserId: string): V2NIMMessageCustomAttachmentParser | undefined {
    return this.parserMap.get(`${instanceId}-${parserId}`);
  }

  private removeParser(instanceId: number, parserId: string) {
    this.parserMap.delete(`${instanceId}-${parserId}`);
  }
}
