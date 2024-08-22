// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

class SafeResult {
  var unsafeResult: FlutterResult?

  init(_ result: @escaping FlutterResult) {
    unsafeResult = result
  }

  func result(_ result: Any) {
    weak var weakSelf = self
    performOnMainthod {
      if let callback = weakSelf?.unsafeResult {
        callback(result)
      }
    }
  }

  func notImplemented() {
    weak var weakSelf = self
    performOnMainthod {
      if let callback = weakSelf?.unsafeResult {
        callback(FlutterMethodNotImplemented)
      }
    }
  }

  private func performOnMainthod(_ block: @escaping () -> Void) {
    if Thread.current.isMainThread {
      block()
    } else {
      DispatchQueue.main.async {
        block()
      }
    }
  }
}
