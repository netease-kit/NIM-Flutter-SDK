// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class Log {
  static LogMixin? instance;

  static void v(String tag, String msg) {
    instance?.v(tag, msg);
  }

  static void d(String tag, String msg) {
    instance?.d(tag, msg);
  }

  static void i(String tag, String msg) {
    instance?.i(tag, msg);
  }

  static void w(String tag, String msg) {
    instance?.w(tag, msg);
  }

  static void e(String tag, String msg) {
    instance?.e(tag, msg);
  }
}

//log mixin
mixin LogMixin {
  void v(String tag, String msg) {}

  void d(String tag, String msg) {}

  void i(String tag, String msg) {}

  void w(String tag, String msg) {}

  void e(String tag, String msg) {}
}
