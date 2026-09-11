/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { V2NIMConversation, V2NIMConversationGroup, V2NIMError } from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { convertConversation2Map } from '../model/conversation/V2NIMConversation';

export class FLTConversationGroupService extends FLTService {
  get serviceName(): string {
    return "V2NIMConversationGroupService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");

    this.nim.conversationGroupService?.on("onConversationGroupCreated", (conversationGroup: V2NIMConversationGroup) => {
      Log.d(this.serviceName, "onConversationGroupCreated")
      this.notifyEvent("onConversationGroupCreated", new Map(Object.entries(conversationGroup)));
    });

    this.nim.conversationGroupService?.on("onConversationGroupDeleted", (groupId: string) => {
      Log.d(this.serviceName, "onConversationGroupDeleted")
      this.notifyEvent("onConversationGroupDeleted", new Map<string, Any>(
        [
          ["groupId", groupId]
        ]
      ));
    });

    this.nim.conversationGroupService?.on("onConversationGroupChanged", (conversationGroup: V2NIMConversationGroup) => {
      Log.d(this.serviceName, "onConversationGroupChanged")
      this.notifyEvent("onConversationGroupChanged", new Map(Object.entries(conversationGroup)));
    });

    this.nim.conversationGroupService?.on("onConversationsAddedToGroup", (groupId: string,
      list: V2NIMConversation[]) => {
      Log.d(this.serviceName, "onConversationsAddedToGroup")
      this.notifyEvent("onConversationsAddedToGroup", new Map<string, Any>(
        [
          ["groupId", groupId],
          ["conversations",list.map((conversation) => convertConversation2Map(conversation))]
        ]
      ));
    });

    this.nim.conversationGroupService?.on("onConversationsRemovedFromGroup", (groupId: string,
      list: string[]) => {
      Log.d(this.serviceName, "onConversationsRemovedFromGroup")
      this.notifyEvent("onConversationsRemovedFromGroup", new Map<string, Any>(
        [
          ["groupId", groupId],
          ["conversationIds",list]
        ]
      ));
    });

  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "createConversationGroup":
        this.createConversationGroup(args, result);
        break;
      case "deleteConversationGroup":
        this.deleteConversationGroup(args, result);
        break;
      case "updateConversationGroup":
        this.updateConversationGroup(args, result);
        break;
      case "addConversationsToGroup":
        this.addConversationsToGroup(args, result);
        break;
      case "removeConversationsFromGroup":
        this.removeConversationsFromGroup(args, result);
        break;
      case "getConversationGroup":
        this.getConversationGroup(args, result);
        break;
      case "getConversationGroupList":
        this.getConversationGroupList(args, result);
        break;
      case "getConversationGroupListByIds":
        this.getConversationGroupListByIds(args, result);
        break;
    }
  }

  private createConversationGroup(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createConversationGroup")

    let name = argument.get("name") as string;
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined;

    let conversationIds = argument.get("conversationIds") ? argument.get("conversationIds") as string[] : undefined;

    this.nim.conversationGroupService?.createConversationGroup(name, serverExtension, conversationIds).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private deleteConversationGroup(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "deleteConversationGroup")

    let groupId = argument.get("groupId") as string;

    this.nim.conversationGroupService?.deleteConversationGroup(groupId).then(() => {
      this.onSuccess(result)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateConversationGroup(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createConversationGroup")

    let groupId = argument.get("groupId") as string;

    let name = argument.get("name") ? argument.get("name") as string : undefined;
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined;


    this.nim.conversationGroupService?.updateConversationGroup(groupId, name, serverExtension).then(() => {
      this.onSuccess(result)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private addConversationsToGroup(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createConversationGroup")

    let groupId = argument.get("groupId") as string;

    let conversationIds = argument.get("conversationIds") ? argument.get("conversationIds") as string[] : [];

    this.nim.conversationGroupService?.addConversationsToGroup(groupId, conversationIds).then((opsRes) => {
      this.onSuccess(result, new Map<string, Any>().set("conversationOperationResults",
        opsRes))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private removeConversationsFromGroup(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createConversationGroup")

    let groupId = argument.get("groupId") as string;

    let conversationIds = argument.get("conversationIds") ? argument.get("conversationIds") as string[] : [];

    this.nim.conversationGroupService?.removeConversationsFromGroup(groupId, conversationIds).then((opsRes) => {
      this.onSuccess(result, new Map<string, Any>().set("conversationOperationResults",
        opsRes))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getConversationGroup(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getConversationGroup")

    let groupId = argument.get("groupId") as string;

    this.nim.conversationGroupService?.getConversationGroup(groupId).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getConversationGroupList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getConversationGroupList")


    this.nim.conversationGroupService?.getConversationGroupList().then((resList) => {
      this.onSuccess(result, new Map<string, Any>().set("conversationGroups",
        resList))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getConversationGroupListByIds(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getConversationGroupListByIds")

    let groupIds = argument.get("groupIds") as string[];

    this.nim.conversationGroupService?.getConversationGroupListByIds(groupIds).then((resList) => {
      this.onSuccess(result, new Map<string, Any>().set("conversationGroups",
        resList))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }
}