import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';

enum InternshipStatus { enCours, terminee, pasCommance, enAttente }
enum InternshipTag {
  softwareDevelopment,
  flutter,
  mobileApp,
  backend,
  frontend,
  devOps,
  ciCd,
  database,
}

class Internship {
  Teacher? supervisorTeacher;
  Student? internStudent;
  String companyName = 'Tech Solutions Inc.';
  String position = 'Software Engineering Intern';
  DateTime startDate = DateTime(2026, 6, 1);
  DateTime endDate = DateTime(2026, 8, 31);
  String description = '';
  InternshipStatus status = InternshipStatus.enCours;
  List<InternshipTag> tags = [
    InternshipTag.softwareDevelopment,
    InternshipTag.flutter,
    InternshipTag.mobileApp,
  ];

  Internship({
    required this.companyName,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.status,
    required this.tags, // Make tags required in the constructor
  });

  // Optional: Convert tags to user-friendly strings
  List<String> getTagNames() {
    return tags.map((tag) => tag.name).toList();
  }
}

