abstract class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String department;
  final String? phone;
  final String? wsPhone;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
    this.phone,
    this.wsPhone,
  });
}
