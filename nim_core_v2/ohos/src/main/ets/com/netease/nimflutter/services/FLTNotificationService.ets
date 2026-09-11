/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import {
  V2NIMBroadcastNotification,
  V2NIMCustomNotification,
  V2NIMError, V2NIMUser, V2NIMUserSearchOption,
  V2NIMUserUpdateParams } from '@nimsdk/base';
import { V2NIMUserImpl } from '@nimsdk/user/src/main/ets/nim/services/model/V2NIMUserImpl';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';
import { convertMap2CustomNotificationParams } from '../model/notification/V2NIMSendCustomNotificationParams';

export class FLTNotificationService extends FLTService {
  get serviceName(): string {
    return "NotificationService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
    this.nim.notificationService?.on("onReceiveCustomNotifications", (customNotification: V2NIMCustomNotification[]) => {
      this.notifyEvent("onReceiveCustomNotifications", new Map<string, Any>().set(
        "customNotifications",customNotification.map(notify => {
         if(typeof notify.pushConfig?.forcePushAccountIds === 'string' ){
           notify.pushConfig.forcePushAccountIds = [notify.pushConfig?.forcePushAccountIds]
         }
        return notify;
      })
       )
      )
    });

    this.nim.notificationService?.on("onReceiveBroadcastNotifications", (broadcastNotification: V2NIMBroadcastNotification[]) => {
      this.notifyEvent("onReceiveBroadcastNotifications", new Map<string, Any>().set(
        "broadcastNotifications",broadcastNotification.map(notify => new Map(Object.entries(notify)))
      )
      )
    });
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "sendCustomNotification":
        this.sendCustomNotification(args, result)
        break;
    }
  }

  private sendCustomNotification(argument:Map<string, Any>, result: MethodResult){
    let conversationId = argument.get("conversationId") as string;
    let content = argument.get("content") as string;
    let paramsMap = argument.get("params") as Map<string,object>;
    this.nim.notificationService?.sendCustomNotification(conversationId,content,
      convertMap2CustomNotificationParams(paramsMap)).then(() => {
      this.onSuccess(result)
    })
    .catch((e: V2NIMError) => {
      this.onError(result, e)
    })
  }

  

}