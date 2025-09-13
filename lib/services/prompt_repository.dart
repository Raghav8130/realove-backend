import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class PromptRepository {
  static const String _assetPath = 'assets/prompts/user_001.json';
  
  List<Prompt>? _cachedPrompts;

  Future<List<Prompt>> loadPrompts() async {
    if (_cachedPrompts != null) {
      return _cachedPrompts!;
    }

    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final Map<String, dynamic> json = jsonDecode(jsonString);
      final List<dynamic> promptsJson = json['prompts'] as List<dynamic>;
      
      _cachedPrompts = promptsJson
          .map((promptJson) => Prompt.fromJson(promptJson as Map<String, dynamic>))
          .toList();
      
      return _cachedPrompts!;
    } catch (e) {
      throw Exception('Failed to load prompts: $e');
    }
  }

  Future<Prompt?> getPromptById(String id) async {
    final prompts = await loadPrompts();
    try {
      return prompts.firstWhere((prompt) => prompt.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Prompt>> getPromptsByGender(String gender) async {
    final prompts = await loadPrompts();
    return prompts.where((prompt) => prompt.gender == gender).toList();
  }

  Future<List<Prompt>> getPromptsByEmotion(String emotion) async {
    final prompts = await loadPrompts();
    return prompts.where((prompt) => prompt.emotion == emotion).toList();
  }

  Future<Prompt?> getRandomPrompt() async {
    final prompts = await loadPrompts();
    if (prompts.isEmpty) return null;
    
    final random = DateTime.now().millisecondsSinceEpoch % prompts.length;
    return prompts[random];
  }

  Future<Prompt?> getRandomPromptByGender(String gender) async {
    final prompts = await getPromptsByGender(gender);
    if (prompts.isEmpty) return null;
    
    final random = DateTime.now().millisecondsSinceEpoch % prompts.length;
    return prompts[random];
  }

  void clearCache() {
    _cachedPrompts = null;
  }
}