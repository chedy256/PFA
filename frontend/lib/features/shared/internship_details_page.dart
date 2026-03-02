import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/core/theme/app_colors.dart';

class InternshipDetailsPage extends StatelessWidget {
  final Internship internship;
  const InternshipDetailsPage({super.key, required this.internship});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Détails du Stage'),
        centerTitle: true,
        backgroundColor: theme.cardTheme.color,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(theme, isDark),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                spacing: 24, // Main spacing between sections
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group Title + Content with tighter spacing
                  Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Description', theme),
                      _buildDescriptionCard(theme, isDark),
                    ],
                  ),
                  Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Informations', theme),
                      _buildInfoGrid(theme, isDark),
                    ],
                  ),
                  Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Compétences & Tags', theme),
                      _buildTagsCloud(theme, isDark),
                    ],
                  ),
                  Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Stagiaire', theme),
                      _buildStudentCard(theme, isDark),
                    ],
                  ),
                  if (internship.supervisorTeacher != null)
                    Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Encadrement', theme),
                        _buildSupervisorCard(theme, isDark),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.work_outline,
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            internship.position,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.displaySmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            internship.companyName,
            style: TextStyle(
              fontSize: 18,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: internship.status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: internship.status.color.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        internship.status.displayName,
        style: TextStyle(
          color: internship.status.color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildDescriptionCard(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
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
      child: Text(
        internship.description.isEmpty
            ? 'Aucune description fournie.'
            : internship.description,
        style: TextStyle(
          fontSize: 15,
          color: theme.textTheme.bodyMedium?.color,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildInfoGrid(ThemeData theme, bool isDark) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _buildInfoTile(
          theme,
          isDark,
          Icons.calendar_today,
          'Début',
          dateFormat.format(internship.startDate),
        ),
        _buildInfoTile(
          theme,
          isDark,
          Icons.calendar_today,
          'Fin',
          dateFormat.format(internship.endDate),
        ),
      ],
    );
  }

  Widget _buildInfoTile(
    ThemeData theme,
    bool isDark,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        theme.textTheme.bodySmall?.color ??
                        (isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsCloud(ThemeData theme, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: internship.tags
          .map((tag) => _buildTag(theme, isDark, tag.name))
          .toList(),
    );
  }

  Widget _buildTag(ThemeData theme, bool isDark, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Text(
        '#$name',
        style: TextStyle(
          fontSize: 13,
          color: theme.textTheme.bodyMedium?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStudentCard(ThemeData theme, bool isDark) {
    final student = internship.internStudent;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.green.withValues(alpha: 0.1),
            child: Text(
              '${student.firstName[0]}${student.lastName[0]}',
              style: const TextStyle(
                color: AppColors.green,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.firstName} ${student.lastName}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                Text(
                  '${student.department} - L${student.level}',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.email_outlined, color: AppColors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildSupervisorCard(ThemeData theme, bool isDark) {
    final supervisor = internship.supervisorTeacher!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Text(
              '${supervisor.firstName[0]}${supervisor.lastName[0]}',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${supervisor.firstName} ${supervisor.lastName}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
                Text(
                  supervisor.department,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
