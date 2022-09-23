// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Flutter
import UIKit

public class SwiftNimCorePlugin: NSObject, FlutterPlugin {
  private var channel: MethodCallHandlerImpl?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftNimCorePlugin()
    instance.channel = MethodCallHandlerImpl()
    if let channel = instance.channel?.startListening(registrar).getChannel() {
      registrar.addMethodCallDelegate(instance, channel: channel)
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    channel?.onMethodCall(call, result)
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    channel?.stopListening()
    channel = nil
  }
}
