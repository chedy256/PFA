import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class InternshipService {
  final ApiClient _apiClient = ApiClient();

  /// Retrieves internships.
  Future<List<dynamic>> getInternships() async {
    try {
      final token = await FirebaseAuth.instance.currentUser?.getIdToken();
      print('--- DEBUG: Fetching Internships ---');
      if (kDebugMode) {
        print('Firebase Token: $token');
      }

      final response = await _apiClient.get(ApiEndpoints.internships);
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else if (response.statusCode == 404) {
        print(
          'No internships found (404). Returning empty list so user can post one.',
        );
        return [];
      } else {
        throw Exception('Failed to fetch internships: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching internships: $e');
      rethrow;
    }
  }

  /// Allows a student to propose or create a new internship.
  Future<Map<String, dynamic>> createInternship({
    required String title,
    required String description,
    String? type,
    String? companyName,
    String? companyAddress,
    String? companySector,
    String? companyPhone,
    String? supervisorName,
    String? supervisorEmail,
    String? supervisorFunction,
  }) async {
    final Map<String, dynamic> body = {
      'title': title,
      'description': description,
    };

    if (type != null) body['type'] = type;
    if (companyName != null) body['company_name'] = companyName;
    if (companyAddress != null) body['company_address'] = companyAddress;
    if (companySector != null) body['company_sector'] = companySector;
    if (companyPhone != null) body['company_phone'] = companyPhone;
    if (supervisorName != null) body['supervisor_name'] = supervisorName;
    if (supervisorEmail != null) body['supervisor_email'] = supervisorEmail;
    if (supervisorFunction != null) {
      body['supervisor_function'] = supervisorFunction;
    }

    final response = await _apiClient.post(
      ApiEndpoints.internships,
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create internship: ${response.statusCode}');
    }
  }
}
