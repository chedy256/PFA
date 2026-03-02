import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final digits = phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
          const SizedBox(width: 8),
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
          //if(student.phone != null)
          IconButton(
            onPressed: () =>
                _launchPhone('52000000'), //TODO: replace with supervisor.phone
            icon: Icon(Icons.phone_outlined, color: AppColors.green),
          ),
          IconButton(
            onPressed: () => _launchWhatsApp('52000000'),
            icon: FaIcon(FontAwesomeIcons.whatsapp, color: AppColors.green),
          ),
          IconButton(
            onPressed: () => _launchEmail(student.email),
            icon: Icon(Icons.email_outlined, color: AppColors.green),
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
          const SizedBox(width: 8),
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
          if (internship.status !=
              InternshipStatus
                  .enAttente) //will add verification for phone availability for each if
            IconButton(
              onPressed: () => _launchPhone(
                '52000000',
              ), //TODO: replace with supervisor.phone
              icon: Icon(
                Icons.phone_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
          if (internship.status != InternshipStatus.enAttente)
            IconButton(
              onPressed: () => _launchWhatsApp('52000000'),
              icon: FaIcon(
                FontAwesomeIcons.whatsapp,
                color: theme.colorScheme.primary,
              ),
            ),
          IconButton(
            onPressed: () => _launchEmail(supervisor.email),
            icon: Icon(Icons.email_outlined, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
