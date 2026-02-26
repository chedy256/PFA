import 'package:pfa/core/models/internship.dart';

class Student {
  String firstName = '';
  String lastName = '';
  String email = '';
  String department = '';
  String level = '';
  Internship? currentIntership;
  Student({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.department,
    required this.level,
    this.currentIntership,
  });
}