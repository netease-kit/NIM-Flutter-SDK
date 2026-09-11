/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import {
  V2NIMClearHistoryNotification,
  V2NIMError,
  V2NIMMessage,
  V2NIMMessageDeletedNotification,
  V2NIMMessagePinNotification,
  V2NIMMessageQuickCommentNotification,
  V2NIMMessageRevokeNotification,
  V2NIMP2PMessageReadReceipt,
  V2NIMTeamMessageReadReceipt
} from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { convertMap2AddCollectionParams } from '../model/message/V2NIMAddCollectionParams';
import { convertMap2ClearHistoryMessageOption } from '../model/message/V2NIMClearHistoryMessageOption';
import { convertMap2CloudMessageListOption } from '../model/message/V2NIMCloudMessageListOption';
import { convertMap2Collection } from '../model/message/V2NIMCollection';
import { convertMap2CollectionOption } from '../model/message/V2NIMCollectionOption';
import { convertMap2Message, convertMessage2Map } from '../model/message/V2NIMMessage';
import { convertMap2MessageAIRegenParams } from '../model/message/V2NIMMessageAIRegenParams';
import { convertMap2MessageAIStreamStopParams } from '../model/message/V2NIMMessageAIStreamStopParams';
import { convertMap2MessageListOption } from '../model/message/V2NIMMessageListOption';
import { convertMessageListResult2Map } from '../model/message/V2NIMMessageListResult';
import { convertMap2MessageQuickCommentPushConfig } from '../model/message/V2NIMMessageQuickCommentPushConfig';
import { convertMap2MessageRefer } from '../model/message/V2NIMMessageRefer';
import { convertMap2MessageRevokeParams } from '../model/message/V2NIMMessageRevokeParams';
import { convertMap2MessageSearchExParams } from '../model/message/V2NIMMessageSearchExParams';
import { convertMessageSearchItem2Map } from '../model/message/V2NIMMessageSearchItem';
import { convertMap2MessageSearchParams } from '../model/message/V2NIMMessageSearchParams';
import { convertMap2ModifyMessageParams } from '../model/message/V2NIMModifyMessageParams';
import { convertMap2SendMessageParams } from '../model/message/V2NIMSendMessageParams';
import { convertMap2ThreadMessageListOption } from '../model/message/V2NIMThreadMessageListOption';
import { convertMap2UpdateLocalMessageParams } from '../model/message/V2NIMUpdateLocalMessageParams';
import { convertMap2VoiceToTextParams } from '../model/message/V2NIMVoiceToTextParams';

export class FLTMessageService extends FLTService {
  get serviceName(): string {
    return "MessageService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");

    this.nim.messageService?.on("onSendMessage", (message: V2NIMMessage) => {
      Log.d(this.serviceName, `onSendMessage:${message}`)
      this.notifyEvent("onSendMessage", convertMessage2Map(message))
    });
    this.nim.messageService?.on("onReceiveMessages", (messages: V2NIMMessage[]) => {
      Log.d(this.serviceName, `onReceiveMessages:${messages}`)
      this.notifyEvent("onReceiveMessages",
        new Map<string, Any>().set("messages", messages.map((message) => convertMessage2Map(message))))
    });
    this.nim.messageService?.on("onReceiveP2PMessageReadReceipts", (readReceipts: V2NIMP2PMessageReadReceipt[]) => {
      Log.d(this.serviceName, `onReceiveP2PMessageReadReceipts:${readReceipts}`)
      this.notifyEvent("onReceiveP2PMessageReadReceipts",
        new Map<string, Any>().set("p2pMessageReadReceipts", readReceipts))
    });
    this.nim.messageService?.on("onReceiveTeamMessageReadReceipts", (readReceipts: V2NIMTeamMessageReadReceipt[]) => {
      Log.d(this.serviceName, `onReceiveTeamMessageReadReceipts:${readReceipts}`)
      this.notifyEvent("onReceiveTeamMessageReadReceipts",
        new Map<string, Any>().set("teamMessageReadReceipts", readReceipts))
    });
    this.nim.messageService?.on("onMessageRevokeNotifications", (notification: V2NIMMessageRevokeNotification[]) => {
      Log.d(this.serviceName, `onMessageRevokeNotifications:${notification}`)
      this.notifyEvent("onMessageRevokeNotifications", new Map<string, Any>().set("revokeNotifications", notification))
    });
    this.nim.messageService?.on("onMessageDeletedNotifications", (notification: V2NIMMessageDeletedNotification[]) => {
      Log.d(this.serviceName, `onMessageDeletedNotifications:${notification}`)
      this.notifyEvent("onMessageDeletedNotifications",
        new Map<string, Any>().set("deletedNotifications", notification))
    });
    this.nim.messageService?.on("onClearHistoryNotifications", (notification: V2NIMClearHistoryNotification[]) => {
      Log.d(this.serviceName, `onClearHistoryNotifications:${notification}`)
      this.notifyEvent("onClearHistoryNotifications",
        new Map<string, Any>().set("clearHistoryNotifications", notification))
    });
    this.nim.messageService?.on("onMessagePinNotification", (notification: V2NIMMessagePinNotification) => {
      Log.d(this.serviceName, `onMessagePinNotification:${notification}`)
      this.notifyEvent("onMessagePinNotification", new Map(Object.entries(notification)))
    });
    this.nim.messageService?.on("onMessageQuickCommentNotification",
      (notification: V2NIMMessageQuickCommentNotification) => {
        Log.d(this.serviceName, `onMessageQuickCommentNotification:${notification}`)
        this.notifyEvent("onMessageQuickCommentNotification", new Map(Object.entries(notification)))
      });
    this.nim.messageService?.on("onReceiveMessagesModified", (messages: V2NIMMessage[]) => {
      Log.d(this.serviceName, `onReceiveMessagesModified:${messages}`)
      this.notifyEvent("onReceiveMessagesModified",
        new Map<string, Any>().set("messages", messages.map((message) => convertMessage2Map(message))))
    });
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "sendMessage":
        this.sendMessage(args, result)
        break
      case "replyMessage":
        this.replyMessage(args, result)
        break
      case "revokeMessage":
        this.revokeMessage(args, result)
        break
      case "getMessageList":
        this.getMessageList(args, result)
        break
      case "getMessageListEx":
        this.getMessageListEx(args, result)
        break
      case "getCloudMessageList":
        this.getCloudMessageList(args, result)
        break
      case "getMessageListByRefers":
        this.getMessageListByRefers(args, result)
        break
      case "getMessageListByIds":
        this.getMessageListByIds(args, result)
        break
      case "deleteMessage":
        this.deleteMessage(args, result)
        break
      case "deleteMessages":
        this.deleteMessages(args, result)
        break
      case "clearHistoryMessage":
        this.clearHistoryMessage(args, result)
        break
      case "updateMessageLocalExtension":
        this.updateMessageLocalExtension(args, result)
        break
      case "insertMessageToLocal":
        this.insertMessageToLocal(args, result)
        break
      case "pinMessage":
        this.pinMessage(args, result)
        break
      case "unpinMessage":
        this.unpinMessage(args, result)
        break
      case "updatePinMessage":
        this.updatePinMessage(args, result)
        break
      case "getPinnedMessageList":
        this.getPinnedMessageList(args, result)
        break
      case "addQuickComment":
        this.addQuickComment(args, result)
        break
      case "removeQuickComment":
        this.removeQuickComment(args, result)
        break
      case "getQuickCommentList":
        this.getQuickCommentList(args, result)
        break
      case "addCollection":
        this.addCollection(args, result)
        break
      case "removeCollections":
        this.removeCollections(args, result)
        break
      case "updateCollectionExtension":
        this.updateCollectionExtension(args, result)
        break
      case "getCollectionListByOption":
        this.getCollectionListByOption(args, result)
        break
      case "sendP2PMessageReceipt":
        this.sendP2PMessageReceipt(args, result)
        break
      case "getP2PMessageReceipt":
        this.getP2PMessageReceipt(args, result)
        break
      case "isPeerRead":
        this.isPeerRead(args, result)
        break
      case "sendTeamMessageReceipts":
        this.sendTeamMessageReceipts(args, result)
        break
      case "getTeamMessageReceipts":
        this.getTeamMessageReceipts(args, result)
        break
      case "getTeamMessageReceiptDetail":
        this.getTeamMessageReceiptDetail(args, result)
        break
      case "voiceToText":
        this.voiceToText(args, result)
        break
      case "cancelMessageAttachmentUpload":
        this.cancelMessageAttachmentUpload(args, result)
        break
      case "searchCloudMessages":
        this.searchCloudMessages(args, result)
        break
      case "getThreadMessageList":
        this.getThreadMessageList(args, result)
        break
      case "getLocalThreadMessageList":
        this.getLocalThreadMessageList(args, result)
        break
      case "modifyMessage":
        this.modifyMessage(args, result)
        break
      case "searchLocalMessages":
        this.searchLocalMessages(args, result)
        break
      case "searchCloudMessagesEx":
        this.searchCloudMessagesEx(args, result)
        break
      case "stopAIStreamMessage":
        this.stopAIStreamMessage(args, result)
        break
      case "regenAIMessage":
        this.regenAIMessage(args, result)
        break
      case "updateLocalMessage":
        this.updateLocalMessage(args, result)
        break
      case "clearRoamingMessage":
        this.clearRoamingMessage(args, result)
        break
      case "messageSerialization":
        this.messageSerialization(args, result)
        break
      case "messageDeserialization":
        this.messageDeserialization(args, result)
        break

      default:
        result.notImplemented();
        break;
    }
  }

  private sendMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "sendMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : ""
    let params = argument.get("params") ? convertMap2SendMessageParams(argument.get("params") as Map<string, Any>) : undefined

    this.nim.messageService?.sendMessage(message, conversationId, params, (percentage: number) => {
      this.notifyEvent("onSendMessageProgress",
        new Map<string, Any>().set("messageClientId", message.messageClientId).set("progress", percentage*100))
    }).then((res) => {
      this.onSuccess(result, new Map<string, Any>(Object.entries(res)).set("message", convertMessage2Map(res.message)))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private replyMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "replyMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let replyMessage = convertMap2Message(argument.get("replyMessage") as Map<string, Any>)
    let params = argument.get("params") ? convertMap2SendMessageParams(argument.get("params") as Map<string, Any>) : undefined

    this.nim.messageService?.replyMessage(message, replyMessage, params, (percentage: number) => {
      this.notifyEvent("onSendMessageProgress",
        new Map<string, Any>().set("messageClientId", message.messageClientId).set("progress", percentage))
    }).then((res) => {
      this.onSuccess(result, new Map<string, Any>(Object.entries(res)).set("message", convertMessage2Map(res.message)))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private revokeMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "revokeMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let params =
      argument.get("revokeParams") ? convertMap2MessageRevokeParams(argument.get("revokeParams") as Map<string, Any>) : undefined

    this.nim.messageService?.revokeMessage(message, params).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getMessageList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getMessageList")

    let option =
      argument.get("option") ? convertMap2MessageListOption(argument.get("option") as Map<string, Any>) : undefined

    this.nim.messageService?.getMessageList(option).then((messages) => {
      this.onSuccess(result,
        new Map<string, Any>().set("messages", messages.map((message) => convertMessage2Map(message))))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getMessageListEx(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getMessageListEx")

    let option =
      argument.get("option") ? convertMap2MessageListOption(argument.get("option") as Map<string, Any>) : undefined

    this.nim.messageService?.getMessageListEx(option).then((res) => {
      this.onSuccess(result, convertMessageListResult2Map(res))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getCloudMessageList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getCloudMessageList")

    let option =
      argument.get("option") ? convertMap2CloudMessageListOption(argument.get("option") as Map<string, Any>) : undefined

    this.nim.messageService?.getCloudMessageList(option).then((res) => {
      this.onSuccess(result, convertMessageListResult2Map(res))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getMessageListByRefers(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getMessageListByRefers")

    let messageRefers =
      (argument.get("messageRefers") as Map<string, Any>[]).map((messageRefer: Map<string, Any>) => convertMap2MessageRefer(messageRefer))

    this.nim.messageService?.getMessageListByRefers(messageRefers).then((messages) => {
      this.onSuccess(result,
        new Map<string, Any>().set("messages", messages.map((message) => convertMessage2Map(message))))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getMessageListByIds(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getMessageListByIds")

    let messageClientIds = argument.get("messageClientIds") ? argument.get("messageClientIds") as string[] : [];

    this.nim.messageService?.getMessageListByIds(messageClientIds).then((messages) => {
      this.onSuccess(result,
        new Map<string, Any>().set("messages", messages.map((message) => convertMessage2Map(message))))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private deleteMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "deleteMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined
    let onlyDeleteLocal:boolean|undefined = undefined;
    if(argument.get("onlyDeleteLocal") !== undefined && argument.get("onlyDeleteLocal") !== null){
      onlyDeleteLocal = argument.get("onlyDeleteLocal") as boolean
    }

    this.nim.messageService?.deleteMessage(message, serverExtension, onlyDeleteLocal).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private deleteMessages(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "deleteMessages")

    let messages =
      (argument.get("messages") as Map<string, Any>[]).map((message: Map<string, Any>) => convertMap2Message(message))
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined
    let onlyDeleteLocal:boolean|undefined = undefined;
    if(argument.get("onlyDeleteLocal") !== undefined && argument.get("onlyDeleteLocal") !== null){
      onlyDeleteLocal = argument.get("onlyDeleteLocal") as boolean
    }

    this.nim.messageService?.deleteMessages(messages, serverExtension, onlyDeleteLocal).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private clearHistoryMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "clearHistoryMessage")

    let option =
      argument.get("option") ? convertMap2ClearHistoryMessageOption(argument.get("option") as Map<string, Any>) :
        undefined

    this.nim.messageService?.clearHistoryMessage(option).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateMessageLocalExtension(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateMessageLocalExtension")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let localExtension = argument.get("localExtension") ? argument.get("localExtension") as string : ""

    this.nim.messageService?.updateMessageLocalExtension(message, localExtension).then((message) => {
      this.onSuccess(result, convertMessage2Map(message))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private insertMessageToLocal(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "insertMessageToLocal")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : ""
    let senderId = argument.get("senderId") ? argument.get("senderId") as string : undefined
    let createTime = argument.get("createTime") ? argument.get("createTime") as number : undefined

    this.nim.messageService?.insertMessageToLocal(message, conversationId, senderId, createTime).then((message) => {
      this.onSuccess(result, convertMessage2Map(message))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private pinMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "pinMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined

    this.nim.messageService?.pinMessage(message, serverExtension).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private unpinMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "unpinMessage")

    let messageRefer = convertMap2MessageRefer(argument.get("messageRefer") as Map<string, Any>)
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined

    this.nim.messageService?.unpinMessage(messageRefer, serverExtension).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updatePinMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updatePinMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined

    this.nim.messageService?.updatePinMessage(message, serverExtension).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getPinnedMessageList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getPinnedMessageList")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : ""

    this.nim.messageService?.getPinnedMessageList(conversationId).then((messagePins) => {
      this.onSuccess(result, new Map<string, Any>().set("pinMessages", messagePins))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private addQuickComment(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "addQuickComment")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let index = argument.get("index") ? argument.get("index") as number : 0
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined
    let pushConfig = argument.get("pushConfig") ?
    convertMap2MessageQuickCommentPushConfig(argument.get("pushConfig") as Map<string, Any>) : undefined

    this.nim.messageService?.addQuickComment(message, index, serverExtension, pushConfig).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private removeQuickComment(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "removeQuickComment")

    let messageRefer =
      argument.get("messageRefer") ? convertMap2MessageRefer(argument.get("messageRefer") as Map<string, Any>) :
        undefined
    let index = argument.get("index") ? argument.get("index") as number : 0
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined

    this.nim.messageService?.removeQuickComment(messageRefer, index, serverExtension).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getQuickCommentList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getQuickCommentList")

    let messages =
      (argument.get("messages") as Map<string, Any>[]).map((message: Map<string, Any>) => convertMap2Message(message))

    this.nim.messageService?.getQuickCommentList(messages).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private addCollection(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "addCollection")

    let params =
      argument.get("params") ? convertMap2AddCollectionParams(argument.get("params") as Map<string, Any>) : undefined

    this.nim.messageService?.addCollection(params).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private removeCollections(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "removeCollections")

    let collections =
      (argument.get("collections") as Map<string, Any>[]).map((collection: Map<string, Any>) => convertMap2Collection(collection))

    this.nim.messageService?.removeCollections(collections).then((count) => {
      this.onSuccess(result, count)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateCollectionExtension(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateCollectionExtension")

    let collection = convertMap2Collection(argument.get("collection") as Map<string, Any>)
    let serverExtension = argument.get("serverExtension") ? argument.get("serverExtension") as string : undefined

    this.nim.messageService?.updateCollectionExtension(collection, serverExtension).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getCollectionListByOption(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getCollectionListByOption")

    let option = convertMap2CollectionOption(argument.get("option") as Map<string, Any>)

    this.nim.messageService?.getCollectionListByOption(option).then((collections) => {
      this.onSuccess(result, new Map<string, Any>().set("collections", collections))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private sendP2PMessageReceipt(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "sendP2PMessageReceipt")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)

    this.nim.messageService?.sendP2PMessageReceipt(message).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getP2PMessageReceipt(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getP2PMessageReceipt")

    let conversationId = argument.get("conversationId") ? argument.get("conversationId") as string : "";

    this.nim.messageService?.getP2PMessageReceipt(conversationId).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private isPeerRead(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "isPeerRead")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)

    this.nim.messageService?.isPeerRead(message).then((read) => {
      this.onSuccess(result, read)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private sendTeamMessageReceipts(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "sendTeamMessageReceipts")

    let messages =
      (argument.get("messages") as Map<string, Any>[]).map((message: Map<string, Any>) => convertMap2Message(message))

    this.nim.messageService?.sendTeamMessageReceipts(messages).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamMessageReceipts(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamMessageReceipts")

    let messages =
      (argument.get("messages") as Map<string, Any>[]).map((message: Map<string, Any>) => convertMap2Message(message))

    this.nim.messageService?.getTeamMessageReceipts(messages).then((readReceipts) => {
      this.onSuccess(result, new Map<string, Any>().set("readReceipts", readReceipts))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getTeamMessageReceiptDetail(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getTeamMessageReceiptDetail")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let memberAccountIds = argument.get("memberAccountIds") ? argument.get("memberAccountIds") as string[] : undefined

    this.nim.messageService?.getTeamMessageReceiptDetail(message, memberAccountIds).then((res) => {
      this.onSuccess(result, res)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private voiceToText(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "voiceToText")

    let params = convertMap2VoiceToTextParams(argument.get("params") as Map<string, Any>)

    this.nim.messageService?.voiceToText(params).then((text) => {
      this.onSuccess(result, text)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private cancelMessageAttachmentUpload(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "cancelMessageAttachmentUpload")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)

    this.nim.messageService?.cancelMessageAttachmentUpload(message).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private searchCloudMessages(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "searchCloudMessages")

    let params = convertMap2MessageSearchParams(argument.get("params") as Map<string, Any>)

    this.nim.messageService?.searchCloudMessages(params).then((messages) => {
      this.onSuccess(result,
        new Map<string, Any>().set("messages", messages.map((message) => convertMessage2Map(message))))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getThreadMessageList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getThreadMessageList")

    let option = convertMap2ThreadMessageListOption(argument.get("option") as Map<string, Any>)

    this.nim.messageService?.getThreadMessageList(option).then((res) => {
      this.onSuccess(result, new Map<string, Any>(Object.entries(res))
        .set("message", convertMessage2Map(res.message))
        .set("replyList", res.replyList.map((message) => convertMessage2Map(message))))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private getLocalThreadMessageList(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "getLocalThreadMessageList")

    let message = convertMap2MessageRefer(argument.get("messageRefer") as Map<string, Any>)

    this.nim.messageService?.getLocalThreadMessageList(message).then((res) => {
      this.onSuccess(result, new Map<string, Any>(Object.entries(res)).set("message", convertMessage2Map(res.message)))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private modifyMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "modifyMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let params = convertMap2ModifyMessageParams(argument.get("params") as Map<string, Any>)

    this.nim.messageService?.modifyMessage(message, params).then((res) => {
      let resMap: Map<string, Any> = new Map<string, Any>(Object.entries(res))
      if (res.message) {
        resMap.set("message", convertMessage2Map(res.message))
      }
      this.onSuccess(result, resMap)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private searchLocalMessages(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "searchLocalMessages")

    let params = convertMap2MessageSearchExParams(argument.get("params") as Map<string, Any>)

    this.nim.messageService?.searchLocalMessages(params).then((res) => {
      this.onSuccess(result, new Map<string, Any>(Object.entries(res)).set("items",
        res.items.map((item) => convertMessageSearchItem2Map(item))))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private searchCloudMessagesEx(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "searchCloudMessagesEx")

    let params = convertMap2MessageSearchExParams(argument.get("params") as Map<string, Any>)

    this.nim.messageService?.searchCloudMessagesEx(params).then((res) => {
      this.onSuccess(result, new Map<string, Any>(Object.entries(res)).set("items",
        res.items.map((item) => convertMessageSearchItem2Map(item))))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private stopAIStreamMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "stopAIStreamMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let params = convertMap2MessageAIStreamStopParams(argument.get("params") as Map<string, Any>)

    this.nim.messageService?.stopAIStreamMessage(message, params).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private regenAIMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "regenAIMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let params = convertMap2MessageAIRegenParams(argument.get("params") as Map<string, Any>)

    this.nim.messageService?.regenAIMessage(message, params).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private updateLocalMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "updateLocalMessage")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)
    let params = convertMap2UpdateLocalMessageParams(argument.get("params") as Map<string, Any>)

    this.nim.messageService?.updateLocalMessage(message, params).then((message) => {
      this.onSuccess(result, convertMessage2Map(message))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private clearRoamingMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "clearRoamingMessage")

    let conversationIds = argument.get("conversationIds") ? argument.get("conversationIds") as string[] : [];

    this.nim.messageService?.clearRoamingMessage(conversationIds).then(() => {
      this.onSuccess(result, null)
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private messageSerialization(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "messageSerialization")

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)

    const res = this.nim.messageConverter?.messageSerialization(message)
    this.onSuccess(result, res)
  }

  private messageDeserialization(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "messageDeserialization")

    let messageStr = argument.get("msg") ? argument.get("msg") as string : "";

    const message = this.nim.messageConverter?.messageDeserialization(messageStr)
    if (message) {
      this.onSuccess(result, convertMessage2Map(message))
    } else {
      this.onErrorWithCode(result, 199414, "message deserialization failed")
    }
  }
}