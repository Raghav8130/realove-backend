// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prompt _$PromptFromJson(Map<String, dynamic> json) => Prompt(
      id: json['id'] as String,
      text: json['text'] as String,
      emotion: json['emotion'] as String,
      gender: json['gender'] as String,
      audioUrl: json['audioUrl'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$PromptToJson(Prompt instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'emotion': instance.emotion,
      'gender': instance.gender,
      'audioUrl': instance.audioUrl,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      language: json['language'] as String,
      voiceGender: json['voiceGender'] as String,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'language': instance.language,
      'voiceGender': instance.voiceGender,
      'isDarkMode': instance.isDarkMode,
    };

AuthToken _$AuthTokenFromJson(Map<String, dynamic> json) => AuthToken(
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$AuthTokenToJson(AuthToken instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'userId': instance.userId,
    };