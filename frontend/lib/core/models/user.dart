abstract class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String department;
  final String? phone;
  final String? wsPhone;
  final bool phoneEnabled;
  final bool wsPhoneEnabled;
  final bool emailEnabled;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
    this.phone,
    this.wsPhone,
    this.phoneEnabled = true,
    this.wsPhoneEnabled = true,
    this.emailEnabled = true,
  });
}
