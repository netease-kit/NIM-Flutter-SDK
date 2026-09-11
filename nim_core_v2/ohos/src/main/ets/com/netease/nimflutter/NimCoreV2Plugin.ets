/*
 * Copyright (c) 2022 NetEase, Inc. All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import { FlutterPlugin, FlutterPluginBinding, MethodChannel, } from '@ohos/flutter_ohos';
import MethodChannelImpl from './MethodChannelImpl';
import { NimCore } from './NimCore';

/** NimCoreV2Plugin **/
export default class NimCoreV2Plugin implements FlutterPlugin {
  private channelName: string = 'flutter.yunxin.163.com/nim_core';
  private channel: MethodChannel | undefined = undefined;
  private channelHandler: MethodChannelImpl | undefined = undefined;

  constructor() {
  }

  getUniqueClassName(): string {
    return "NimCoreV2Plugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    Log.d('NimCoreV2Plugin', 'onAttachedToEngine local auth')
    this.channel = new MethodChannel(binding.getBinaryMessenger(), this.channelName);
    this.channelHandler = new MethodChannelImpl();
    NimCore.getInstance().initContext(binding.getApplicationContext(), this.channel)
    this.channel.setMethodCallHandler(this.channelHandler)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
      NimCore.getInstance().clear()
    }
  }
}
