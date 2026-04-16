import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/services/internship_service.dart';

final internshipServiceProvider = Provider((ref) => InternshipService());

final internshipsProvider = FutureProvider<List<Internship>>((ref) async {
  final service = ref.watch(internshipServiceProvider);
  final data = await service.getInternships();

  return data.map((json) {
    // Parse backend JSON to Internship model.
    // Ensure the JSON matches your FastAPI response schema.
    return Internship(
      companyName: json['companyName'] ?? 'Unknown Company',
      description: json['description'] ?? '',
      position: json['title'] ?? json['position'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      status: _parseStatus(json['status']),
      internStudent: json['student'] != null
          ? Student(
              id: json['student']['id'] ?? '',
              firstName: json['student']['firstName'] ?? '',
              lastName: json['student']['lastName'] ?? '',
              email: json['student']['email'] ?? '',
              department: json['student']['department'] ?? '',
              level: json['student']['level'] ?? 1,
            )
          : Student(
              id: 'unknown',
              firstName: 'Unknown',
              lastName: 'Student',
              email: '',
              department: '',
              level: 1,
            ),
      supervisorTeacher: json['teacher'] != null
          ? Teacher(
              id: json['teacher']['id'] ?? '',
              firstName: json['teacher']['firstName'] ?? '',
              lastName: json['teacher']['lastName'] ?? '',
              email: json['teacher']['email'] ?? '',
              department: json['teacher']['department'] ?? '',
            )
          : null,
    );
  }).toList();
});

InternshipStatus _parseStatus(String? status) {
  switch (status) {
    case 'enCours':
      return InternshipStatus.enCours;
    case 'terminee':
      return InternshipStatus.terminee;
    case 'enAttente':
      return InternshipStatus.enAttente;
    case 'pasCommance':
    default:
      return InternshipStatus.pasCommance;
  }
}
