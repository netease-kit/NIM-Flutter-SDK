// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

/// 消息内容类型
export enum NIMMessageType {
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

/// 消息方向
export enum NIMMessageDirection {
  /// 发送消息
  outgoing,

  /// 接受消息
  received,
}

export enum NIMMessageStatus {
  /// 草稿
  draft = 'draft',
  /// 正在发送中
  sending = 'sending',
  /// 发送成功
  success = 'success',
  /// 发送失败
  fail = 'fail',
  /// 消息已读
  /// 发送消息时表示对方已看过该消息
  /// 接收消息时表示自己已读过，一般仅用于音频消息
  read = 'read',
  /// 未读状态
  unread = 'unread',
}

export type NIMSDKMessageStatus = NIMMessageStatus

/// 会话类型
export enum NIMSessionType {
  none = 'none',

  /// 单聊
  p2p = 'p2p',

  /// 群聊
  team = 'team',

  /// 超大群
  superTeam = 'superTeam',

  /// 系统消息
  system = 'system',

  /// 云商服专用类型
  ysf = 'ysf',

  /// 聊天室
  chatRoom = 'chatRoom',
}

export type NIMSDKSessionType = NIMSessionType

/// 撤回消息类型
export enum RevokeMessageType {
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

export enum QueryDirection {
  /// 查询比锚点时间更早的消息
  QUERY_OLD,
  /// 查询比锚点时间更晚的消
  QUERY_NEW,
}

export enum SearchOrder {
  /// 从新消息往旧消息查
  DESC,
  /// 从旧消息往新消息查
  ASC,
}

export enum NIMUnreadCountQueryType {
  /// 所有类型
  all,
  /// 仅通知消息
  notifyOnly,
  /// 仅免打扰消息
  noDisturbOnly,
}

export enum NIMSessionDeleteType {
  ///
  local,
  ///
  remote,
  ///
  localAndRemote,
}

/// 认证类型
export enum NIMAuthType {
  authTypeDefault,
  authTypeDynamic,
  authTypeThirdParty,
}

export const deleteMsgMap = {
  p2p: 'p2pDeleteMsg',
  team: 'teamDeleteMsg',
  superTeam: 'superTeamDeleteMsg',
}

export enum NIMMsgScene {
  p2p = 'p2p',
  team = 'team',
  superTeam = 'superTeam',
}

export enum NIMWebMsgType {
  text = 'text',
  image = 'image',
  audio = 'audio',
  video = 'video',
  geo = 'geo',
  notification = 'notification',
  file = 'file',
  tip = 'tip',
  robot = 'robot',
  g2 = 'g2',
  custom = 'custom',
  unknow = 'unknow',
}

export enum NimUserGender {
  unknown = 0,
  male = 1,
  female = 2,
}

export enum SystemMessageType {
  undefined,
  applyJoinTeam,
  rejectTeamApply,
  teamInvite,
  declineTeamInvite,
  addFriend,
  superTeamApply,
  superTeamApplyReject,
  superTeamInvite,
  superTeamInviteReject,
}

export enum WebSystemMessageType {
  addFriend,
  applyFriend,
  applySuperTeam,
  applyTeam,
  custom,
  deleteFriend,
  deleteMsg,
  passFriendApply,
  rejectFriendApply,
  rejectSuperTeamApply,
  rejectSuperTeamInvite,
  rejectTeamApply,
  rejectTeamInvite,
  superTeamInvite,
  teamInvite,
}

export enum WebSystemMessageStatus {
  init,
  passed,
  rejected,
  ignored,
  expired,
}

export enum SystemMessageStatus {
  init,
  passed,
  declined,
  ignored,
  expired,
  extension1,
  extension2,
  extension3,
  extension4,
  extension5,
}

export enum NIMVerifyType {
  directAdd, // 直接添加
  verifyRequest, // 认证
}

export enum NIMClientType {
  unknown = 'unknown',
  android = 'android',
  ios = 'ios',
  windows = 'windows',
  wp = 'wp',
  web = 'web',
  rest = 'rest',
  macos = 'macos',
}

export enum NIMSDKClientType {
  Android = 'Android',
  iOS = 'iOS',
  PC = 'PC',
  WindowsPhone = 'WindowsPhone',
  Web = 'Web',
  Unknown = 'Unknown',
}
