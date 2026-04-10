import 'package:pfa/core/models/internship.dart';
import 'package:pfa/core/models/user.dart';

class Teacher extends User {
  List<Internship> interships = [];
  Teacher({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.department,
    super.phone,
    super.wsPhone,
    super.phoneEnabled,
    super.wsPhoneEnabled,
    super.emailEnabled,
  });
}
