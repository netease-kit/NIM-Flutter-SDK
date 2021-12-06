/*
 * Copyright (c) 2021 NetEase, Inc.  All rights reserved.
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file.
 */

import Foundation

class SafeMethodChannel {
    
    private var methodChannel: FlutterMethodChannel?
    private var mainQueue = DispatchQueue.main
    
    init(_ name: String, _ messenger: FlutterBinaryMessenger) {
        methodChannel = FlutterMethodChannel(name: name, binaryMessenger: messenger)
    }
    
    func getChannel() -> FlutterMethodChannel? {
        return methodChannel
    }
    
    func invokeMethod(_ method: String, _ arguments: Any?){
        weak var weakSelf = self
        performOnMainthod {
            weakSelf?.methodChannel?.invokeMethod(method, arguments: arguments)
        }
    }
    
    func invokeMethod(_ method: String, _ arguments: Any?, result: @escaping FlutterResult){
        weak var weakSelf = self
        performOnMainthod {
            weakSelf?.methodChannel?.invokeMethod(method, arguments: arguments, result: result)
        }
    }
    
    private func performOnMainthod(_ block: @escaping ()->(Void)){
        if Thread.current.isMainThread {
            block()
        }else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
