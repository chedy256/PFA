import 'dart:convert';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class BackendAuthService {
  final ApiClient _apiClient = ApiClient();

  /// Authenticate or initialize a session using the Firebase token
  Future<Map<String, dynamic>> bootstrap({
    String? fcmToken,
    String? role,
    String? firstName,
    String? lastName,
  }) async {
    final Map<String, dynamic> body = {};
    if (role != null) body['requested_role'] = role;
    if (fcmToken != null) body['fcm_token'] = fcmToken;
    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;

    final response = await _apiClient.post(ApiEndpoints.bootstrap, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to bootstrap auth: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Fetches the currently authenticated user's profile information
  Future<Map<String, dynamic>> getMe() async {
    final response = await _apiClient.get(ApiEndpoints.me);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to fetch user profile: ${response.statusCode} - ${response.body}',
      );
    }
  }

  /// Updates the user's Firebase Cloud Messaging token
  Future<void> updateFcmToken(String fcmToken) async {
    final response = await _apiClient.patch(
      ApiEndpoints.updateFcmToken,
      body: {'fcm_token': fcmToken},
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update FCM token: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
