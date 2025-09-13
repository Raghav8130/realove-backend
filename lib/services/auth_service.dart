import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/models.dart';
import 'memory_service.dart';

class AuthService {
  final MemoryService _memoryService;
  
  AuthService(this._memoryService);

  Future<bool> login(String jwtToken) async {
    try {
      // Validate JWT token
      if (JwtDecoder.isExpired(jwtToken)) {
        throw Exception('Token is expired');
      }

      // Decode JWT to get user information
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
      
      final String userId = decodedToken['sub'] ?? decodedToken['user_id'] ?? 'unknown';
      final DateTime expiresAt = JwtDecoder.getExpirationDate(jwtToken);

      // Create and save auth token
      final authToken = AuthToken(
        token: jwtToken,
        expiresAt: expiresAt,
        userId: userId,
      );

      await _memoryService.saveAuthToken(authToken);
      return true;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    await _memoryService.clearAuthToken();
  }

  Future<bool> isLoggedIn() async {
    final authToken = await _memoryService.getAuthToken();
    return authToken != null && !authToken.isExpired;
  }

  Future<AuthToken?> getCurrentToken() async {
    return await _memoryService.getAuthToken();
  }

  Future<String?> getCurrentUserId() async {
    final authToken = await getCurrentToken();
    return authToken?.userId;
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final authToken = await getCurrentToken();
    if (authToken == null) {
      throw Exception('No valid authentication token found');
    }

    return {
      'Authorization': 'Bearer ${authToken.token}',
      'Content-Type': 'application/json',
    };
  }

  Future<bool> refreshTokenIfNeeded() async {
    final authToken = await getCurrentToken();
    if (authToken == null) return false;

    // Check if token expires within the next hour
    final now = DateTime.now();
    final expiresIn = authToken.expiresAt.difference(now);
    
    if (expiresIn.inHours < 1) {
      // In a real app, you would call a refresh endpoint here
      // For now, we'll just return false to indicate refresh is needed
      return false;
    }

    return true;
  }

  String? getUserIdFromToken(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken['sub'] ?? decodedToken['user_id'];
    } catch (e) {
      return null;
    }
  }

  DateTime? getTokenExpirationDate(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }
}