/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { V2NIMError, V2NIMMessageCustomAttachment } from '@nimsdk/base';
import { V2NIMChatroomClient, V2NIMChatroomMessage } from '@nimsdk/chatroom';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { convertToChatroomMessage, convertToChatroomMessageMap } from '../model/chatroom/ChatroomExtension';

export class FLTChatroomMessageCreatorService extends FLTService {
  private serviceNameTag: string = "V2NIMChatroomMessageCreator";

  get serviceName(): string {
    return this.serviceNameTag;
  }

  onInitialized(): void {
    Log.d(this.serviceName, "onInitialized");
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    Log.d(this.serviceName, `onMethodCall: ${method}`);
    switch (method) {
      case "createTextMessage":
        this.createTextMessage(args, result);
        break;
      case "createImageMessage":
        this.createImageMessage(args, result);
        break;
      case "createAudioMessage":
        this.createAudioMessage(args, result);
        break;
      case "createVideoMessage":
        this.createVideoMessage(args, result);
        break;
      case "createFileMessage":
        this.createFileMessage(args, result);
        break;
      case "createLocationMessage":
        this.createLocationMessage(args, result);
        break;
      case "createCustomMessage":
        this.createCustomMessage(args, result);
        break;
      case "createTipsMessage":
        this.createTipsMessage(args, result);
        break;
      case "createCustomMessageWithAttachment":
        this.createCustomMessageWithAttachment(args, result);
        break;
      case "createCustomMessageWithAttachmentAndSubType":
        this.createCustomMessageWithAttachmentAndSubType(args, result);
        break;
      case "createForwardMessage":
        this.createForwardMessage(args, result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private createTextMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const text = args.get("text") as string | undefined;
      const message: V2NIMChatroomMessage | undefined =
        V2NIMChatroomClient.getMessageCreator().createTextMessage(text);
      message.senderId = this.nim.loginService.getLoginUser()
      if (!message) {
        this.onErrorWithCode(result, -1, "create Message failed");
        return;
      }
      this.onSuccess(result, convertToChatroomMessageMap(message));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createImageMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const imagePath = args.get("imagePath") as string | undefined;
      const name = args.get("name") as string | undefined;
      const sceneName = args.get("sceneName") as string | undefined;
      const height = args.get("height") as number | undefined;
      const width = args.get("width") as number | undefined;

      V2NIMChatroomClient.getMessageCreator().createImageMessage(
        imagePath,
        name,
        sceneName,
        width,
        height
      ).then((message) => {
        message.senderId = this.nim.loginService.getLoginUser()
        this.onSuccess(result, convertToChatroomMessageMap(message));
      }).catch((e: V2NIMError) => this.onError(result, e))

    } catch (e) {
      this.onError(result, e);
    }
  }

  private createAudioMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const audioPath = args.get("audioPath") as string | undefined;
      const name = args.get("name") as string | undefined;
      const sceneName = args.get("sceneName") as string | undefined;
      const duration = args.get("duration") as number | 0;

      V2NIMChatroomClient.getMessageCreator().createAudioMessage(
        audioPath,
        name,
        sceneName,
        duration
      ).then((message) => {
        message.senderId = this.nim.loginService.getLoginUser()
        this.onSuccess(result, convertToChatroomMessageMap(message));
      }).catch((e: V2NIMError) => this.onError(result, e))
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createVideoMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const videoPath = args.get("videoPath") as string | undefined;
      const name = args.get("name") as string | undefined;
      const sceneName = args.get("sceneName") as string | undefined;
      const duration = args.get("duration") as number | 0;
      const height = args.get("height") as number | undefined;
      const width = args.get("width") as number | undefined;

      V2NIMChatroomClient.getMessageCreator().createVideoMessage(
        videoPath,
        name,
        sceneName,
        duration,
        width,
        height
      ).then((message) => {
        message.senderId = this.nim.loginService.getLoginUser()
        this.onSuccess(result, convertToChatroomMessageMap(message));
      }).catch((e: V2NIMError) => this.onError(result, e))

    } catch (e) {
      this.onError(result, e);
    }
  }

  private createFileMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const filePath = args.get("filePath") as string | undefined;
      const name = args.get("name") as string | undefined;
      const sceneName = args.get("sceneName") as string | undefined;

      V2NIMChatroomClient.getMessageCreator().createFileMessage(
        filePath,
        name,
        sceneName
      ).then((message) => {
        message.senderId = this.nim.loginService.getLoginUser()
        this.onSuccess(result, convertToChatroomMessageMap(message));
      }).catch((e: V2NIMError) => this.onError(result, e))
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createLocationMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const latitude = args.get("latitude") as number | 0.0;
      const longitude = args.get("longitude") as number | 0.0;
      const address = args.get("address") as string | undefined;

      const message: V2NIMChatroomMessage | undefined =
        V2NIMChatroomClient.getMessageCreator().createLocationMessage(
          latitude,
          longitude,
          address
        )
      if (!message) {
        this.onErrorWithCode(result, -1, "create Message failed");
        return;
      }
      message.senderId = this.nim.loginService.getLoginUser()
      this.onSuccess(result, convertToChatroomMessageMap(message));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createCustomMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const rawAttachment = args.get("rawAttachment") as string | undefined;
      const message: V2NIMChatroomMessage | undefined =
        V2NIMChatroomClient.getMessageCreator().createCustomMessage(rawAttachment);

      if (!message) {
        this.onErrorWithCode(result, -1, "create Message failed");
        return;
      }
      message.senderId = this.nim.loginService.getLoginUser()
      this.onSuccess(result, convertToChatroomMessageMap(message));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createTipsMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const text = args.get("text") as string | undefined;
      const message: V2NIMChatroomMessage | undefined =
        V2NIMChatroomClient.getMessageCreator().createTipsMessage(text);

      if (!message) {
        this.onErrorWithCode(result, -1, "create Message failed");
        return;
      }
      this.onSuccess(result, convertToChatroomMessageMap(message));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createCustomMessageWithAttachment(args: Map<string, Any>, result: MethodResult): void {
    try {
      const rawAttachment = args.get("rawAttachment") as string | "";
      const attachment: V2NIMMessageCustomAttachment = {
        raw: rawAttachment
      };
      const message: V2NIMChatroomMessage | undefined =
        V2NIMChatroomClient.getMessageCreator().createCustomMessageWithAttachment(attachment);

      if (!message) {
        this.onErrorWithCode(result, -1, "create Message failed");
        return;
      }
      message.senderId = this.nim.loginService.getLoginUser()
      this.onSuccess(result, convertToChatroomMessageMap(message));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createCustomMessageWithAttachmentAndSubType(args: Map<string, Any>, result: MethodResult): void {
    try {
      const rawAttachment = args.get("attachment") as string | "";
      const subType = args.get("subType") as number | 0;

      if (subType === undefined) {
        this.onErrorWithCode(result, -1, "create CustomMessageWithAttachmentAndType subtype is null");
        return;
      }

      const attachment: V2NIMMessageCustomAttachment = {
        raw: rawAttachment
      };
      const message: V2NIMChatroomMessage | undefined =
        V2NIMChatroomClient.getMessageCreator().createCustomMessageWithAttachment(attachment, subType);

      if (!message) {
        this.onErrorWithCode(result, -1, "create Message failed");
        return;
      }
      message.senderId = this.nim.loginService.getLoginUser()
      this.onSuccess(result, convertToChatroomMessageMap(message));
    } catch (e) {
      this.onError(result, e);
    }
  }

  private createForwardMessage(args: Map<string, Any>, result: MethodResult): void {
    try {
      const messageMap: Map<string, Any> | undefined = args.get("message") as Map<string, Any> | undefined;
      if (!messageMap) {
        this.onErrorWithCode(result, -1, "message is null");
        return;
      }

      // 假设存在将Map转换为V2NIMChatroomMessage的工具函数
      const message = convertToChatroomMessage(messageMap);
      const messageResult: V2NIMChatroomMessage | null | undefined =
        V2NIMChatroomClient.getMessageCreator().createForwardMessage(message);

      if (!messageResult) {
        this.onSuccess(result, {});
        return;
      }
      message.senderId = this.nim.loginService.getLoginUser()
      this.onSuccess(result, convertToChatroomMessageMap(messageResult));
    } catch (e) {
      this.onError(result, e);
    }
  }
}