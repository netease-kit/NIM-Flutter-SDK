// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import '../../../nim_core_platform_interface.dart';

class NIMQuickCommentOptionWrapper {
  final NIMMessageKey? key;
  final List<NIMQuickCommentOption>? quickCommentList;
  final bool? modify;
  final int? time;

  NIMQuickCommentOptionWrapper(
      {this.key, this.quickCommentList, this.modify, this.time});

  factory NIMQuickCommentOptionWrapper.fromMap(Map<String, dynamic> param) {
    return NIMQuickCommentOptionWrapper(
        key: NIMMessageKey.fromMap(
            Map<String, dynamic>.from(param['key'] as Map)),
        quickCommentList: (param['quickCommentList'] as List<dynamic>?)
            ?.map((e) => NIMQuickCommentOption.fromMap(
                Map<String, dynamic>.from(e as Map)))
            .toList(),
        modify: param['modify'] as bool?,
        time: param['time'] as int?);
  }
}

class NIMHandleQuickCommentOption {
  final NIMMessageKey? key;
  final NIMQuickCommentOption? commentOption;

  NIMHandleQuickCommentOption({this.key, this.commentOption});

  factory NIMHandleQuickCommentOption.fromMap(Map<String, dynamic> param) {
    return NIMHandleQuickCommentOption(
        key: NIMMessageKey.fromMap((param['key'] as Map).cast()),
        commentOption: NIMQuickCommentOption.fromMap(
            (param['commentOption'] as Map).cast()));
  }

  @override
  String toString() {
    return 'NIMHandleQuickCommentOption{key: $key, commentOption: $commentOption}';
  }
}

class NIMQuickCommentOption {
  final String? fromAccount;
  final int? replyType;
  final int? time;
  final String? ext;
  final bool? needPush;
  final bool? needBadge;
  final String? pushTitle;
  final String? pushContent;
  final Map<String, dynamic>? pushPayload;

  NIMQuickCommentOption(
      {this.fromAccount,
      this.replyType,
      this.time,
      this.ext,
      this.needPush,
      this.needBadge,
      this.pushTitle,
      this.pushContent,
      this.pushPayload});

  factory NIMQuickCommentOption.fromMap(Map<String, dynamic> param) {
    return NIMQuickCommentOption(
      fromAccount: param['fromAccount'] as String,
      replyType: param['replyType'] as int,
      time: param['time'] as int,
      ext: param['ext'] as String,
      needPush: param['needPush'] as bool?,
      needBadge: param['needBadge'] as bool?,
      pushTitle: param['pushTitle'] as String?,
      pushContent: param['pushContent'] as String?,
      pushPayload: (param['pushPayload'] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  String toString() {
    return 'NIMQuickCommentOption{fromAccount: $fromAccount, replyType: $replyType, time: $time, ext: $ext, needPush: $needPush, needBadge: $needBadge, pushTitle: $pushTitle, pushContent: $pushContent, pushPayload: $pushPayload}';
  }
}
