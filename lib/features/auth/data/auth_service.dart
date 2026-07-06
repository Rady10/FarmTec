import 'dart:convert';
import 'package:farmtec/core/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://ahmed-mabrouk22-farmtech-backend.hf.space/api/accounts';

  // 1. User Registration
  Future<Map<String, dynamic>> register({
    required String email,
    required String username,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          if (phoneNumber != null && phoneNumber.isNotEmpty) 'phone_number': phoneNumber,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return {
          'user': UserModel.fromJson(data['user']),
          'access': data['access'],
          'refresh': data['refresh'],
        };
      } else {
        throw Exception(data['error'] ?? 'Registration failed. Please try again.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Connection error. Please check your internet connection.');
    }
  }

  // 2. User Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'user': UserModel.fromJson(data['user']),
          'access': data['access'],
          'refresh': data['refresh'],
        };
      } else {
        throw Exception(data['error'] ?? 'Invalid credentials. Please try again.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Connection error. Please check your internet connection.');
    }
  }

  // 3. Get Profile Info (using Access Token)
  Future<UserModel> getProfile(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to load profile.');
      }
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  // 4. Refresh Tokens
  Future<Map<String, String>> refreshTokens(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refreshToken}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'access': data['access'],
          'refresh': data['refresh'] ?? refreshToken, // Use existing refresh if not rotated
        };
      } else {
        throw Exception('Session expired. Please log in again.');
      }
    } catch (e) {
      throw Exception('Token refresh failed: $e');
    }
  }

  // 5. Update Profile
  Future<void> updateProfile({
    required String accessToken,
    required String username,
    required String phoneNumber,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/profile/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'username': username,
          'phone_number': phoneNumber,
        }),
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? data['message'] ?? 'Failed to update profile.');
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
