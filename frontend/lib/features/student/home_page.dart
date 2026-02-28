import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/features/shared/card_widgets.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  //dump data for testing only
  Teacher supervisor = Teacher(
    id: 'T002',
    firstName: 'Dr. Sarah',
    lastName: 'Johnson',
    email: 'sarah.johnson@university.edu',
    department: 'Informatique',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(),
              welcomeWidget(
                context,
                ref,
                Student(
                  id: 'S001',
                  firstName: 'Chedy Amine',
                  lastName: 'El Haj',
                  email: 'elhaj.chedyamine@isimm.me',
                  department: 'Informatique',
                  level: 3,
                ),
              ),
              intershipCard(
                context,
                Internship(
                  companyName: 'Tech Solutions Inc.',
                  description:
                      'Développement d\'une application mobile pour la gestion des tâches.',
                  position: 'Développeur Flutter',
                  startDate: DateTime(2026, 6, 1),
                  endDate: DateTime(2026, 8, 31),
                  status: InternshipStatus.enCours,
                  internStudent: Student(
                    id: 'S001',
                    firstName: 'Chedy Amine',
                    lastName: 'El Haj',
                    email: 'elhaj.chedyamine@isimm.me',
                    department: 'Informatique',
                    level: 3,
                  ),
                  tags: [
                    InternshipTag.softwareDevelopment,
                    InternshipTag.flutter,
                    InternshipTag.mobileApp,
                  ],
                )..supervisorTeacher = supervisor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const Text(
                      "Actions Rapides",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 24),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            spacing: 8,
                            crossAxisAlignment: .start,
                            children: [
                              _quickActionCard(
                                Icons.download,
                                'Documents officiels',
                                'Télécharger vos documents de stage',
                                () {},
                              ),
                              _quickActionCard(
                                Icons.document_scanner,
                                'Demander des Documents',
                                'Demander des documents de stage',
                                () {},
                              ),
                              _quickActionCard(
                                Icons.upload_file,
                                'Rapport de Stage',
                                'Envoyer votre rapport de stage',
                                () {},
                              ),
                              _quickActionCard(
                                Icons.access_time_outlined,
                                'Journal de Stage',
                                'Consulter votre journal de stage',
                                () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Container _quickActionCard(
  IconData icon,
  String title,
  String subtitle,
  VoidCallback onTap,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.blue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.blue, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textGrey),
        ),
      ),
    ),
  );
}
