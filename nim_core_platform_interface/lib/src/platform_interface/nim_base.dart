// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// 消息内容类型
enum NIMMessageType {
  /// 未定义
  undef,

  /// 文本类型消息
  text,

  /// 图片类型消息
  image,

  /// 声音类型消息
  audio,

  /// 视频类型消息
  video,

  /// 位置类型消息
  location,

  /// 文件类型消息
  file,

  /// 音视频通话
  avchat,

  /// 通知类型消息
  notification,

  /// 提醒类型消息
  tip,

  /// Robot
  robot,

  /// G2话单消息
  netcall,

  /// Custom
  custom,

  /// 七鱼接入方自定义的消息
  appCustom,

  /// 七鱼类型的 custom 消息
  qiyuCustom,
}

/// 会话类型
enum NIMSessionType {
  none,

  /// 单聊
  p2p,

  /// 群聊
  team,

  /// 超大群
  superTeam,

  /// 系统消息
  system,

  /// 云商服专用类型
  ysf,

  /// 聊天室
  chatRoom
}

/// 撤回消息类型
enum RevokeMessageType {
  undefined,

  /// 点对点双向撤回
  p2pDeleteMsg,

  /// 群双向撤回
  teamDeleteMsg,

  /// 超大群双向撤回
  superTeamDeleteMsg,

  /// 点对点单向撤回
  p2pOneWayDeleteMsg,

  /// 群单向撤回
  teamOneWayDeleteMsg,
}

typedef NIMResultDataConvert<T> = T? Function(Map<String, dynamic> map);

class NIMResult<T> {
  final int code;
  final T? data;
  final String? errorDetails;
  Map<String, dynamic>? _sourceMap;

  NIMResult(this.code, this.data, this.errorDetails);

  NIMResult.failure({int code = -1, String? message})
      : this(code, null, message);

  NIMResult.success({String? message, dynamic data}) : this(0, data, message);

  factory NIMResult.fromMap(Map<String, dynamic> map,
      {NIMResultDataConvert<T>? convert}) {
    var data = map['data'];
    var code = map['code'];
    var errorDetails = map['errorDetails'];
    if (data != null && convert != null) {
      final result = NIMResult(
          code, convert(Map<String, dynamic>.from(data)), errorDetails);
      assert(() {
        result._sourceMap = map;
        return true;
      }());
      return result;
    } else {
      return NIMResult(code, data as T?, errorDetails);
    }
  }

  bool get isSuccess => code == 0 || code == 200;

  Map<String, dynamic> toMap() {
    if (_sourceMap != null) return _sourceMap!;
    return {
      'code': code,
      'data': data,
      'msg': errorDetails,
    };
  }

  @override
  String toString() {
    return 'NIMResult{code: $code, data: $data, errorDetails: $errorDetails}';
  }
}

/// 消息方向
enum NIMMessageDirection {
  /// 发送消息
  outgoing,

  /// 接受消息
  received
}

enum NIMMessageStatus {
  /// 草稿
  draft,

  /// 正在发送中
  sending,

  /// 发送成功
  success,

  /// 发送失败
  fail,

  /// 消息已读
  /// 发送消息时表示对方已看过该消息
  /// 接收消息时表示自己已读过，一般仅用于音频消息
  read,

  /// 未读状态
  unread
}

/// [NIMNosScenes] SDK 内置场景
///
/// 开发者可自定义自己的场景，并在发送消息时指定使用该场景
typedef NIMNosScene = String;

class NIMNosScenes {
  /// 用户、群组资料（eg:头像
  static const NIMNosScene defaultProfile = 'defaultProfile';

  /// 私聊、群聊、聊天室发送图片、音频、视频、文件..
  static const NIMNosScene defaultIm = 'defaultIm';

  /// sdk内部上传文件（eg:日志）并且对应的过期时间不允许修改
  static const NIMNosScene systemNosScene = 'systemNosScene';

  /// 安全文件下载sceneKey前缀， 包含此前缀的都认为是安全文件
  static const NIMNosScene securityPrefix = 'securityPrefix';

  /// 永不过期
  static const int expireTimeNever = 0;
}

/// 消息附件接收/发送状态
enum NIMMessageAttachmentStatus {
  /// 初始状态，需要上传或下载
  initial,

  /// 上传/下载失败
  failed,

  /// 上传/下载中
  transferring,

  /// 附件上传/下载成功/无附件
  transferred,

  /// 取消
  cancel
}

/// 客户端类型
enum NIMClientType {
  /// 未知
  unknown,

  /// Android 客户端
  android,

  /// iOS 客户端
  ios,

  /// Windows 客户端
  windows,

  /// WP 客户端
  wp,

  /// Web端
  web,

  /// RESTFUL API
  rest,

  /// macOS客户端
  macos
}
