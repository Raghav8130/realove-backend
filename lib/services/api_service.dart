import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'auth_service.dart';

class ApiService {
  final String baseUrl;
  final AuthService _authService;
  
  ApiService({
    required this.baseUrl,
    required AuthService authService,
  }) : _authService = authService;

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await http.get(uri, headers: headers);
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request failed: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, 
    Map<String, dynamic> body,
  ) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request failed: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request failed: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final uri = Uri.parse('$baseUrl$endpoint');
      
      final response = await http.delete(uri, headers: headers);
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request failed: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        if (response.body.isEmpty) {
          return {'success': true};
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
        
      case 400:
        throw Exception('Bad Request: ${response.body}');
        
      case 401:
        throw Exception('Unauthorized: Please login again');
        
      case 403:
        throw Exception('Forbidden: Access denied');
        
      case 404:
        throw Exception('Not Found: ${response.body}');
        
      case 500:
        throw Exception('Internal Server Error: ${response.body}');
        
      default:
        throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  // Specific API endpoints for Realove AI
  Future<List<Prompt>> getPrompts() async {
    try {
      final response = await get('/prompts');
      final List<dynamic> promptsJson = response['prompts'] as List<dynamic>;
      
      return promptsJson
          .map((json) => Prompt.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get prompts: $e');
    }
  }

  Future<Prompt> createPrompt(Prompt prompt) async {
    try {
      final response = await post('/prompts', prompt.toJson());
      return Prompt.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create prompt: $e');
    }
  }

  Future<void> updateUserPreferences(UserPreferences preferences) async {
    try {
      await put('/user/preferences', preferences.toJson());
    } catch (e) {
      throw Exception('Failed to update preferences: $e');
    }
  }

  Future<UserPreferences> getUserPreferences() async {
    try {
      final response = await get('/user/preferences');
      return UserPreferences.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user preferences: $e');
    }
  }

  Future<List<Prompt>> getChatHistory() async {
    try {
      final response = await get('/user/chat-history');
      final List<dynamic> historyJson = response['history'] as List<dynamic>;
      
      return historyJson
          .map((json) => Prompt.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  Future<void> saveChatHistory(List<Prompt> history) async {
    try {
      final historyJson = {
        'history': history.map((prompt) => prompt.toJson()).toList(),
      };
      await post('/user/chat-history', historyJson);
    } catch (e) {
      throw Exception('Failed to save chat history: $e');
    }
  }
}