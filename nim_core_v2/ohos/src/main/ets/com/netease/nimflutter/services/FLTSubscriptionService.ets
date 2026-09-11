/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import {
  V2NIMCustomUserStatusParams,
  V2NIMError,
  V2NIMSubscribeUserStatusOption,
  V2NIMUnsubscribeUserStatusOption,
  V2NIMUserStatus} from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';

export class FLTSubscriptionService extends FLTService {
  get serviceName(): string {
    return "SubscriptionService";
  }

  onInitialized(): void {
    // notifyEvent
    Log.d(this.serviceName, "onInitialized");
    this.nim.subscriptionService?.on("onUserStatusChanged",(userStatusList: V2NIMUserStatus[]) => {
      this.notifyEvent("onUserStatusChanged", new Map<string, Any>().set(
        "userStatusList",userStatusList.map(status => new Map(Object.entries(status)))
      )
      )
    }
    );
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "subscribeUserStatus":
        this.subscribeUserStatus(args, result);
        break;
      case "unsubscribeUserStatus":
        this.unsubscribeUserStatus(args, result);
        break;
      case "publishCustomUserStatus":
        this.publishCustomUserStatus(args, result);
        break;
      case "queryUserStatusSubscriptions":
        this.queryUserStatusSubscriptions(args, result);
        break;
    }
  }

  private subscribeUserStatus(argument:Map<string, Any>, result: MethodResult){
    let optionMap = argument.get("option") as Map<string,string | number | boolean| undefined | null|[]>;
    let option:V2NIMSubscribeUserStatusOption = {
      accountIds: optionMap.get("accountIds") as string[]
    }
    if(optionMap.get("duration") !== undefined && optionMap.get("duration") !== null){
      option.duration = optionMap.get("duration") as number
    }
    if(optionMap.get("immediateSync") !== undefined && optionMap.get("immediateSync") !== null){
      option.immediateSync = optionMap.get("immediateSync") as boolean
    }

    this.nim.subscriptionService?.subscribeUserStatus(option).then((accountIds) => {
      this.onSuccess(result, {
           "accountIds": accountIds
         })
    })
    .catch((e: V2NIMError) => {
      this.onError(result, e)
    })
  }

  private unsubscribeUserStatus(argument:Map<string, Any>, result: MethodResult){
    let optionMap = argument.get("option") as Map<string,string | number | boolean| undefined | null|[]>;
    let option:V2NIMUnsubscribeUserStatusOption = {
      accountIds: optionMap.get("accountIds") as string[]
    }

    this.nim.subscriptionService?.unsubscribeUserStatus(option).then((accountIds) => {
      this.onSuccess(result, {
        "accountIds": accountIds
      })
    })
      .catch((e: V2NIMError) => {
        this.onError(result, e)
      })
  }
  
  private publishCustomUserStatus(argument:Map<string, Any>, result: MethodResult){
    let paramsMap = argument.get("params") as Map<string, string | number | boolean| undefined>;
    let params: V2NIMCustomUserStatusParams = {
      statusType: 0
    };
    if(paramsMap.get("statusType") !== undefined && paramsMap.get("statusType") !== null){
      params.statusType = paramsMap.get("statusType") as number;
    }

    if(paramsMap.get("duration") !== undefined && paramsMap.get("duration") !== null){
      params.duration = paramsMap.get("duration") as number;
    }

    if(paramsMap.get("extension") !== undefined && paramsMap.get("extension") !== null){
      params.extension = paramsMap.get("extension") as string;
    }

    if(paramsMap.get("onlineOnly") !== undefined && paramsMap.get("onlineOnly") !== null){
      params.onlineOnly = paramsMap.get("onlineOnly") as boolean;
    }


    if(paramsMap.get("multiSync") !== undefined && paramsMap.get("multiSync") !== null){
      params.multiSync = paramsMap.get("multiSync") as boolean;
    }

    this.nim.subscriptionService?.publishCustomUserStatus(params).then((publishResult) => {
      this.onSuccess(result,new Map(Object.entries(publishResult)))
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }

  private queryUserStatusSubscriptions(argument:Map<string, Any>, result: MethodResult){
    let accountIds = argument.get("accountIds") as string[];
    this.nim.subscriptionService?.queryUserStatusSubscriptions(accountIds).then((subscribeResultList) => {
      this.onSuccess(result,{
        "subscribeResultList":subscribeResultList.map(subscribeResult => new Map(Object.entries(subscribeResult)))
      })
    })
      .catch((e: V2NIMError) => this.onError(result, e))
  }
}