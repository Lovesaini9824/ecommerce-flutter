// lib/presentation/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool? _isLoggedIn;
  bool? get isLoggedIn => _isLoggedIn;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final res = await ApiService.post('/auth/login', {'email': email, 'password': password});
    final token = res['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    final res = await ApiService.post('/auth/register', {'name': name, 'email': email, 'password': password});
    final token = res['token'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _isLoggedIn = false;
    notifyListeners();
  }
}