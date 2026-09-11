/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */
import { NIMInterface, V2NIMError } from '@nimsdk/base';
import { Any, Log, MethodResult } from '@ohos/flutter_ohos';
import { NimCore } from './NimCore';


export abstract class FLTService {
  constructor() {

  }

  protected get nim(): NIMInterface {
    return NimCore.getInstance().nimInterface;
  };

  abstract get serviceName(): string;

  abstract onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void;

  onInitialized(): void {

  };

  public notifyEvent(method: string, argument: Map<string, Any>, callback?: MethodResult): void {
    argument.set("serviceName", this.serviceName)
    NimCore.getInstance().channel?.invokeMethod(method, argument, callback)
  }

  public notifyEventPromise<T>(method: string, argument: Map<string, Any>): Promise<T> {
    return new Promise((resolve, reject) => {
      this.notifyEvent(method, argument,
        {
          success: (result: Any) => {
            Log.d(this.serviceName, "method success:" + result)
            resolve(result);
          },
          error: (errorCode: string, errorMessage: string, errorDetails: Any) => {
            Log.d(this.serviceName, "method error:" + errorCode + errorMessage)
            reject({ errorCode, errorMessage, errorDetails });
          },
          notImplemented: () => {
            Log.d(this.serviceName, "method notImplemented")
            reject("notImplemented");
          }
        });
    });
  }

  public onSuccess(result: MethodResult, object?: Any): void {
    result.success({
      code: 0,
      data: object,
    });
  }

  public onError(result: MethodResult, e: V2NIMError): void {
    let map = new Map<string, Object>();
    map.set("code", e.code);
    map.set("errorDetails", e.desc.toString())
    result.success(map);
  }

  public onErrorWithCode(result: MethodResult, code: number, desc: string): void {
    let map = new Map<string, Object>();
    map.set("code", code);
    map.set("errorDetails", desc.toString())
    result.success(map);
  }

  public nimErrorMap(error: V2NIMError): Map<string, Any> {
    let resultData: Map<string, Any> = new Map<string, Any>();
    resultData.set("code", error.code);
    resultData.set("desc", error.desc);
    if (error.detail) {
      let detail: Map<string, Any> = new Map<string, Any>();
      detail.set("reason", error.detail.reason);
      detail.set("rawData", error.detail.rawData);
      detail.set("timetag", error.detail.timetag);
      resultData.set("detail", detail);
    }
    return resultData;
  }
}