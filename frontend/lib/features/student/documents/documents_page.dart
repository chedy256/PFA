import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'request_document_page.dart';

class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Mes Documents',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withValues(
            alpha: 0.6,
          ),
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          dividerColor: theme.scaffoldBackgroundColor,
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download),
                  SizedBox(width: 8),
                  Text('Télécharger'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload),
                  SizedBox(width: 8),
                  Text('Déposer'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDownloadTab(context, theme, isDark),
          _buildUploadTab(context, theme, isDark),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RequestDocumentPage(),
                  ),
                );
              },
              backgroundColor: theme.colorScheme.primary,
              elevation: 4,
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                'Demander',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildDownloadTab(BuildContext context, ThemeData theme, bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDocumentItem(
          theme: theme,
          isDark: isDark,
          title: "Lettre d'appui de l'ISIMM",
          status: 'Prêt',
          date: DateTime.now(),
          icon: Icons.description,
          onTap: () {},
        ),
        _buildDocumentItem(
          theme: theme,
          isDark: isDark,
          title: "Instructions pour les lettres d'appui SFE/PFE",
          status: 'Prêt',
          date: DateTime.now(),
          icon: Icons.description,
          onTap: () {},
        ),
        _buildDocumentItem(
          theme: theme,
          isDark: isDark,
          title: "Fiche d'information du stage",
          status: 'En cours',
          date: DateTime(2026, 2, 25),
          icon: Icons.hourglass_empty,
          isPending: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildUploadTab(BuildContext context, ThemeData theme, bool isDark) {
    return Center(
      child: Text("N'affiche rien s'il n'y a pas encore de stage."),
    );
  }

  Widget _buildDocumentItem({
    required ThemeData theme,
    required bool isDark,
    required String title,
    required String status,
    DateTime? date,
    required IconData icon,
    bool isPending = false,
    required VoidCallback onTap,
  }) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final formattedDate = dateFormat.format(date ?? DateTime.now());
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isPending
                ? AppColors.yellow.withValues(alpha: 0.15)
                : AppColors.green.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isPending ? AppColors.yellow : AppColors.green,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.6,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.6,
                  ),
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPending
                      ? AppColors.yellow.withValues(alpha: 0.1)
                      : AppColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isPending
                        ? AppColors.yellow.withValues(alpha: 0.5)
                        : AppColors.green.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isPending ? AppColors.yellow : AppColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        trailing: isPending
            ? null
            : IconButton(
                icon: Icon(
                  Icons.download_rounded,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                onPressed: onTap,
              ),
      ),
    );
  }
}
