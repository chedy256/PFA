import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/features/shared/card_widgets.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
              // Placeholder for the internship card - replace with actual data when available Initial State.
              intershipCard(
                viewType: InternshipCardViewType.student,
                context,
                internship: null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "Actions Rapides",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: theme.textTheme.titleLarge!.color,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                            spacing: 12,
                            crossAxisAlignment: .start,
                            children: [
                              _quickActionCard(
                                context,
                                Icons.download,
                                'Documents officiels',
                                'Télécharger vos documents de stage',
                                () {},
                              ),
                              _quickActionCard(
                                context,
                                Icons.document_scanner,
                                'Demander des Documents',
                                'Demander des documents de stage',
                                () {},
                              ),
                              _quickActionCard(
                                context,
                                Icons.upload_file,
                                'Rapport de Stage',
                                'Envoyer votre rapport de stage',
                                () {},
                              ),
                              _quickActionCard(
                                context,
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

Material _quickActionCard(
  BuildContext context,
  IconData icon,
  String title,
  String subtitle,
  VoidCallback onTap,
) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Material(
    color: theme.cardTheme.color,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 2,
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
        boxShadow: [
          if (!isDark)
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
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: theme.textTheme.bodyMedium?.color,
              height: 1.4,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: theme.iconTheme.color?.withValues(alpha: 0.5),
          ),
        ),
      ),
    ),
  );
}
