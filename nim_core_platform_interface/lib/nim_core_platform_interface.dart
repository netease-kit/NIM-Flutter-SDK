// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library nim_core_platform_interface;

///code
export 'src/code/response_code.dart';

/// audio record
export 'src/platform_interface/audio/platform_interface_audio_record_service.dart';
export 'src/platform_interface/audio/record_info.dart';
export 'src/platform_interface/auth/auth_models.dart';

/// auth
export 'src/platform_interface/auth/platform_interface_auth_service.dart';

///chatroom
export 'src/platform_interface/chatroom/chatroom_models.dart';
export 'src/platform_interface/chatroom/platform_interface_chatroom_service.dart';
export 'src/platform_interface/robot/robot_message_type.dart';
export 'src/platform_interface/event_subscribe/event.dart';
export 'src/platform_interface/event_subscribe/event_subscribe_request.dart';
export 'src/platform_interface/event_subscribe/event_subscribe_result.dart';

///event service
export 'src/platform_interface/event_subscribe/platform_interface_event_subscribe_service.dart';
export 'src/platform_interface/initialize/nim_sdk_android_options.dart';
export 'src/platform_interface/initialize/nim_sdk_ios_options.dart';
export 'src/platform_interface/initialize/nim_sdk_macos_options.dart';

/// initialize
export 'src/platform_interface/initialize/nim_sdk_options.dart';
export 'src/platform_interface/initialize/nim_sdk_windows_options.dart';
export 'src/platform_interface/initialize/platform_interface_initialize_service.dart';
export 'src/platform_interface/initialize/nim_sdk_server_config.dart';
export 'src/platform_interface/message/message.dart';
export 'src/platform_interface/message/message_keyword_search_config.dart';
export 'src/platform_interface/message/message_search_option.dart';

/// message
export 'src/platform_interface/message/platform_interface_message_service.dart';
export 'src/platform_interface/message/query_direction_enum.dart';
export 'src/platform_interface/message/quick_comment.dart';
export 'src/platform_interface/message/recent_session_list.dart';
export 'src/platform_interface/message/stick_top_session.dart';

///talk ext
export 'src/platform_interface/message/talk_ext.dart';
export 'src/platform_interface/message/thread_talk_history.dart';
export 'src/platform_interface/nim_base.dart';
export 'src/platform_interface/nos/nos.dart';

///nos
export 'src/platform_interface/nos/platform_interface_nos_service.dart';
export 'src/platform_interface/passthrough/pass_through_notifydata.dart';
export 'src/platform_interface/passthrough/pass_through_proxydata.dart';

///passthrough
export 'src/platform_interface/passthrough/platform_interface_passthorough_service.dart';
export 'src/platform_interface/service.dart';

///settings
export 'src/platform_interface/settings/platform_interface_settings_service.dart';
export 'src/platform_interface/settings/settings_models.dart';
export 'src/platform_interface/super_team/platform_interface_super_team_service.dart';

///superTeam
export 'src/platform_interface/super_team/super_team.dart';
export 'src/platform_interface/super_team/super_team_member.dart';
export 'src/platform_interface/system_message/add_friend_notification.dart';
export 'src/platform_interface/system_message/custom_notification.dart';

///system message
export 'src/platform_interface/system_message/platform_interface_system_message_service.dart';
export 'src/platform_interface/system_message/system_message.dart';
export 'src/platform_interface/team/create_team_options.dart';
export 'src/platform_interface/team/create_team_result.dart';

///team
export 'src/platform_interface/team/platform_interface_team_service.dart';
export 'src/platform_interface/team/team.dart';
export 'src/platform_interface/team/team_member.dart';
export 'src/platform_interface/user/friend.dart';

/// user
export 'src/platform_interface/user/platform_interface_user_service.dart';
export 'src/platform_interface/user/user.dart';
export 'src/platform_interface/user/mute_list_changed_notify.dart';

///for test
export 'src/utils/converter.dart';

///log
export 'src/utils/log.dart';

///avsignalling
export 'src/platform_interface/avsignalling/platform_interface_avsignalling_service.dart';
export 'src/platform_interface/avsignalling/avsignalling_models.dart';

///qchat
export 'src/platform_interface/qchat/platform_interface_qchat_server_service.dart';
export 'src/platform_interface/qchat/qchat_server_models.dart';
export 'src/platform_interface/qchat/qchat_channel_models.dart';
export 'src/platform_interface/qchat/qchat_base_models.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_channel_service.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_service.dart';
export 'src/platform_interface/qchat/qchat_models.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_message_service.dart';
export 'src/platform_interface/qchat/qchat_message_models.dart';
export 'src/platform_interface/qchat/qchat_observer_models.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_observer.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_role_service.dart';
export 'src/platform_interface/qchat/qchat_role_models.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_push_service.dart';
export 'src/platform_interface/qchat/qchat_push_models.dart';
