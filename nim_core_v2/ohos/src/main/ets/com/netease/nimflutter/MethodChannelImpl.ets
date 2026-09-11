/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import { MethodCall, MethodCallHandler, MethodResult } from '@ohos/flutter_ohos';
import { NimCore } from './NimCore';

export default class MethodChannelImpl implements MethodCallHandler {
  onMethodCall(call: MethodCall, result: MethodResult): void {
    NimCore.getInstance().onMethodCall(call, result);
  }
}
