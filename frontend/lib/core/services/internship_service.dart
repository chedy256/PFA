import 'dart:convert';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class InternshipService {
  final ApiClient _apiClient = ApiClient();

  /// Retrieves internships.
  Future<List<dynamic>> getInternships() async {
    final response = await _apiClient.get(ApiEndpoints.internships);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch internships: ${response.statusCode}');
    }
  }

  /// Allows a student to propose or create a new internship.
  Future<Map<String, dynamic>> createInternship(
    String title,
    String description,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.internships,
      body: {'title': title, 'description': description},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create internship: ${response.statusCode}');
    }
  }
}
