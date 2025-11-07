// lib/core/services/api_service.dart
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint; // ADD THIS
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // AUTO DETECT BASE URL
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api'; // Web
    }
    if (Platform.isAndroid) {
      return const bool.fromEnvironment('dart.vm.product')
          ? 'http://10.0.2.2:5000/api'     // Emulator
          : 'http://192.0.1.1:5000/api'; // Real Device
    }
    return 'http://192.168.1.66:5000/api'; // Fallback
  }

  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      uri,
      headers: await _headers(),
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 15), onTimeout: () => throw 'Timeout');
    return _handleResponse(response, uri);
  }

  static Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(
      uri,
      headers: await _headers(),
    ).timeout(const Duration(seconds: 15), onTimeout: () => throw 'Timeout');
    return _handleResponse(response, uri);
  }

  static dynamic _handleResponse(http.Response res, Uri uri) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body);
    }
    final error = jsonDecode(res.body)['message'] ?? 'Server error';
    debugPrint('API FAILED: $uri → ${res.statusCode} $error'); // NOW WORKS
    throw error;
  }
}
