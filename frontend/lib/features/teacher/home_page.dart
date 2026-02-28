import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/features/shared/card_widgets.dart';
import 'package:pfa/features/shared/profile_page.dart';
import 'package:pfa/features/teacher/internship_page.dart';

class TeacherHomePage extends ConsumerStatefulWidget {
  const TeacherHomePage({super.key});

  @override
  ConsumerState<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends ConsumerState<TeacherHomePage> {
  int _currentIndex = 0;

  Widget _buildHomePage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bienvenue, Mr. NAFFAA',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
                          Internship(
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
                              tags: [
                                InternshipTag.softwareDevelopment,
                                InternshipTag.flutter,
                                InternshipTag.mobileApp,
                              ],
                            )
                            ..supervisorTeacher = Teacher(
                              id: 'TI002',
                              firstName: 'Flen',
                              lastName: 'Ben Flen',
                              email: 'flen.benflen@isimm-rnu.tn',
                              department: 'Informatique',
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
                              status: InternshipStatus.pasCommance,
                              internStudent: Student(
                                id: "S001",
                                firstName: "Chedy Amine",
                                lastName: "El Haj",
                                email: "elhaj@isimm.me",
                                department: "Informatique",
                                level: 3,
                              ),
                              tags: [
                                InternshipTag.softwareDevelopment,
                                InternshipTag.flutter,
                                InternshipTag.mobileApp,
                              ],
                            )
                            ..supervisorTeacher = Teacher(
                              id: 'TI002',
                              firstName: 'NAFFA',
                              lastName: 'HAFFAR',
                              email: 'naffa.haffar@isimm-rnu.tn',
                              department: 'Informatique',
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
                            status: InternshipStatus.pasCommance,
                            internStudent: Student(
                              id: "S001",
                              firstName: "Chedy Amine",
                              lastName: "El Haj",
                              email: "elhaj@isimm.me",
                              department: "Informatique",
                              level: 3,
                            ),
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      TeacherInternshipPage(), // My Internships
      ProfilePage(
        user: Teacher(
          id: 'TI001',
          firstName: 'NAFFA',
          lastName: 'HAFFAR',
          email: 'naffa.haffar@isimm-rnu.tn',
          department: 'Informatique',
        ),
      ),
      // Profile
    ];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: BottomNavigationBar(
            elevation: 4,
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme.cardTheme.color,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_rounded),
                label: 'Mes stages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_3_rounded),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
