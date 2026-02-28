import 'package:flutter/material.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/features/shared/card_widgets.dart';

class TeacherInternshipPage extends StatefulWidget {
  const TeacherInternshipPage({super.key});

  @override
  State<TeacherInternshipPage> createState() => _TeacherInternshipPageState();
}

class _TeacherInternshipPageState extends State<TeacherInternshipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Stages Supervisés'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 24) +
              const EdgeInsets.only(top: 8),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Chercher un stage ou un étudiant',
                        prefixIcon: const Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.filter_list_rounded),
                  ),
                ],
              ),
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
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        intershipCard(
                          Internship(
                              companyName: 'Tech Solutions Inc.',
                              description:
                                  'Développement d\'une application mobile pour la gestion des tâches.',
                              position: 'Développeur Flutter',
                              startDate: DateTime(2026, 6, 1),
                              endDate: DateTime(2026, 8, 31),
                              status: InternshipStatus.pasCommance,
                              tags: [
                                InternshipTag.softwareDevelopment,
                                InternshipTag.flutter,
                                InternshipTag.mobileApp,
                              ],
                            )
                            ..supervisorTeacher = Teacher(
                              id: 'TI001',
                              firstName: 'NAFFAA',
                              lastName: 'HAFFAR',
                              email: 'naffaa.haffar@isimm-rnu.tn',
                              department: 'Informatique',
                            ),
                        ),
                        intershipCard(
                          Internship(
                              companyName: 'Tech Solutions Inc.',
                              description:
                                  'Développement d\'une application mobile pour la gestion des tâches.',
                              position: 'Développeur Flutter',
                              startDate: DateTime(2026, 6, 1),
                              endDate: DateTime(2026, 8, 31),
                              status: InternshipStatus.pasCommance,
                              tags: [
                                InternshipTag.softwareDevelopment,
                                InternshipTag.flutter,
                                InternshipTag.mobileApp,
                              ],
                            )
                            ..supervisorTeacher = Teacher(
                              id: 'TI001',
                              firstName: 'NAFFAA',
                              lastName: 'HAFFAR',
                              email: 'naffaa.haffar@isimm-rnu.tn',
                              department: 'Informatique',
                            ),
                        ),
                        intershipCard(
                          Internship(
                            companyName: 'Tech Solutions Inc.',
                            description:
                                'Développement d\'une application mobile pour la gestion des tâches.',
                            position: 'Développeur Flutter',
                            startDate: DateTime(2026, 6, 1),
                            endDate: DateTime(2026, 8, 31),
                            status: InternshipStatus.pasCommance,
                            tags: [
                              InternshipTag.softwareDevelopment,
                              InternshipTag.flutter,
                              InternshipTag.mobileApp,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
