// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_translate_io.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NIMTextTranslateParams _$NIMTextTranslateParamsFromJson(
        Map<String, dynamic> json) =>
    NIMTextTranslateParams(
      text: json['text'] as String,
      sourceLanguage: json['sourceLanguage'] as String?,
      targetLanguage: json['targetLanguage'] as String,
    );

Map<String, dynamic> _$NIMTextTranslateParamsToJson(
        NIMTextTranslateParams instance) =>
    <String, dynamic>{
      'text': instance.text,
      'sourceLanguage': instance.sourceLanguage,
      'targetLanguage': instance.targetLanguage,
    };

NIMTranslatorConfig _$NIMTranslatorConfigFromJson(Map<String, dynamic> json) =>
    NIMTranslatorConfig(
      strictMode: json['strictMode'] as bool? ?? true,
    );

Map<String, dynamic> _$NIMTranslatorConfigToJson(
        NIMTranslatorConfig instance) =>
    <String, dynamic>{
      'strictMode': instance.strictMode,
    };

NIMTextTranslationResult _$NIMTextTranslationResultFromJson(
        Map<String, dynamic> json) =>
    NIMTextTranslationResult(
      translatedText: json['translatedText'] as String?,
      sourceLanguage: json['sourceLanguage'] as String?,
      targetLanguage: json['targetLanguage'] as String?,
    );

Map<String, dynamic> _$NIMTextTranslationResultToJson(
        NIMTextTranslationResult instance) =>
    <String, dynamic>{
      'translatedText': instance.translatedText,
      'sourceLanguage': instance.sourceLanguage,
      'targetLanguage': instance.targetLanguage,
    };
