import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                              id: 'TI002',
                              firstName: 'Flen',
                              lastName: 'Ben Flen',
                              email: 'flen.benflen@isimm-rnu.tn',
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
                              id: 'TI002',
                              firstName: 'NAFFA',
                              lastName: 'HAFFAR',
                              email: 'naffa.haffar@isimm-rnu.tn',
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.blue,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
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
    );
  }
}
