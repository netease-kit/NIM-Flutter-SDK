library nim_core_platform_interface;

export 'src/platform_interface/service.dart';
export 'src/platform_interface/nim_base.dart';

/// message
export 'src/platform_interface/message/platform_interface_message_service.dart';
export 'src/platform_interface/message/message.dart';
export 'src/platform_interface/message/message_keyword_search_config.dart';
export 'src/platform_interface/message/message_search_option.dart';
export 'src/platform_interface/message/query_direction_enum.dart';
export 'src/platform_interface/message/thread_talk_history.dart';
export 'src/platform_interface/robot/robot_message_type.dart';

/// user
export 'src/platform_interface/user/platform_interface_user_service.dart';
export 'src/platform_interface/user/user.dart';
export 'src/platform_interface/user/friend.dart';

/// initialize
export 'src/platform_interface/initialize/nim_sdk_options.dart';
export 'src/platform_interface/initialize/nim_sdk_android_options.dart';
export 'src/platform_interface/initialize/nim_sdk_ios_options.dart';
export 'src/platform_interface/initialize/platform_interface_initialize_service.dart';

/// auth
export 'src/platform_interface/auth/platform_interface_auth_service.dart';
export 'src/platform_interface/auth/auth_models.dart';

/// audio record
export 'src/platform_interface/audio/platform_interface_audio_record_service.dart';
export 'src/platform_interface/audio/record_info.dart';

///event service
export 'src/platform_interface/event_subscribe/platform_interface_event_subscribe_service.dart';
export 'src/platform_interface/event_subscribe/event.dart';
export 'src/platform_interface/event_subscribe/event_subscribe_request.dart';
export 'src/platform_interface/event_subscribe/event_subscribe_result.dart';

///system message
export 'src/platform_interface/system_message/platform_interface_system_message_service.dart';
export 'src/platform_interface/system_message/custom_notification.dart';
export 'src/platform_interface/system_message/system_message.dart';

///chatroom
export 'src/platform_interface/chatroom/chatroom_models.dart';
export 'src/platform_interface/chatroom/platform_interface_chatroom_service.dart';

///for test
export 'src/utils/converter.dart';

///team
export 'src/platform_interface/team/platform_interface_team_service.dart';
export 'src/platform_interface/team/create_team_options.dart';
export 'src/platform_interface/team/team.dart';
export 'src/platform_interface/team/create_team_result.dart';
export 'src/platform_interface/team/team_member.dart';

///nos
export 'src/platform_interface/nos/platform_interface_nos_service.dart';

///settings
export 'src/platform_interface/settings/platform_interface_settings_service.dart';
export 'src/platform_interface/settings/settings_models.dart';

///passthrough
export 'src/platform_interface/passthrough/platform_interface_passthorough_service.dart';
export 'src/platform_interface/passthrough/pass_through_proxydata.dart';
export 'src/platform_interface/passthrough/pass_through_notifydata.dart';
