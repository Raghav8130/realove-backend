import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Prompt {
  final String id;
  final String text;
  final String emotion;
  final String gender;
  final String audioUrl;
  final DateTime? timestamp;

  const Prompt({
    required this.id,
    required this.text,
    required this.emotion,
    required this.gender,
    required this.audioUrl,
    this.timestamp,
  });

  factory Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);
  Map<String, dynamic> toJson() => _$PromptToJson(this);

  Prompt copyWith({
    String? id,
    String? text,
    String? emotion,
    String? gender,
    String? audioUrl,
    DateTime? timestamp,
  }) {
    return Prompt(
      id: id ?? this.id,
      text: text ?? this.text,
      emotion: emotion ?? this.emotion,
      gender: gender ?? this.gender,
      audioUrl: audioUrl ?? this.audioUrl,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

@JsonSerializable()
class UserPreferences {
  final String language;
  final String voiceGender;
  final bool isDarkMode;

  const UserPreferences({
    required this.language,
    required this.voiceGender,
    this.isDarkMode = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) => 
      _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    String? language,
    String? voiceGender,
    bool? isDarkMode,
  }) {
    return UserPreferences(
      language: language ?? this.language,
      voiceGender: voiceGender ?? this.voiceGender,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

@JsonSerializable()
class AuthToken {
  final String token;
  final DateTime expiresAt;
  final String userId;

  const AuthToken({
    required this.token,
    required this.expiresAt,
    required this.userId,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) => 
      _$AuthTokenFromJson(json);
  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}