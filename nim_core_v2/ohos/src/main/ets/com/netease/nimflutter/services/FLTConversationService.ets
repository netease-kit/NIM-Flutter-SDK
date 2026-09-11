/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import {
  V2NIMConversation,
  V2NIMConversationFilter,
  V2NIMConversationOption,
  V2NIMConversationType,
  V2NIMConversationUpdate,
  V2NIMError
} from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { convertConversation2Map } from '../model/conversation/V2NIMConversation';
import { convertMap2ConversationFilter } from '../model/conversation/V2NIMConversationFilter';
import { convertConversationResult2Map } from '../model/conversation/V2NIMConversationResult';

export class FLTConversationService extends FLTService {
  get serviceName(): string {
    return "ConversationService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");

    this.nim.conversationService?.on("onSyncStarted", () => {
      Log.d(this.serviceName, "onSyncStarted")
      this.notifyEvent("onSyncStarted", new Map())
    });
    this.nim.conversationService?.on("onSyncFinished", () => {
      Log.d(this.serviceName, "onSyncFinished")
      this.notifyEvent("onSyncFinished", new Map())
    });
    this.nim.conversationService?.on("onSyncFailed", (error: V2NIMError) => {
      Log.d(this.serviceName, `onSyncFailed:${error}`)
      let resultMap = new Map<string, Object>()
      resultMap.set("code", error.code)
      resultMap.set("errorDetails", error.desc)
      this.notifyEvent("onSyncFailed", resultMap)
    });
    this.nim.conversationService?.on("onConversationCreated", (conversation: V2NIMConversation) => {
      Log.d(this.serviceName, `onConversationCreated: conversation:${conversation}`)
      this.notifyEvent("onConversationCreated", convertConversation2Map(conversation))
    });
    this.nim.conversationService?.on("onConversationDeleted", (conversationIds: string[]) => {
      Log.d(this.serviceName, `onConversationDeleted: conversationIds:${conversationIds}`)
      this.notifyEvent("onConversationDeleted", new Map<string, Object>().set("conversationIdList", conversationIds))
    });
    this.nim.conversationService?.on("onConversationChanged", (conversationList: V2NIMConversation[]) => {
      Log.d(this.serviceName, `onConversationChanged: conversationList:${conversationList}`)
      this.notifyEvent("onConversationChanged", new Map<string, Any>().set(
        "conversationList", conversationList.map((conversation) => convertConversation2Map(conversation))
      ))
    });
    this.nim.conversationService?.on("onTotalUnreadCountChanged", (unreadCount: number) => {
      Log.d(this.serviceName, `onTotalUnreadCountChanged: unreadCount:${unreadCount}`)
      this.notifyEvent("onTotalUnreadCountChanged", new Map<string, Object>().set("unreadCount", unreadCount))
    });
    this.nim.conversationService?.on("onUnreadCountChangedByFilter",
      (filter: V2NIMConversationFilter, unreadCount: number) => {
        Log.d(this.serviceName, `onUnreadCountChangedByFilter: filter:${filter}, unreadCount:${unreadCount}`)
        this.notifyEvent("onUnreadCountChangedByFilter",
          new Map<string, Object>().set("conversationFilter", filter).set("unreadCount", unreadCount))
      });
    this.nim.conversationService?.on("onConversationReadTimeUpdated", (conversationId: string, readTime: number) => {
      Log.d(this.serviceName, `onConversationReadTimeUpdated: conversationId:${conversationId}, readTime:${readTime}`)
      this.notifyEvent("onConversationReadTimeUpdated",
        new Map<string, Object>().set("conversationId", conversationId).set("readTime", readTime))
    });
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "getConversationList":
        this.getConversationList(args, result);
        break;
      case "getConversationListByOption":
        this.getConversationListByOption(args, result);
        break;
      case "getConversation":
        this.getConversation(args, result);
        break;
      case "getConversationListByIds":
        this.getConversationListByIds(args, result);
        break;
      case "createConversation":
        this.createConversation(args, result);
        break;
      case "deleteConversation":
        this.deleteConversation(args, result);
        break;
      case "deleteConversationListByIds":
        this.deleteConversationListByIds(args, result);
        break;
      case "stickTopConversation":
        this.stickTopConversation(args, result);
        break;
      case "updateConversation":
        this.updateConversation(args, result);
        break;
      case "updateConversationLocalExtension":
        this.updateConversationLocalExtension(args, result);
        break;
      case "getTotalUnreadCount":
        this.getTotalUnreadCount(args, result);
        break;
      case "getUnreadCountByIds":
        this.getUnreadCountByIds(args, result);
        break;
      case "getUnreadCountByFilter":
        this.getUnreadCountByFilter(args, result);
        break;
      case "clearTotalUnreadCount":
        this.clearTotalUnreadCount(args, result);
        break;
      case "clearUnreadCountByIds":
        this.clearUnreadCountByIds(args, result);
        break;
      case "clearUnreadCountByGroupId":
        this.clearUnreadCountByGroupId(args, result);
        break;
      case "clearUnreadCountByTypes":
        this.clearUnreadCountByTypes(args, result);
        break;
      case "subscribeUnreadCountByFilter":
        this.subscribeUnreadCountByFilter(args, result);
        break;
      case "unsubscribeUnreadCountByFilter":
        this.unsubscribeUnreadCountByFilter(args, result);
        break;
      case "markConversationRead":
        this.markConversationRead(args, result);
        break;
      case "getConversationReadTime":
        this.getConversationReadTime(args, result);
        break;
      case "getStickTopConversationList":
        this.getStickTopConversationList(args, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private getConversationList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getConversationList")

    let offset = argument.get("offset") ? argument.get("offset") as number : 0;
    let limit = argument.get("limit") ? argument.get("limit") as number : 0;

    this.nim.conversationService?.getConversationList(offset, limit).then((res) => {
      this.onSuccess(result, convertConversationResult2Map(res))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getConversationListByOption(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getConversationListByOption")

    let offset = argument.get("offset") ? argument.get("offset") as number : 0;
    let limit = argument.get("limit") ? argument.get("limit") as number : 0;

    let option: V2NIMConversationOption = {
      conversationTypes: undefined,
      onlyUnread: undefined,
      conversationGroupIds: undefined,
    }

    let optionMap: Map<String, Any> =
      argument.get("option") ? argument.get("option") as Map<String, Any> :
      new Map<String, Any>()
    if (optionMap.get("conversationTypes") !== undefined && optionMap.get("conversationTypes") !== null) {
      option.conversationTypes = optionMap.get("conversationTypes") as V2NIMConversationType[];
    }
    if (optionMap.get("onlyUnread") !== undefined && optionMap.get("onlyUnread") !== null) {
      option.onlyUnread = optionMap.get("onlyUnread") as boolean;
    }
    if (optionMap.get("conversationGroupIds") !== undefined && optionMap.get("conversationGroupIds") !== null) {
      option.conversationGroupIds = optionMap.get("conversationGroupIds") as string[];
    }

    this.nim.conversationService?.getConversationListByOption(offset, limit, option).then((res) => {
      this.onSuccess(result, convertConversationResult2Map(res))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getConversation(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getConversation")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";

    this.nim.conversationService?.getConversation(conversationId).then((conversation) => {
      this.onSuccess(result, convertConversation2Map(conversation))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getConversationListByIds(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getConversationListByIds")

    let conversationIds = argument.get("conversationIdList") ? argument.get("conversationIdList") as string[] : [];
    try {

      this.nim.conversationService?.getConversationListByIds(conversationIds).then((res) => {
        this.onSuccess(result, new Map<string, Any>().set("conversationList",
          res.map((conversation) => convertConversation2Map(conversation))))
      }).catch((error: V2NIMError) => this.onError(result, error))
    } catch (error) {
      this.onError(result, error)
    }
  }

  private createConversation(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createConversation")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";

    this.nim.conversationService?.createConversation(conversationId).then((conversation) => {
      this.onSuccess(result, convertConversation2Map(conversation))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private deleteConversation(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "deleteConversation")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";
    let clearMessage:boolean|undefined = undefined;
    if(argument.get("clearMessage") !== undefined && argument.get("clearMessage") !== null){
      clearMessage = argument.get("clearMessage") as boolean
    }

    this.nim.conversationService?.deleteConversation(conversationId, clearMessage).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private deleteConversationListByIds(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "deleteConversationListByIds")

    let conversationIds = argument.get("conversationIdList") ? argument.get("conversationIdList") as string[] : [];
    let clearMessage:boolean|undefined = undefined;
    if(argument.get("clearMessage") !== undefined && argument.get("clearMessage") !== null){
      clearMessage = argument.get("clearMessage") as boolean
    }

    try {


      this.nim.conversationService?.deleteConversationListByIds(conversationIds, clearMessage).then((res) => {
        this.onSuccess(result, new Map<string, Any>().set("conversationOperationResult", res))
      }).catch((error: V2NIMError) => this.onError(result, error))
    } catch (error) {
      this.onError(result, error)
    }
  }

  private stickTopConversation(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "stickTopConversation")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";
    let stickTop = argument.get("stickTop") ? argument.get("stickTop") as boolean : false;

    this.nim.conversationService?.stickTopConversation(conversationId, stickTop).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateConversation(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateConversation")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";

    let updateInfo: V2NIMConversationUpdate = {
      serverExtension: undefined,
    }

    let updateInfoMap: Map<String, Any> =
      argument.get("updateInfo") ? argument.get("updateInfo") as Map<String, Any> :
      new Map<String, Any>()
    if (updateInfoMap.get("serverExtension") !== undefined && updateInfoMap.get("serverExtension") !== null) {
      updateInfo.serverExtension = updateInfoMap.get("serverExtension") as string;
    }

    this.nim.conversationService?.updateConversation(conversationId, updateInfo).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateConversationLocalExtension(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateConversationLocalExtension")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";
    let localExtension = argument.get("localExtension") ? argument.get("localExtension") as string : "";

    this.nim.conversationService?.updateConversationLocalExtension(conversationId, localExtension).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTotalUnreadCount(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTotalUnreadCount")

    let count = this.nim.conversationService?.getTotalUnreadCount()
    this.onSuccess(result, count)
  }

  private getUnreadCountByIds(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getUnreadCountByIds")
    try {
      let conversationIds: string[] = [];
      if (argument.get("conversationIdList") !== undefined && argument.get("conversationIdList") !== null) {
        conversationIds = argument.get("conversationIdList") as string[]
      }

      this.nim.conversationService?.getUnreadCountByIds(conversationIds).then((count) => {
        this.onSuccess(result, count)
      }).catch((error: V2NIMError) => this.onError(result, error))
    } catch (error) {
      this.onError(result, error)
    }

  }

  private getUnreadCountByFilter(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getUnreadCountByFilter")

    let filter = convertMap2ConversationFilter(argument)

    try{
      this.nim.conversationService?.getUnreadCountByFilter(filter).then((count) => {
        this.onSuccess(result, count)
      }).catch((error: V2NIMError) => this.onError(result, error))
    } catch (error){
      this.onError(result,(error as V2NIMError));
    }

  }

  private clearTotalUnreadCount(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "clearTotalUnreadCount")

    this.nim.conversationService?.clearTotalUnreadCount().then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private clearUnreadCountByIds(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "clearUnreadCountByIds")

    let conversationIds = argument.get("conversationIdList") ? argument.get("conversationIdList") as string[] : [];

    try {
      this.nim.conversationService?.clearUnreadCountByIds(conversationIds).then((res) => {
        this.onSuccess(result, new Map<string, Any>().set("conversationOperationResult", res))
      }).catch((error: V2NIMError) => this.onError(result, error))
    } catch (error) {
      this.onError(result, error)
    }
  }

  private clearUnreadCountByGroupId(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "clearUnreadCountByGroupId")

    let groupId = argument.get("groupId") ? argument.get("groupId") as string : "";

    try {


      this.nim.conversationService?.clearUnreadCountByGroupId(groupId).then(() => {
        this.onSuccess(result, null)
      }).catch((error: V2NIMError) => this.onError(result, error))
    } catch (error) {
      this.onError(result, error)
    }
  }

  private clearUnreadCountByTypes(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "clearUnreadCountByTypes")

    let types =
      argument.get("conversationTypeList") ? argument.get("conversationTypeList") as V2NIMConversationType[] : [];

    this.nim.conversationService?.clearUnreadCountByTypes(types).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private subscribeUnreadCountByFilter(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "subscribeUnreadCountByFilter")

    let filter = convertMap2ConversationFilter(argument.get("filter") as Map<string, Any>)
    try {
      this.nim.conversationService?.subscribeUnreadCountByFilter(filter)
    } catch(error){
      this.onError(result,(error as V2NIMError));
    }

    this.onSuccess(result, null)
  }

  private unsubscribeUnreadCountByFilter(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "unsubscribeUnreadCountByFilter")

    let filter = convertMap2ConversationFilter(argument.get("filter") as Map<string, Any>)
    try{
      this.nim.conversationService?.unsubscribeUnreadCountByFilter(filter)
    } catch(error){
      this.onError(result,(error as V2NIMError));
    }

    this.onSuccess(result, null)
  }

  private markConversationRead(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "markConversationRead")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";

    this.nim.conversationService?.markConversationRead(conversationId).then((count) => {
      this.onSuccess(result, count)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getConversationReadTime(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getConversationReadTime")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";

    this.nim.conversationService?.getConversationReadTime(conversationId).then((time) => {
      this.onSuccess(result, time)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getStickTopConversationList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getStickTopConversationList")

    this.nim.conversationService?.getStickTopConversationList().then((res) => {
      this.onSuccess(result, new Map<string, Any>().set("conversationList",
        res.map((conversation) => convertConversation2Map(conversation))))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }
}