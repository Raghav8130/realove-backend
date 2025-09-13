import 'package:flutter_test/flutter_test.dart';
import 'package:realove_ai/models/models.dart';

void main() {
  group('Prompt Model Tests', () {
    test('should create a Prompt from JSON', () {
      final json = {
        'id': '1',
        'text': 'Hello, how are you?',
        'emotion': '😊',
        'gender': 'female',
        'audioUrl': 'https://example.com/audio.mp3',
      };

      final prompt = Prompt.fromJson(json);

      expect(prompt.id, '1');
      expect(prompt.text, 'Hello, how are you?');
      expect(prompt.emotion, '😊');
      expect(prompt.gender, 'female');
      expect(prompt.audioUrl, 'https://example.com/audio.mp3');
      expect(prompt.timestamp, isNull);
    });

    test('should convert Prompt to JSON', () {
      final prompt = Prompt(
        id: '1',
        text: 'Hello, how are you?',
        emotion: '😊',
        gender: 'female',
        audioUrl: 'https://example.com/audio.mp3',
        timestamp: DateTime(2024, 1, 1),
      );

      final json = prompt.toJson();

      expect(json['id'], '1');
      expect(json['text'], 'Hello, how are you?');
      expect(json['emotion'], '😊');
      expect(json['gender'], 'female');
      expect(json['audioUrl'], 'https://example.com/audio.mp3');
      expect(json['timestamp'], '2024-01-01T00:00:00.000');
    });

    test('should copy Prompt with new values', () {
      final original = Prompt(
        id: '1',
        text: 'Hello, how are you?',
        emotion: '😊',
        gender: 'female',
        audioUrl: 'https://example.com/audio.mp3',
      );

      final copied = original.copyWith(
        text: 'Hi there!',
        emotion: '👋',
      );

      expect(copied.id, '1');
      expect(copied.text, 'Hi there!');
      expect(copied.emotion, '👋');
      expect(copied.gender, 'female');
      expect(copied.audioUrl, 'https://example.com/audio.mp3');
    });
  });

  group('UserPreferences Model Tests', () {
    test('should create UserPreferences from JSON', () {
      final json = {
        'language': 'en',
        'voiceGender': 'male',
        'isDarkMode': true,
      };

      final preferences = UserPreferences.fromJson(json);

      expect(preferences.language, 'en');
      expect(preferences.voiceGender, 'male');
      expect(preferences.isDarkMode, true);
    });

    test('should have default values', () {
      const preferences = UserPreferences(
        language: 'en',
        voiceGender: 'female',
      );

      expect(preferences.language, 'en');
      expect(preferences.voiceGender, 'female');
      expect(preferences.isDarkMode, false);
    });

    test('should copy with new values', () {
      const original = UserPreferences(
        language: 'en',
        voiceGender: 'female',
      );

      final copied = original.copyWith(
        language: 'hi',
        isDarkMode: true,
      );

      expect(copied.language, 'hi');
      expect(copied.voiceGender, 'female');
      expect(copied.isDarkMode, true);
    });
  });

  group('AuthToken Model Tests', () {
    test('should detect expired tokens', () {
      final expiredToken = AuthToken(
        token: 'expired_token',
        expiresAt: DateTime.now().subtract(const Duration(hours: 1)),
        userId: 'user123',
      );

      expect(expiredToken.isExpired, true);
    });

    test('should detect valid tokens', () {
      final validToken = AuthToken(
        token: 'valid_token',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
        userId: 'user123',
      );

      expect(validToken.isExpired, false);
    });
  });
}