// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

// 会话对象的 JS ↔ Dart 转换
// 核心的 formatV2ConversationLastMessage 逻辑已在 message_converter.dart 中实现
// 此文件导出便捷引用

export 'message_converter.dart'
    show formatV2ConversationLastMessage, formatV2ConversationList;
