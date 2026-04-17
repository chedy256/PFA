import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'api_endpoints.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  Future<Map<String, String>> _getHeaders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    String? token;

    if (user != null) {
      token = await user.getIdToken();
    }

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Uri _buildUri(String endpoint) {
    return Uri.parse(ApiEndpoints.baseUrl).resolve(endpoint);
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final url = _buildUri(endpoint);
    try {
      final response = await http.get(url, headers: headers);
      _logResponse('GET', endpoint, response);
      return response;
    } catch (e) {
      _logError('GET', endpoint, e);
      rethrow;
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await _getHeaders();
    final url = _buildUri(endpoint);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse('POST', endpoint, response);
      return response;
    } catch (e) {
      _logError('POST', endpoint, e);
      rethrow;
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await _getHeaders();
    final url = _buildUri(endpoint);
    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse('PUT', endpoint, response);
      return response;
    } catch (e) {
      _logError('PUT', endpoint, e);
      rethrow;
    }
  }

  Future<http.Response> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final headers = await _getHeaders();
    final url = _buildUri(endpoint);
    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse('PATCH', endpoint, response);
      return response;
    } catch (e) {
      _logError('PATCH', endpoint, e);
      rethrow;
    }
  }

  Future<http.Response> delete(String endpoint) async {
    final headers = await _getHeaders();
    final url = _buildUri(endpoint);
    try {
      final response = await http.delete(url, headers: headers);
      _logResponse('DELETE', endpoint, response);
      return response;
    } catch (e) {
      _logError('DELETE', endpoint, e);
      rethrow;
    }
  }

  void _logResponse(String method, String endpoint, http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      print('❌ API ERROR [$method] $endpoint');
      if (kDebugMode) {
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } else if (kDebugMode) {
      print('✅ API SUCCESS [$method] $endpoint (${response.statusCode})');
    }
  }

  void _logError(String method, String endpoint, dynamic error) {
    print('🚨 API FATAL ERROR [$method] $endpoint');
    if (kDebugMode) {
      print('Error: $error');
    }
  }
}
