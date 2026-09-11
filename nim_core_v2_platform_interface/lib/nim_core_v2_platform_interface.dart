// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

library nim_core_v2_platform_interface;

export 'src/code/client_code.dart';

///code
export 'src/code/response_code.dart';
export 'src/platform_interface/ai/ai_models.dart';

/// ai
export 'src/platform_interface/ai/platform_interface_ai_service.dart';
export 'src/platform_interface/apns/apns_data.dart';

/// apns
export 'src/platform_interface/apns/platform_interface_apns_service.dart';

/// audio record
export 'src/platform_interface/audio/platform_interface_audio_record_service.dart';
export 'src/platform_interface/audio/record_info.dart';
export 'src/platform_interface/auth/auth_models.dart';
export 'src/platform_interface/chatroom/chatroom_member.dart';
export 'src/platform_interface/chatroom/chatroom_message.dart';

///chatroom
export 'src/platform_interface/chatroom/chatroom_models.dart';
export 'src/platform_interface/chatroom/chatroom_queue.dart';
export 'src/platform_interface/chatroom/platform_interface_chatroom_client_service.dart';
export 'src/platform_interface/chatroom/platform_interface_chatroom_message_creator_service.dart';
export 'src/platform_interface/chatroom/platform_interface_chatroom_queue.dart';
export 'src/platform_interface/chatroom/platform_interface_chatroom_service.dart';
export 'src/platform_interface/conversation/conversation_group_models.dart';

/// conversation
export 'src/platform_interface/conversation/conversation_models.dart';
export 'src/platform_interface/conversation/platform_interface_conversation_group_service.dart';
export 'src/platform_interface/conversation/platform_interface_conversation_id_util.dart';
export 'src/platform_interface/conversation/platform_interface_conversation_service.dart';
export 'src/platform_interface/conversation/platform_interface_local_conversation_service.dart';
export 'src/platform_interface/event_subscribe/event.dart';
export 'src/platform_interface/event_subscribe/event_subscribe_request.dart';
export 'src/platform_interface/event_subscribe/event_subscribe_result.dart';

///event service
export 'src/platform_interface/event_subscribe/platform_interface_event_subscribe_service.dart';
//friend
export 'src/platform_interface/friend/friend_models.dart';
export 'src/platform_interface/friend/platform_interface_friend_service.dart';

///initialize
export 'src/platform_interface/initialize/nim_sdk_android_options.dart';
export 'src/platform_interface/initialize/nim_sdk_ios_options.dart';
export 'src/platform_interface/initialize/nim_sdk_ohos_options.dart';
export 'src/platform_interface/initialize/nim_sdk_options.dart';
export 'src/platform_interface/initialize/nim_sdk_pc_options.dart';
export 'src/platform_interface/initialize/nim_sdk_server_config.dart';
export 'src/platform_interface/initialize/nim_sdk_web_options.dart';
export 'src/platform_interface/initialize/platform_interface_initialize_service.dart';
export 'src/platform_interface/login/login_models.dart';
//login
export 'src/platform_interface/login/platform_interface_login_service.dart';
export 'src/platform_interface/message/message.dart';
export 'src/platform_interface/message/message_collection_v2.dart';
export 'src/platform_interface/message/message_insert_params.dart';
export 'src/platform_interface/message/message_notification_v2.dart';
export 'src/platform_interface/message/message_pin_v2.dart';
export 'src/platform_interface/message/message_quick_comment_v2.dart';
export 'src/platform_interface/message/message_read_receipt_v2.dart';
export 'src/platform_interface/message/message_search.dart';
export 'src/platform_interface/message/message_thread_v2.dart';
export 'src/platform_interface/message/message_translate_io.dart';
export 'src/platform_interface/message/platform_interface_client_antispam_util.dart';
export 'src/platform_interface/message/platform_interface_message_creator_service.dart';

/// message
export 'src/platform_interface/message/platform_interface_message_service.dart';
export 'src/platform_interface/message/v2_message_enum.dart';
export 'src/platform_interface/mixpush/mixpush.dart';
export 'src/platform_interface/mixpush/platform_interface_mixpush_service.dart';

///talk ext
export 'src/platform_interface/nim_base.dart';

///base
export 'src/platform_interface/nim_base_v2.dart';
export 'src/platform_interface/nos/nos.dart';

///nos
export 'src/platform_interface/nos/platform_interface_nos_service.dart';
export 'src/platform_interface/notify/notify_models.dart';

///notify
export 'src/platform_interface/notify/platform_interface_notification_service.dart';
export 'src/platform_interface/passthrough/pass_through_notifydata.dart';
export 'src/platform_interface/passthrough/pass_through_proxydata.dart';

///passthrough
export 'src/platform_interface/passthrough/platform_interface_passthorough_service.dart';

///push
export 'src/platform_interface/push/platform_interface_ohos_push_service.dart';

///qchat
export 'src/platform_interface/qchat/platform_interface_qchat_channel_service.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_message_service.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_observer.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_push_service.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_role_service.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_server_service.dart';
export 'src/platform_interface/qchat/platform_interface_qchat_service.dart';
export 'src/platform_interface/qchat/qchat_base_models.dart';
export 'src/platform_interface/qchat/qchat_channel_models.dart';
export 'src/platform_interface/qchat/qchat_message_attachment.dart';
export 'src/platform_interface/qchat/qchat_message_models.dart';
export 'src/platform_interface/qchat/qchat_models.dart';
export 'src/platform_interface/qchat/qchat_observer_models.dart';
export 'src/platform_interface/qchat/qchat_push_models.dart';
export 'src/platform_interface/qchat/qchat_role_models.dart';
export 'src/platform_interface/qchat/qchat_server_models.dart';
export 'src/platform_interface/robot/robot_message_type.dart';
export 'src/platform_interface/service.dart';
export 'src/platform_interface/setting/dnd_config.dart';

///setting
export 'src/platform_interface/setting/platform_interface_settings_service.dart';
export 'src/platform_interface/setting/setting_enum.dart';

///signalling
export 'src/platform_interface/signalling/platform_interface_signalling_service.dart';
export 'src/platform_interface/signalling/signalling_models.dart';
export 'src/platform_interface/statistics/statistics_models.dart';

/// statistics
export 'src/platform_interface/statistics/statistics_service_platform.dart';

///storage
export 'src/platform_interface/storage/platform_interface_storage_service.dart';
export 'src/platform_interface/storage/storage_models.dart';

/// subscription
export 'src/platform_interface/subscription/platform_interface_subscription_service.dart';
export 'src/platform_interface/subscription/subscription_models.dart';
export 'src/platform_interface/team/antispam_config.dart';
export 'src/platform_interface/team/nim_team_search.dart';
export 'src/platform_interface/team/platform_interface_team_service.dart';
export 'src/platform_interface/team/team.dart';
export 'src/platform_interface/team/team_enum.dart';
export 'src/platform_interface/team/team_member.dart';
export 'src/platform_interface/team/team_param.dart';

///team
export 'src/platform_interface/team/team_result.dart';

///topic
export 'src/platform_interface/topic/platform_interface_topic_service.dart';
export 'src/platform_interface/topic/topic_models.dart';

///team
export 'src/platform_interface/user/mute_list_changed_notify.dart';

/// user
export 'src/platform_interface/user/platform_interface_user_service.dart';
export 'src/platform_interface/user/user.dart';

///utility
export 'src/platform_interface/utility/platform_interface_utility_service.dart';

///for test
export 'src/utils/converter.dart';

///log
export 'src/utils/log.dart';
