import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';

import 'admin_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  String get _resolvedBaseUrl {
    if (kIsWeb) return ApiConstants.baseUrl;
    try {
      if (Platform.isAndroid) return ApiConstants.emulatorBaseUrl;
    } catch (_) {}
    return ApiConstants.baseUrl;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userRaw = prefs.getString('user_session');
    if (userRaw != null) {
      try {
        _currentUser = UserModel.fromJson(
          jsonDecode(userRaw) as Map<String, dynamic>,
        );
        notifyListeners();
      } catch (e) {
        await prefs.remove('user_session');
      }
    }
  }

  /// Login with email and password
  /// Connects to Java backend; falls back to offline demo credentials if backend is offline.
  Future<({bool success, String message, UserModel? user})> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    // 1. Attempt connection to Java Spring Boot backend
    try {
      final url = Uri.parse('$_resolvedBaseUrl${ApiConstants.login}');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': cleanEmail, 'password': password}),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final user = UserModel.fromJson(data);
        _currentUser = user;

        if (rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_session', jsonEncode(user.toJson()));
          if (user.token != null) {
            await prefs.setString('auth_token', user.token!);
          }
        }
        notifyListeners();
        return (success: true, message: 'Welcome back, ${user.fullName}!', user: user);
      } else {
        final err = jsonDecode(response.body) as Map<String, dynamic>;
        final msg =
            err['message']?.toString() ??
            'Invalid credentials. Please verify your email and password.';
        return (success: false, message: msg, user: null);
      }
    } catch (_) {
      // Backend not yet running - fallback to local authentication mode for seamless frontend testing
    }

    // 2. Offline / Demo Mode fallback (allows testing immediately before DB/backend connection)
    await Future.delayed(const Duration(milliseconds: 700));

    if (password.length < 6) {
      return (
        success: false,
        message: 'Password must be at least 6 characters.',
        user: null,
      );
    }

    // Known demo accounts
    final bool isAdmin = cleanEmail.contains('admin');
    final String name = isAdmin
        ? 'Aptech Administrator'
        : cleanEmail.split('@').first;
    final String capitalizedName =
        name.substring(0, 1).toUpperCase() + name.substring(1);

    final user = UserModel(
      id: isAdmin ? 1 : 99,
      email: cleanEmail,
      fullName: capitalizedName,
      role: isAdmin ? 'ADMIN' : 'CUSTOMER',
      token: 'demo-mock-jwt-token-',
      address: isAdmin ? 'Aptech Headquarters, Tech Park' : null,
      phoneNumber: '+234 809 876 5432',
    );

    _currentUser = user;
    if (rememberMe) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_session', jsonEncode(user.toJson()));
    }
    notifyListeners();

    return (
      success: true,
      message:
          'Signed in successfully (${isAdmin ? "Admin Mode" : "Customer Mode"})',
      user: user,
    );
  }

  /// Register a new account
  Future<({bool success, String message, UserModel? user})> register({
    required String fullName,
    required String email,
    required String password,
    String role = 'CUSTOMER',
    String? address,
    String? avatarUrl,
    String? phoneNumber,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanAddress = (address != null && address.trim().isNotEmpty) ? address.trim() : null;
    final cleanAvatar = (avatarUrl != null && avatarUrl.trim().isNotEmpty) ? avatarUrl.trim() : null;
    final cleanPhone = (phoneNumber != null && phoneNumber.trim().isNotEmpty) ? phoneNumber.trim() : null;

    // 1. Try Java Spring Boot backend
    try {
      final url = Uri.parse('$_resolvedBaseUrl${ApiConstants.register}');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fullName': fullName.trim(),
              'email': cleanEmail,
              'password': password,
              'role': role,
              'address': cleanAddress,
              'avatarUrl': cleanAvatar,
              'phoneNumber': cleanPhone,
            }),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final user = UserModel.fromJson(data);
        _currentUser = user;
        AdminService().addUser(user);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_session', jsonEncode(user.toJson()));
        notifyListeners();
        return (
          success: true,
          message: 'Account registered successfully!',
          user: user,
        );
      } else {
        final err = jsonDecode(response.body) as Map<String, dynamic>;
        final msg =
            err['message']?.toString() ??
            'Registration failed. Email might already exist.';
        return (success: false, message: msg, user: null);
      }
    } catch (_) {
      // Backend offline fallback
    }

    // Local registration simulation
    await Future.delayed(const Duration(milliseconds: 700));

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      email: cleanEmail,
      fullName: fullName.trim(),
      role: role.toUpperCase(),
      token: 'demo-mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
      address: cleanAddress,
      avatarUrl: cleanAvatar,
      phoneNumber: cleanPhone,
    );

    _currentUser = user;
    AdminService().addUser(user);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_session', jsonEncode(user.toJson()));
    notifyListeners();

    return (
      success: true,
      message: 'Account created successfully! Welcome, ${user.fullName}.',
      user: user,
    );
  }

  /// Update user profile details (Name, Phone, Address, Avatar)
  Future<({bool success, String message})> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) {
      return (success: false, message: 'No active session found.');
    }

    _currentUser = _currentUser!.copyWith(
      fullName: (fullName != null && fullName.trim().isNotEmpty) ? fullName.trim() : _currentUser!.fullName,
      phoneNumber: phoneNumber,
      address: address,
      avatarUrl: avatarUrl,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_session', jsonEncode(_currentUser!.toJson()));
    notifyListeners();

    return (success: true, message: 'Profile updated successfully!');
  }


  /// Password reset request
  Future<({bool success, String message})> forgotPassword(String email) async {
    final cleanEmail = email.trim().toLowerCase();

    try {
      final url = Uri.parse('$_resolvedBaseUrl${ApiConstants.forgotPassword}');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': cleanEmail}),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        return (
          success: true,
          message: 'Reset instructions have been sent to $cleanEmail',
        );
      }
    } catch (_) {}

    await Future.delayed(const Duration(milliseconds: 600));
    return (
      success: true,
      message: 'Password reset link sent to $cleanEmail (Check your inbox)',
    );
  }

  /// Logout
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_session');
    await prefs.remove('auth_token');
    notifyListeners();
  }
}
