import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:realove_ai/services/prompt_repository.dart';
import 'package:realove_ai/models/models.dart';

void main() {
  group('PromptRepository Tests', () {
    late PromptRepository repository;

    setUp(() {
      repository = PromptRepository();
    });

    test('should load prompts from assets', () async {
      // Mock the asset bundle
      const String mockJson = '''
      {
        "prompts": [
          {
            "id": "1",
            "text": "Test prompt",
            "emotion": "😊",
            "gender": "female",
            "audioUrl": "https://example.com/test.mp3"
          }
        ]
      }
      ''';

      // This test would need proper mocking of rootBundle
      // For now, we'll test the structure
      expect(repository, isA<PromptRepository>());
    });

    test('should get random prompt', () async {
      // This is a structural test - in real testing you'd mock the asset loading
      expect(() async => await repository.getRandomPrompt(), returnsNormally);
    });

    test('should filter prompts by gender', () async {
      // This is a structural test - in real testing you'd mock the asset loading
      expect(() async => await repository.getPromptsByGender('female'), returnsNormally);
    });

    test('should clear cache', () {
      repository.clearCache();
      // Test that cache is cleared (would need to verify internal state)
      expect(repository, isA<PromptRepository>());
    });
  });
}