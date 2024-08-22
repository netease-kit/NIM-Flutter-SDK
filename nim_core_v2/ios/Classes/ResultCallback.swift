// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import Foundation

class ResultCallback {
  private var safeResult: SafeResult?
  init(_ result: @escaping FlutterResult) {
    safeResult = SafeResult(result)
  }

  func result(_ result: Any) {
    safeResult?.result(result)
  }

  func notImplemented() {
    safeResult?.notImplemented()
  }
}
