import 'package:flutter/material.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/theme/app_colors.dart';

enum InternshipStatus {
  enCours,
  terminee,
  pasCommance,
  enAttente;

  String get displayName {
    switch (this) {
      case InternshipStatus.enCours:
        return 'En Cours';
      case InternshipStatus.terminee:
        return 'Terminée';
      case InternshipStatus.pasCommance:
        return 'Pas Commencé';
      case InternshipStatus.enAttente:
        return 'En Attente';
    }
  }

  Color get color {
    switch (this) {
      case InternshipStatus.enCours:
        return AppColors.blue;
      case InternshipStatus.terminee:
        return AppColors.green;
      case InternshipStatus.pasCommance:
        return AppColors.yellow;
      case InternshipStatus.enAttente:
        return AppColors.purple;
    }
  }
}

class Internship {
  List<Teacher>? pendingTeachers = [];
  Teacher? supervisorTeacher;
  final Student internStudent;
  final String companyName;
  final String position;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final InternshipStatus status;

  Internship({
    required this.companyName,
    required this.position,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.status,
    required this.internStudent,
    this.pendingTeachers,
    this.supervisorTeacher,
  });
}
