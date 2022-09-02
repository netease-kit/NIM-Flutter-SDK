// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:nim_core/nim_core.dart';

const initialize = 'initialize';
const createMessage = 'createMessage';
const sendMessage = 'sendMessage';
const sendTextMessage = 'sendTextMessage';
const sendImageMessage = "sendImageMessage";
const sendAudioMessage = "sendAudioMessage";
const sendVideoMessage = "sendVideoMessage";
const sendLocationMessage = "sendLocationMessage";
const sendFileMessage = "sendFileMessage";
const sendTipMessage = "sendTipMessage";
const sendCustomObjectMessage = "sendCustomObjectMessage";
const sendCustomFileMessage = "sendCustomFileMessage";

/// message
const saveMessage = 'saveMessage';
const updateMessage = 'updateMessage';
const cancelUploadAttachment = 'cancelUploadAttachment';
const resendMessage = 'resendMessage';
const forwardMessage = 'forwardMessage';
const revokeMessage = 'revokeMessage';

/// user
const getUserInfo = 'getUserInfo';
const fetchUserInfoList = 'fetchUserInfoList';
const updateMyUserInfo = 'updateMyUserInfo';
const searchUserIdListByNick = 'searchUserIdListByNick';
const searchUserInfoListByKeyword = 'searchUserInfoListByKeyword';
const getFriendList = 'getFriendList';
const getFriend = 'getFriend';
const addFriend = 'addFriend';
const ackAddFriend = 'ackAddFriend';
const deleteFriend = 'deleteFriend';
const updateFriend = 'updateFriend';
const isMyFriend = 'isMyFriend';
const getBlackList = 'getBlackList';
const addToBlackList = 'addToBlackList';
const removeFromBlackList = 'removeFromBlackList';
const isInBlackList = 'isInBlackList';
const getMuteList = 'getMuteList';
const setMute = 'setMute';
const isMute = 'isMute';

/// auth service
const login = 'login';
const logout = 'logout';

/// chatroom service
const sendChatroomMessage = 'sendChatroomMessage';
const enterChatroom = 'enterChatroom';
const exitChatroom = 'exitChatroom';
const fetchMessageHistory = 'fetchMessageHistory';
const fetchChatroomInfo = 'fetchChatroomInfo';
const updateChatroomInfo = 'updateChatroomInfo';
const downloadAttachment = 'downloadAttachment';
const fetchChatroomMembers = 'fetchChatroomMembers';
const fetchChatroomMembersByAccount = "fetchChatroomMembersByAccount";
const updateChatroomMyMemberInfo = "updateChatroomMyMemberInfo";
const markChatroomMemberInBlackList = "markChatroomMemberInBlackList";
const markChatroomMemberBeManager = "markChatroomMemberBeManager";
const markChatroomMemberBeNormal = "markChatroomMemberBeNormal";
const markChatroomMemberMuted = "markChatroomMemberMuted";
const kickChatroomMember = "kickChatroomMember";
const markChatroomMemberTempMuted = "markChatroomMemberTempMuted";
const fetchChatroomQueue = "fetchChatroomQueue";
const updateChatroomQueueEntry = "updateChatroomQueueEntry";
const batchUpdateChatroomQueue = "batchUpdateChatroomQueue";
const pollChatroomQueueEntry = "pollChatroomQueueEntry";
const clearChatroomQueue = "clearChatroomQueue";
const sendchatroomCustomMessage = "sendchatroomCustomMessage";

final Map<String, Function> funcMap = {
  createTeam: NimCore.instance.teamService.createTeam,
  queryTeamList: NimCore.instance.teamService.queryTeamList,
  searchTeam: NimCore.instance.teamService.searchTeam,
  dismissTeam: NimCore.instance.teamService.dismissTeam,
  passApply: NimCore.instance.teamService.passApply,
  addMembersEx: NimCore.instance.teamService.addMembersEx,
  acceptInvite: NimCore.instance.teamService.acceptInvite,
  getMemberInvitor: NimCore.instance.teamService.getMemberInvitor,
  removeMembers: NimCore.instance.teamService.removeMembers,
  quitTeam: NimCore.instance.teamService.quitTeam,
  queryMemberList: NimCore.instance.teamService.queryMemberList,
  queryTeamMember: NimCore.instance.teamService.queryTeamMember,
  updateMemberNick: NimCore.instance.teamService.updateMemberNick,
  transferTeam: NimCore.instance.teamService.transferTeam,
  addManagers: NimCore.instance.teamService.addManagers,
  removeManagers: NimCore.instance.teamService.removeManagers,
  muteTeamMember: NimCore.instance.teamService.muteTeamMember,
  muteAllTeamMember: NimCore.instance.teamService.muteAllTeamMember,
  queryMutedTeamMembers: NimCore.instance.teamService.queryMutedTeamMembers,
  updateTeamFields: NimCore.instance.teamService.updateTeamFields,
  muteTeam: NimCore.instance.teamService.muteTeam,
  searchTeamIdByName: NimCore.instance.teamService.searchTeamIdByName,
  searchTeamsByKeyword: NimCore.instance.teamService.searchTeamsByKeyword,
};

/// team
const createTeam = 'createTeam';
const queryTeamList = 'queryTeamList';
const queryTeam = 'queryTeam';
const searchTeam = 'searchTeam';
const dismissTeam = 'dismissTeam';
const passApply = 'passApply';
const addMembersEx = 'addMembersEx';
const acceptInvite = 'acceptInvite';
const getMemberInvitor = 'getMemberInvitor';
const removeMembers = 'removeMembers';
const quitTeam = 'quitTeam';
const queryMemberList = 'queryMemberList';
const queryTeamMember = 'queryTeamMember';
const updateMemberNick = 'updateMemberNick';
const transferTeam = 'transferTeam';
const addManagers = 'addManagers';
const removeManagers = 'removeManagers';
const muteTeamMember = 'muteTeamMember';
const muteAllTeamMember = 'muteAllTeamMember';
const queryMutedTeamMembers = 'queryMutedTeamMembers';
const updateTeam = 'updateTeam';
const updateTeamFields = 'updateTeamFields';
const muteTeam = 'muteTeam';
const searchTeamIdByName = 'searchTeamIdByName';
const searchTeamsByKeyword = 'searchTeamsByKeyword';
const onTeamListUpdate = 'onTeamListUpdate';
const onTeamListRemove = 'onTeamListRemove';

/// collect
const addCollect = 'addCollect';
const removeCollect = 'removeCollect';
const updateCollect = 'updateCollect';
const queryCollect = 'queryCollect';

/// pin
const addMessagePin = 'addMessagePin';
const updateMessagePin = 'updateMessagePin';
const removeMessagePin = 'removeMessagePin';
const queryMessagePinForSession = 'queryMessagePinForSession';

/// QuickComment
const addQuickComment = 'addQuickComment';
const removeQuickComment = 'removeQuickComment';
const queryQuickComment = 'queryQuickComment';

/// StickTopSession
const addStickTopSession = 'addStickTopSession';
const removeStickTopSession = 'removeStickTopSession';
const updateStickTopSession = 'updateStickTopSession';
const queryStickTopSession = 'queryStickTopSession';

/// session
const queryMySessionList = 'queryMySessionList';
const queryMySession = 'queryMySession';
const updateMySession = 'updateMySession';
const deleteMySession = 'deleteMySession';

/// settings
const enableMobilePushWhenPCOnline = 'enableMobilePushWhenPCOnline';
const isMobilePushEnabledWhenPCOnline = 'isMobilePushEnabledWhenPCOnline';
const setPushNoDisturbConfig = 'setPushNoDisturbConfig';
const getPushNoDisturbConfig = 'getPushNoDisturbConfig';
const isPushShowDetailEnabled = 'isPushShowDetailEnabled';
const enablePushShowDetail = 'enablePushShowDetail';
const updateAPNSToken = 'updateAPNSToken';
const getSizeOfDirCache = 'getSizeOfDirCache';
const clearDirCache = 'clearDirCache';
const uploadLogs = 'uploadLogs';
const archiveLogs = 'archiveLogs';

/// audio recorder
const startRecord = 'startRecord';
const stopRecord = 'stopRecord';
const cancelRecord = 'cancelRecord';
const isAudioRecording = 'isAudioRecording';
const getAmplitude = 'getAmplitude';

/// system message
const querySystemMessagesIOSAndDesktop = 'querySystemMessagesIOSAndDesktop';
const querySystemMessagesAndroid = 'querySystemMessagesAndroid';
const querySystemMessageByTypeIOSAndDesktop =
    'querySystemMessageByTypeIOSAndDesktop';
const querySystemMessageByTypeAndroid = 'querySystemMessageByTypeAndroid';
const querySystemMessageUnread = 'querySystemMessageUnread';
const querySystemMessageUnreadCount = 'querySystemMessageUnreadCount';
const querySystemMessageUnreadCountByType =
    'querySystemMessageUnreadCountByType';
const resetSystemMessageUnreadCount = 'resetSystemMessageUnreadCount';
const resetSystemMessageUnreadCountByType =
    'resetSystemMessageUnreadCountByType';
const setSystemMessageRead = 'setSystemMessageRead';
const clearSystemMessages = 'clearSystemMessages';
const clearSystemMessagesByType = 'clearSystemMessagesByType';
const deleteSystemMessage = 'deleteSystemMessage';
const setSystemMessageStatus = 'setSystemMessageStatus';
const sendCustomNotification = 'sendCustomNotification';

/// event subsrcibe
const registerEventSubscribe = 'registerEventSubscribe';
const unregisterEventSubscribe = 'unregisterEventSubscribe';
const batchUnSubscribeEvent = 'batchUnSubscribeEvent';
const publishEvent = 'publishEvent';
const querySubscribeEvent = 'querySubscribeEvent';
