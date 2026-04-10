import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/models/user.dart' as model;
import 'package:pfa/core/providers/auth_provider.dart';

class UserDataNotifier extends AsyncNotifier<model.User?> {
  final String _baseUrl = 'http://10.0.2.2:8000'; // backend API base URL
  final _storage = const FlutterSecureStorage();
  static const _localUserKey = 'local_user_data';

  @override
  Future<model.User?> build() async {
    final authState = ref.watch(authProvider);
    final appUser = authState.value;

    if (appUser == null) {
      debugPrint('UserDataNotifier: No authenticated user found.');
      return null;
    }

    final prefs = await SharedPreferences.getInstance();
    final localDataString = prefs.getString(_localUserKey);
    model.User? localUser;

    if (localDataString != null) {
      try {
        final data = json.decode(localDataString);
        localUser = _mapToUser(appUser.uid, appUser.email, appUser.role, data);
        debugPrint(
          'UserDataNotifier: Loaded data from SharedPreferences for ${appUser.uid}.',
        );

        // Return immediately to ensure the UI is snappy and works offline.
        // We will perform the backend sync in the background (non-blocking).
        _syncWithBackendInBackground(appUser, localUser, localDataString);
        return localUser;
      } catch (e) {
        debugPrint('UserDataNotifier Error: Corrupt local JSON ($e).');
      }
    } else {
      debugPrint('UserDataNotifier: No local data found for ${appUser.uid}.');
    }

    // Only if we have NO local data, we wait for the backend.
    try {
      final token = await _storage.read(key: 'jwt');
      if (token == null) return null;

      final fetchUrl = '$_baseUrl/users/${appUser.uid}';
      final response = await http
          .get(
            Uri.parse(fetchUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_localUserKey, json.encode(data));
        return _mapToUser(appUser.uid, appUser.email, appUser.role, data);
      }
    } catch (e) {
      debugPrint('UserDataNotifier: Initial fetch failed ($e).');
    }

    return null;
  }

  /// Performs backend fetch and synchronization without blocking the UI.
  Future<void> _syncWithBackendInBackground(
    AppUser appUser,
    model.User localUser,
    String localDataString,
  ) async {
    try {
      final token = await _storage.read(key: 'jwt');
      if (token == null) return;

      final fetchUrl = '$_baseUrl/users/${appUser.uid}';
      final response = await http
          .get(
            Uri.parse(fetchUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final localMap = json.decode(localDataString) as Map<String, dynamic>;

        if (!_areMapsEqual(localMap, data)) {
          debugPrint(
            'UserDataNotifier Sync: Local data differs. Syncing local -> backend.',
          );
          await _updateBackend(appUser.uid, localMap);
        } else {
          debugPrint('UserDataNotifier Sync: Local and backend are in sync.');
        }
      }
    } catch (e) {
      debugPrint(
        'UserDataNotifier Sync: Backend unreachable, staying offline-only.',
      );
    }
  }

  bool _areMapsEqual(Map<String, dynamic> m1, Map<String, dynamic> m2) {
    // Check relevant contact fields for equality
    final keys = [
      'phone',
      'wsPhone',
      'phoneEnabled',
      'wsPhoneEnabled',
      'emailEnabled',
    ];
    for (final key in keys) {
      if (m1[key] != m2[key]) return false;
    }
    return true;
  }

  Future<void> _updateBackend(String uid, Map<String, dynamic> data) async {
    try {
      final token = await _storage.read(key: 'jwt');
      await http.patch(
        Uri.parse('$_baseUrl/users/$uid/contacts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'phone': data['phone'],
          'wsPhone': data['wsPhone'],
          'phoneEnabled': data['phoneEnabled'],
          'wsPhoneEnabled': data['wsPhoneEnabled'],
          'emailEnabled': data['emailEnabled'],
        }),
      );
    } catch (e) {
      debugPrint('Sync Error: Failed to update backend with local data: $e');
    }
  }

  model.User _mapToUser(
    String uid,
    String email,
    String role,
    Map<String, dynamic> data,
  ) {
    if (role == 'Etudiant') {
      return Student(
        id: uid,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: email,
        department: data['department'] ?? '',
        level: data['level'] ?? 1,
        phone: data['phone'],
        wsPhone: data['wsPhone'],
        phoneEnabled: data['phoneEnabled'] ?? false,
        wsPhoneEnabled: data['wsPhoneEnabled'] ?? false,
        emailEnabled: data['emailEnabled'] ?? true,
      );
    } else {
      return Teacher(
        id: uid,
        firstName: data['firstName'] ?? '',
        lastName: data['lastName'] ?? '',
        email: email,
        department: data['department'] ?? '',
        phone: data['phone'],
        wsPhone: data['wsPhone'],
        phoneEnabled: data['phoneEnabled'] ?? false,
        wsPhoneEnabled: data['wsPhoneEnabled'] ?? false,
        emailEnabled: data['emailEnabled'] ?? true,
      );
    }
  }

  Future<void> updateContacts({
    String? phone,
    String? wsPhone,
    required bool phoneEnabled,
    required bool wsPhoneEnabled,
    required bool emailEnabled,
  }) async {
    final authState = ref.read(authProvider);
    final appUser = authState.value;
    if (appUser == null) {
      debugPrint('updateContacts Error: No authenticated user found.');
      return;
    }

    final contactData = {
      'phone': phone,
      'wsPhone': wsPhone,
      'phoneEnabled': phoneEnabled,
      'wsPhoneEnabled': wsPhoneEnabled,
      'emailEnabled': emailEnabled,
    };

    debugPrint('updateContacts: Saving locally for ${appUser.email}...');
    // 1. Update Locally first
    final prefs = await SharedPreferences.getInstance();
    String? localDataString = prefs.getString(_localUserKey);
    Map<String, dynamic> data = {};
    if (localDataString != null) {
      data = json.decode(localDataString) as Map<String, dynamic>;
    }
    data.addAll(contactData);
    await prefs.setString(_localUserKey, json.encode(data));

    // Invalidate state so UI shows local change immediately
    ref.invalidateSelf();

    // 2. Update Backend
    try {
      final token = await _storage.read(key: 'jwt');
      final patchUrl = '$_baseUrl/users/${appUser.uid}/contacts';
      debugPrint('updateContacts: Patching backend');

      final response = await http.patch(
        Uri.parse(patchUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(contactData),
      );
      debugPrint(
        'updateContacts: Backend responded with ${response.statusCode}',
      );
    } catch (e) {
      debugPrint('updateContacts Error: Failed to update backend ($e)');
    }
  }
}

final userDataProvider = AsyncNotifierProvider<UserDataNotifier, model.User?>(
  () {
    return UserDataNotifier();
  },
);
