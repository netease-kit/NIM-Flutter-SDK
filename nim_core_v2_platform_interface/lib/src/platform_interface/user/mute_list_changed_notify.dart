// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class NIMMuteListChangedNotify {
  final String account;
  final bool mute;

  NIMMuteListChangedNotify({required this.account, required this.mute});

  factory NIMMuteListChangedNotify.fromMap(Map<String, dynamic> param) {
    return NIMMuteListChangedNotify(
        account: param['account'] as String, mute: param['mute'] as bool);
  }

  @override
  String toString() {
    return 'NIMMuteListChangedNotify{account: $account, mute: $mute}';
  }
}
