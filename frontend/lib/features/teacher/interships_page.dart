import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/providers/auth_provider.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/features/shared/profile_page.dart';

class IntershipsPage extends ConsumerStatefulWidget {
  const IntershipsPage({super.key});

  @override
  ConsumerState<IntershipsPage> createState() => _IntershipsPageState();
}

class _IntershipsPageState extends ConsumerState<IntershipsPage> {
  int _currentIndex = 0;

  Widget _buildHomePage() {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 24) +
            const EdgeInsets.only(top: 24),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            welcomeWidget(context, ref, 'NAFFA', 'HAFFAR'),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Rechercher un stage ou un étudiant',
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
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      intershipCard(null, null),
                      intershipCard(null, null),
                      intershipCard(null, null),
                      intershipCard(null, null),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      Container(color: Colors.green), // My Internships
      ProfilePage(user: Teacher(id: 'TI001', firstName: 'NAFFA', lastName: 'HAFFAR', email: 'naffa.haffar@isimm-rnu.tn', department: 'Informatique')), // Profile
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

InkWell intershipCard(Internship? internship, Teacher? supervisor) {
  //dump data for testing only
  Internship test = Internship(
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
  );
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
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                internship.position,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              internship.supervisorTeacher == null
                  ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(200, 230, 201, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Non Assigné',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(46, 125, 50, 1),
                  ),
                ),
              )
                  :
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 242, 198, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Assigné',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 186, 36, 1),
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
          internship.supervisorTeacher != null
              ? Container(
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
                        '${internship.supervisorTeacher!.firstName} ${internship.supervisorTeacher!.lastName}',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
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
            'Bienvenue,',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            'Mr. $lastName $firstName',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey.shade300,
        child: Text(
          '${firstName[0]}${lastName[0]}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.3,
          ),
        ),
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
  );
}
