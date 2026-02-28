import 'package:pfa/core/models/internship.dart';
import 'package:pfa/core/models/user.dart';

class Student extends User {
  final int level;
  Internship? currentIntership;
  Student({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.department,
    required this.level,
    this.currentIntership,
  });
}
