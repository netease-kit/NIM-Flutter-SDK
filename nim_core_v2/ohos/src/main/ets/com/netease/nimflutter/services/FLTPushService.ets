/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { V2NIMError } from '@nimsdk/base';
import { Any, MethodResult } from '@ohos/flutter_ohos';
import { FLTService } from '../FLTService';

export class FLTPushService extends FLTService {
  get serviceName(): string {
    return "PushService";
  }

  onMethodCall(method: string, args: Map<string, Any>, result: MethodResult): void {
    switch (method) {
      case "enable":
        this.enable(args, result);
        break;
      case "isEnable":
        this.isEnable(args, result);
        break;
    }
  }

  private enable(argument: Map<string, Any>, result: MethodResult): void {
    const enable = argument.get("enable") as boolean;
    this.nim.pushService.enable(enable).then(() => {
      this.onSuccess(result);
    }).catch((e: V2NIMError) => {
      this.onError(result, e);
    });
  }

  private isEnable(argument: Map<string, Any>, result: MethodResult): void {
    this.nim.pushService.isEnable().then((enable: boolean) => {
      this.onSuccess(result, enable);
    }).catch((e: V2NIMError) => {
      this.onError(result, e);
    });
  }
}
