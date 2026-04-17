import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/network/api_client.dart';

final teachersProvider = FutureProvider<List<Teacher>>((ref) async {
  final apiClient = ApiClient();
  try {
    final response = await apiClient.get('/users/role/teacher');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (json) => Teacher(
              id: json['id'] ?? '',
              firstName: json['firstName'] ?? '',
              lastName: json['lastName'] ?? '',
              email: json['email'] ?? '',
              department: json['department'] ?? '',
            ),
          )
          .toList();
    }
  } catch (e) {
    // Ignore error or log it
  }
  return []; // Return empty if error or not allowed
});
