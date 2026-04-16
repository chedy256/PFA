import 'dart:convert';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class MessageService {
  final ApiClient _apiClient = ApiClient();

  /// Gets a list of messages where the current user is the receiver.
  Future<List<dynamic>> getMessages() async {
    final response = await _apiClient.get(ApiEndpoints.messages);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch messages: ${response.statusCode}');
    }
  }

  /// Fetches the entire chat history between the current user and another user.
  Future<List<dynamic>> getConversation(String otherUserId) async {
    final response = await _apiClient.get(
      ApiEndpoints.conversation(otherUserId),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to fetch conversation: ${response.statusCode}');
    }
  }

  /// Sends a message to another user.
  Future<Map<String, dynamic>> sendMessage(
    String receiverId,
    String content,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.messages,
      body: {'receiver_id': receiverId, 'content': content},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }
}
