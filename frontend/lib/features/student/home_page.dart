import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/core/providers/auth_provider.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(),
              welcomeWidget(context, ref, 'Chedy Amine', 'El Haj'),
              intershipCard(null, null),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    const Text(
                      "Actions Rapides",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
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
                            quickActionCard(
                              Icons.download,
                              'Documents officiels',
                              'Télécharger vos documents de stage',
                              () {},
                            ),
                            quickActionCard(
                              Icons.document_scanner,
                              'Demander des Documents',
                              'Demander des documents de stage',
                              () {},
                            ),
                            quickActionCard(
                              Icons.upload_file,
                              'Rapport de Stage',
                              'Envoyer votre rapport de stage',
                              () {},
                            ),
                            quickActionCard(
                              Icons.access_time_outlined,
                              'Journal de Stage',
                              'Consulter votre journal de stage',
                              () {},
                            ),
                          ],
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

Card quickActionCard(
  IconData icon,
  String title,
  String subtitle,
  VoidCallback onTap,
) {
  return Card(
    color: AppColors.background,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
    ),
  );
}

InkWell intershipCard(Internship? internship, Teacher? supervisor) {
  //dump data for testing only
  Internship test = Internship(
    companyName: 'Tech Solutions Inc.',
    description:
        'Développement d\'une application mobile pour la gestion des tâches.',
    position: 'Développeur Flutter',
    startDate: DateTime(2026, 6, 1),
    endDate: DateTime(2026, 8, 31),
    status: InternshipStatus.enCours,
    tags: [
      InternshipTag.softwareDevelopment,
      InternshipTag.flutter,
      InternshipTag.mobileApp,
    ],
  );
  Teacher testSupervisor = Teacher(
    firstName: 'Dr. Sarah',
    lastName: 'Johnson',
    email: 'sarah.johnson@university.edu',
    department: 'Informatique',
  );
  supervisor = testSupervisor;
  test.supervisorTeacher = supervisor;
  internship = test;
  return InkWell(
    onTap: () {
      //open internship details page
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: (internship == null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Stage en cours',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Aucun stage en cours',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                TextButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    alignment: Alignment.center,
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Postuler votre stage',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ),
              ],
            )
          : Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      internship.position,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        internship.status.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  internship.companyName,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Text(
                  internship.description,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Encadré par:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${internship.supervisorTeacher?.firstName ?? 'Pas encore assigné'} ${internship.supervisorTeacher?.lastName ?? ''}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    ),
  );
}

Widget welcomeWidget(
  BuildContext context,
  WidgetRef ref,
  String firstName,
  String lastName,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenue !',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            '$firstName $lastName,',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person_3_rounded, size: 42, color: Colors.black),
          ),
          IconButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon: const Icon(Icons.logout, size: 32, color: Colors.red),
          ),
        ],
      ),
    ],
  );
}
