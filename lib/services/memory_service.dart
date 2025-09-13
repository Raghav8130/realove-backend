import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class MemoryService {
  static const String _preferencesKey = 'user_preferences';
  static const String _authTokenKey = 'auth_token';
  static const String _chatHistoryKey = 'chat_history';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<UserPreferences> getUserPreferences() async {
    await init();
    final String? prefsJson = _prefs!.getString(_preferencesKey);
    
    if (prefsJson != null) {
      final Map<String, dynamic> json = jsonDecode(prefsJson);
      return UserPreferences.fromJson(json);
    }
    
    // Return default preferences
    return const UserPreferences(
      language: 'en',
      voiceGender: 'female',
      isDarkMode: false,
    );
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    await init();
    final String prefsJson = jsonEncode(preferences.toJson());
    await _prefs!.setString(_preferencesKey, prefsJson);
  }

  Future<AuthToken?> getAuthToken() async {
    await init();
    final String? tokenJson = _prefs!.getString(_authTokenKey);
    
    if (tokenJson != null) {
      final Map<String, dynamic> json = jsonDecode(tokenJson);
      final token = AuthToken.fromJson(json);
      
      // Check if token is expired
      if (token.isExpired) {
        await clearAuthToken();
        return null;
      }
      
      return token;
    }
    
    return null;
  }

  Future<void> saveAuthToken(AuthToken token) async {
    await init();
    final String tokenJson = jsonEncode(token.toJson());
    await _prefs!.setString(_authTokenKey, tokenJson);
  }

  Future<void> clearAuthToken() async {
    await init();
    await _prefs!.remove(_authTokenKey);
  }

  Future<List<Prompt>> getChatHistory() async {
    await init();
    final String? historyJson = _prefs!.getString(_chatHistoryKey);
    
    if (historyJson != null) {
      final List<dynamic> jsonList = jsonDecode(historyJson);
      return jsonList.map((json) => Prompt.fromJson(json)).toList();
    }
    
    return [];
  }

  Future<void> saveChatHistory(List<Prompt> history) async {
    await init();
    final List<Map<String, dynamic>> jsonList = 
        history.map((prompt) => prompt.toJson()).toList();
    final String historyJson = jsonEncode(jsonList);
    await _prefs!.setString(_chatHistoryKey, historyJson);
  }

  Future<void> addToHistory(Prompt prompt) async {
    final List<Prompt> history = await getChatHistory();
    history.add(prompt.copyWith(timestamp: DateTime.now()));
    await saveChatHistory(history);
  }

  Future<void> clearHistory() async {
    await init();
    await _prefs!.remove(_chatHistoryKey);
  }

  Future<void> clearAll() async {
    await init();
    await _prefs!.clear();
  }
}