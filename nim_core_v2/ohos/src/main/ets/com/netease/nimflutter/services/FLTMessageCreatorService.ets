/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { V2NIMError } from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { convertMap2Message, convertMessage2Map } from '../model/message/V2NIMMessage';
import { convertMap2MessageCallDuration } from '../model/message/V2NIMMessageCallDuration';

export class FLTMessageCreatorService extends FLTService {
  get serviceName(): string {
    return "MessageCreatorService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "createTextMessage":
        this.createTextMessage(args, result)
        break
      case "createImageMessage":
        this.createImageMessage(args, result)
        break
      case "createAudioMessage":
        this.createAudioMessage(args, result)
        break
      case "createVideoMessage":
        this.createVideoMessage(args, result)
        break
      case "createFileMessage":
        this.createFileMessage(args, result)
        break
      case "createLocationMessage":
        this.createLocationMessage(args, result)
        break
      case "createCustomMessage":
        this.createCustomMessage(args, result)
        break
      case "createForwardMessage":
        this.createForwardMessage(args, result)
        break
      case "createTipsMessage":
        this.createTipsMessage(args, result)
        break
      case "createCallMessage":
        this.createCallMessage(args, result)
        break
    }
  }

  private onErrorWithParamError(result: MethodResult, desc: string): void {
    this.onErrorWithCode(result, 199414, desc);
  }

  private createTextMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createTextMessage")

    const text = argument.get("text") as string
    if (!text) {
      return this.onErrorWithParamError(result, "text is empty")
    }

    let message = this.nim.messageCreator.createTextMessage(text)
    this.onSuccess(result, convertMessage2Map(message))
  }

  private createImageMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createImageMessage")

    const imagePath = argument.get("imagePath") as string
    if (!imagePath) {
      return this.onErrorWithParamError(result, "imagePath is empty")
    }

    let name = argument.get("name") ? argument.get("name") as string : undefined
    let sceneName = argument.get("sceneName") ? argument.get("sceneName") as string : undefined
    let width = argument.get("width") ? argument.get("width") as number : undefined
    let height = argument.get("height") ? argument.get("height") as number : undefined

    this.nim.messageCreator.createImageMessage(imagePath, name, sceneName, width, height).then((message) => {
      this.onSuccess(result, convertMessage2Map(message))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private createAudioMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createAudioMessage")

    const audioPath = argument.get("audioPath") as string
    if (!audioPath) {
      return this.onErrorWithParamError(result, "audioPath is empty")
    }

    let name = argument.get("name") ? argument.get("name") as string : undefined
    let sceneName = argument.get("sceneName") ? argument.get("sceneName") as string : undefined
    let duration = argument.get("duration") ? argument.get("duration") as number : undefined

    this.nim.messageCreator.createAudioMessage(audioPath, name, sceneName, duration).then((message) => {
      this.onSuccess(result, convertMessage2Map(message))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private createVideoMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createVideoMessage")

    const videoPath = argument.get("videoPath") as string
    if (!videoPath) {
      return this.onErrorWithParamError(result, "videoPath is empty")
    }

    let name = argument.get("name") ? argument.get("name") as string : undefined
    let sceneName = argument.get("sceneName") ? argument.get("sceneName") as string : undefined
    let duration = argument.get("duration") ? argument.get("duration") as number : undefined
    let width = argument.get("width") ? argument.get("width") as number : undefined
    let height = argument.get("height") ? argument.get("height") as number : undefined

    this.nim.messageCreator.createVideoMessage(videoPath, name, sceneName, duration, width, height).then((message) => {
      this.onSuccess(result, convertMessage2Map(message))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private createFileMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createFileMessage")

    const filePath = argument.get("filePath") as string
    if (!filePath) {
      return this.onErrorWithParamError(result, "filePath is empty")
    }

    let name = argument.get("name") ? argument.get("name") as string : undefined
    let sceneName = argument.get("sceneName") ? argument.get("sceneName") as string : undefined

    this.nim.messageCreator.createFileMessage(filePath, name, sceneName).then((message) => {
      this.onSuccess(result, convertMessage2Map(message))
    }).catch((error: V2NIMError) => this.onError(result, error))
  }

  private createLocationMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createLocationMessage")

    const latitude = argument.get("latitude") as number
    const longitude = argument.get("longitude") as number
    const address = argument.get("address") as string
    if (!latitude || !longitude || !address) {
      return this.onErrorWithParamError(result, "latitude/latitude/address  is empty")
    }

    let message = this.nim.messageCreator.createLocationMessage(latitude, longitude, address)
    this.onSuccess(result, convertMessage2Map(message))
  }

  private createCustomMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createCustomMessage")

    const text = argument.get("text") as string
    const rawAttachment = argument.get("rawAttachment") as string

    try{
      let message = this.nim.messageCreator.createCustomMessage(text, rawAttachment)
      this.onSuccess(result, convertMessage2Map(message))
    }catch (e) {
      this.onError(result, e as V2NIMError)
    }
  }

  private createForwardMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createForwardMessage")

    if (argument.get("message") === undefined) {
      return this.onErrorWithParamError(result, "message is empty")
    }

    let message = convertMap2Message(argument.get("message") as Map<string, Any>)

    let forwardMessage = this.nim.messageCreator.createForwardMessage(message)
    if (forwardMessage) {
      this.onSuccess(result, convertMessage2Map(forwardMessage))
    } else {
      this.onErrorWithCode(result, 199414, "createForwardMessage failed");
    }
  }

  private createTipsMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createTipsMessage")

    const text = argument.get("text") as string

    let message = this.nim.messageCreator.createTipsMessage(text)
    this.onSuccess(result, convertMessage2Map(message))
  }

  private createCallMessage(argument: Map<string, Any>, result: MethodResult) {
    Log.d(this.serviceName, "createCallMessage")

    const type = argument.get("type") as number
    const channelId = argument.get("channelId") as string
    const status = argument.get("status") as number
    const durations =
      (argument.get("durations") as Map<string, Any>[]).map((duration: Map<string, Any>) => convertMap2MessageCallDuration(duration))
    if (!type || !channelId || !status || !durations) {
      return this.onErrorWithParamError(result, "type/channelId/status/durations is empty")
    }

    let text = argument.get("text") ? argument.get("text") as string : undefined
    let message = this.nim.messageCreator.createCallMessage(type, channelId, status, durations, text)
    this.onSuccess(result, convertMessage2Map(message))
  }
}