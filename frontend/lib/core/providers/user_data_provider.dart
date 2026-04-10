import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/models/user.dart' as model;
import 'package:pfa/core/providers/auth_provider.dart';

class UserDataNotifier extends AsyncNotifier<model.User?> {
  final String _baseUrl = 'http://'; // backend API base URL
  final _storage = const FlutterSecureStorage();

  @override
  Future<model.User?> build() async {
    final authState = ref.watch(authProvider);
    final appUser = authState.value;

    if (appUser == null) {
      return null;
    }

    try {
      final token = await _storage.read(key: 'jwt');
      final response = await http.get(
        Uri.parse('$_baseUrl/users/${appUser.uid}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = json.decode(utf8.decode(response.bodyBytes));
      final role = appUser.role;

      if (role == 'Etudiant') {
        return Student(
          id: appUser.uid,
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          email: appUser.email,
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
          id: appUser.uid,
          firstName: data['firstName'] ?? '',
          lastName: data['lastName'] ?? '',
          email: appUser.email,
          department: data['department'] ?? '',
          phone: data['phone'],
          wsPhone: data['wsPhone'],
          phoneEnabled: data['phoneEnabled'] ?? false,
          wsPhoneEnabled: data['wsPhoneEnabled'] ?? false,
          emailEnabled: data['emailEnabled'] ?? true,
        );
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> updateContacts({
    String? phone,
    String? wsPhone,
    required bool phoneEnabled,
    required bool wsPhoneEnabled,
    required bool emailEnabled,
  }) async {
    final appUser = ref.read(authProvider).value;
    if (appUser == null) return;

    try {
      final token = await _storage.read(key: 'jwt');
      await http.patch(
        Uri.parse('$_baseUrl/users/${appUser.uid}/contacts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'phone': phone,
          'wsPhone': wsPhone,
          'phoneEnabled': phoneEnabled,
          'wsPhoneEnabled': wsPhoneEnabled,
          'emailEnabled': emailEnabled,
        }),
      );

      ref.invalidateSelf();
    } catch (e) {
      // Handle error
    }
  }
}

final userDataProvider = AsyncNotifierProvider<UserDataNotifier, model.User?>(() {
  return UserDataNotifier();
});
