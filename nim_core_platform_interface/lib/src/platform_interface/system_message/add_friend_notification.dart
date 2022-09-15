// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

class AddFriendNotify {
  String? account;

  FriendEvent? event;

  String? msg;

  String? serverExt;

  AddFriendNotify(this.account, this.event, {this.msg, this.serverExt});
}

enum FriendEvent {
  ///对方直接加你为好友
  addFriendDirect,

  ///对方发起好友验证请求
  addFriendVerifyRequest,

  ///对方同意加你为好友
  agreeAddFriend,

  ///对方拒绝加你为好友
  rejectAddFriend,
}

FriendEvent? getEventFromInt(int val) {
  switch (val) {
    case 1:
      return FriendEvent.addFriendDirect;
    case 2:
      return FriendEvent.addFriendVerifyRequest;
    case 3:
      return FriendEvent.agreeAddFriend;
    case 4:
      return FriendEvent.rejectAddFriend;
  }
  return null;
}
