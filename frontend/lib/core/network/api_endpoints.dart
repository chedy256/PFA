class ApiEndpoints {
  static const String baseUrl = 'https://pfa-13qu.onrender.com/';

  // Auth endpoints
  static const String bootstrap = '/auth/bootstrap';
  static const String me = '/auth/me';
  static const String updateFcmToken = '/auth/fcm-token';

  // Internships endpoints
  static const String internships = '/internships/';

  // Notifications (Messages) endpoints
  static const String notifications = '/messages/';

  // Health
  static const String health = '/health';
}
