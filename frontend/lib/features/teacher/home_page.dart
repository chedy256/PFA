import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/features/shared/card_widgets.dart';
import 'package:pfa/features/shared/profile_page.dart';
import 'package:pfa/features/teacher/internship_page.dart';
import 'package:pfa/core/providers/internship_provider.dart';
import 'package:pfa/core/providers/user_data_provider.dart';

class TeacherHomePage extends ConsumerStatefulWidget {
  const TeacherHomePage({super.key});

  @override
  ConsumerState<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends ConsumerState<TeacherHomePage> {
  int _currentIndex = 0;

  Widget _buildHomePage() {
    final internshipsAsync = ref.watch(internshipsProvider);
    final userAsync = ref.watch(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: userAsync.when(
          data: (user) => Text(
            'Bienvenue, Mr. ${user?.firstName ?? ''}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          loading: () => const Text('Bienvenue...'),
          error: (err, _) => const Text('Bienvenue'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Chercher un stage ou un étudiant',
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
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
                  child: internshipsAsync.when(
                    data: (internships) {
                      if (internships.isEmpty) {
                        return const Center(child: Text("Aucun stage trouvé."));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: internships.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return intershipCard(
                            context,
                            viewType: InternshipCardViewType
                                .teacherPendingInternships,
                            internship: internships[index],
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text("Erreur: $error")),
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
    final userAsync = ref.watch(userDataProvider);

    final List<Widget> pages = [
      _buildHomePage(),
      const TeacherInternshipPage(), // My Internships
      userAsync.when(
        data: (user) => user != null
            ? ProfilePage(user: user)
            : const Center(child: Text('User profile not found')),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) =>
            Scaffold(body: Center(child: Text('Error: $error'))),
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
