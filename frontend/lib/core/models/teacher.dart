import 'package:pfa/core/models/internship.dart';

class Teacher {
  String firstName = '';
  String lastName = '';
  String email = '';
  String department = '';
  Teacher({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
  });
  List<Internship> interships = [];
}