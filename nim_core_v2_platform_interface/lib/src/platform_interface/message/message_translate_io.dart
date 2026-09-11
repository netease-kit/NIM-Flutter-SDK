// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'message_translate_io.g.dart';

// ─────────────────────────────────────────────
// Text Translate Models
// ─────────────────────────────────────────────

/// 文本翻译请求参数
@JsonSerializable(explicitToJson: true)
class NIMTextTranslateParams {
  /// 待翻译的文本内容，最大长度 5000 字符
  final String text;

  /// 源语言代码（如 "zh"、"en"），为 null 时由服务端自动检测
  final String? sourceLanguage;

  /// 目标语言代码（如 "en"、"ja"）
  final String targetLanguage;

  NIMTextTranslateParams({
    required this.text,
    this.sourceLanguage,
    required this.targetLanguage,
  });

  factory NIMTextTranslateParams.fromJson(Map<String, dynamic> map) =>
      _$NIMTextTranslateParamsFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTextTranslateParamsToJson(this);
}

/// 文本翻译配置项
@JsonSerializable(explicitToJson: true)
class NIMTranslatorConfig {
  /// 严格模式：true 时严格按输入的源语言翻译；false 时服务端可能自动优化，默认为 true
  final bool strictMode;

  NIMTranslatorConfig({this.strictMode = true});

  factory NIMTranslatorConfig.fromJson(Map<String, dynamic> map) =>
      _$NIMTranslatorConfigFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTranslatorConfigToJson(this);
}

/// 文本翻译结果
@JsonSerializable(explicitToJson: true)
class NIMTextTranslationResult {
  /// 翻译后的文本
  final String? translatedText;

  /// 实际使用的源语言代码（自动检测时由服务端填充）
  final String? sourceLanguage;

  /// 目标语言代码
  final String? targetLanguage;

  NIMTextTranslationResult({
    this.translatedText,
    this.sourceLanguage,
    this.targetLanguage,
  });

  factory NIMTextTranslationResult.fromJson(Map<String, dynamic> map) =>
      _$NIMTextTranslationResultFromJson(map);

  Map<String, dynamic> toJson() => _$NIMTextTranslationResultToJson(this);
}
