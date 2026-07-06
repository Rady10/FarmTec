import 'package:farmtec/core/models/user_model.dart';
import 'package:farmtec/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _accessToken;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get accessToken => _accessToken;
  bool get isAuthenticated => _user != null && _accessToken != null;
  bool get isLoading => _isLoading;

  // 1. User Registration
  Future<void> register({
    required String email,
    required String username,
    required String password,
    String? phoneNumber,
  }) async {
    _setLoading(true);
    try {
      final res = await _authService.register(
        email: email,
        username: username,
        password: password,
        phoneNumber: phoneNumber,
      );

      _user = res['user'];
      _accessToken = res['access'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', res['access']);
      await prefs.setString('refresh_token', res['refresh']);

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // 2. User Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final res = await _authService.login(
        email: email,
        password: password,
      );

      _user = res['user'];
      _accessToken = res['access'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', res['access']);
      await prefs.setString('refresh_token', res['refresh']);

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // 3. User Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      // Try to black-list refresh token on backend if needed, but locally we clean up
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');

      _user = null;
      _accessToken = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // 4. Try Auto Login on App Startup
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString('access_token');
    final refresh = prefs.getString('refresh_token');

    if (access == null || refresh == null) {
      return false;
    }

    try {
      // 1. Attempt to fetch profile with current access token
      final profile = await _authService.getProfile(access);
      _user = profile;
      _accessToken = access;
      notifyListeners();
      return true;
    } catch (e) {
      // 2. Access token might be expired. Try to refresh.
      try {
        final newTokens = await _authService.refreshTokens(refresh);
        final newAccess = newTokens['access']!;
        final newRefresh = newTokens['refresh']!;

        await prefs.setString('access_token', newAccess);
        await prefs.setString('refresh_token', newRefresh);

        // Fetch profile with new access token
        final profile = await _authService.getProfile(newAccess);
        _user = profile;
        _accessToken = newAccess;
        notifyListeners();
        return true;
      } catch (refreshErr) {
        // Refresh token expired or failed. Clean up storage.
        await prefs.remove('access_token');
        await prefs.remove('refresh_token');
        _user = null;
        _accessToken = null;
        return false;
      }
    }
  }

  Future<void> updateProfile({
    required String username,
    required String phoneNumber,
  }) async {
    if (_accessToken == null) return;
    _setLoading(true);
    try {
      await _authService.updateProfile(
        accessToken: _accessToken!,
        username: username,
        phoneNumber: phoneNumber,
      );
      // Refresh local user profile details from backend after update
      final updatedUser = await _authService.getProfile(_accessToken!);
      _user = updatedUser;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProfile() async {
    if (_accessToken == null) {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('access_token');
    }
    if (_accessToken != null) {
      try {
        final profile = await _authService.getProfile(_accessToken!);
        _user = profile;
        notifyListeners();
      } catch (_) {
        // Try refresh
        try {
          final prefs = await SharedPreferences.getInstance();
          final refresh = prefs.getString('refresh_token');
          if (refresh != null) {
            final newTokens = await _authService.refreshTokens(refresh);
            _accessToken = newTokens['access']!;
            await prefs.setString('access_token', _accessToken!);
            await prefs.setString('refresh_token', newTokens['refresh']!);
            final profile = await _authService.getProfile(_accessToken!);
            _user = profile;
            notifyListeners();
          }
        } catch (_) {}
      }
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
