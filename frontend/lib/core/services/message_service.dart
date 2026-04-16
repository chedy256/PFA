import 'dart:convert';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class MessageService {
  final ApiClient _apiClient = ApiClient();

  /// Gets a list of notifications (messages where the current user is the receiver).
  Future<List<dynamic>> getNotifications() async {
    final response = await _apiClient.get(ApiEndpoints.notifications);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch notifications: ${response.statusCode}');
    }
  }
}
