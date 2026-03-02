import 'package:flutter/material.dart';
import 'package:pfa/core/models/student.dart';
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
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
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
                  decoration: const BoxDecoration(
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
                          context,
                          viewType: InternshipCardViewType.teacher,
                          internship: Internship(
                            companyName: 'Tech Solutions Inc.',
                            description:
                                'Développement d\'une application mobile pour la gestion des tâches.',
                            position: 'Développeur Flutter',
                            startDate: DateTime(2026, 6, 1),
                            endDate: DateTime(2026, 8, 31),
                            status: InternshipStatus.pasCommance,
                            internStudent: Student(
                              id: "S001",
                              firstName: "Chedy Amine",
                              lastName: "El Haj",
                              email: "elhaj@isimm.me",
                              department: "Informatique",
                              level: 3,
                            ),
                            supervisorTeacher: Teacher(
                              id: 'TI001',
                              firstName: 'NAFFAA',
                              lastName: 'HAFFAR',
                              email: 'naffaa.haffar@isimm-rnu.tn',
                              department: 'Informatique',
                            ),
                          ),
                        ),
                        intershipCard(
                          context,
                          viewType: InternshipCardViewType.teacher,
                          internship: Internship(
                            companyName: 'Tech Solutions Inc.',
                            description:
                                'Développement d\'une application mobile pour la gestion des tâches.',
                            position: 'Développeur Flutter',
                            startDate: DateTime(2026, 6, 1),
                            endDate: DateTime(2026, 8, 31),
                            status: InternshipStatus.pasCommance,
                            internStudent: Student(
                              id: "S002",
                              firstName: "Zied",
                              lastName: "Mabrouk",
                              email: "zied.mabrouk@isimm.me",
                              department: "Informatique",
                              level: 3,
                            ),
                            supervisorTeacher: Teacher(
                              id: 'TI001',
                              firstName: 'NAFFAA',
                              lastName: 'HAFFAR',
                              email: 'naffaa.haffar@isimm-rnu.tn',
                              department: 'Informatique',
                            ),
                          ),
                        ),
                        intershipCard(
                          context,
                          viewType: InternshipCardViewType.teacher,
                          internship: Internship(
                            companyName: 'Tech Solutions Inc.',
                            description:
                                'Développement d\'une application mobile pour la gestion des tâches.',
                            position: 'Développeur Flutter',
                            startDate: DateTime(2026, 6, 1),
                            endDate: DateTime(2026, 8, 31),
                            status: InternshipStatus.pasCommance,
                            internStudent: Student(
                              id: "S003",
                              firstName: "Ahmed",
                              lastName: "Hafssi",
                              email: "ahmed.hafssi@isimm.me",
                              department: "Informatique",
                              level: 3,
                            ),
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
