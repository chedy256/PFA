import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/models/user.dart';
import 'package:pfa/core/providers/auth_provider.dart';
import 'package:pfa/core/providers/theme_provider.dart';
import 'package:pfa/core/theme/app_fonts.dart';

Column infosSection(BuildContext context, User user) {
  final theme = Theme.of(context);

  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: CircleAvatar(
          radius: 56,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            user.firstName[0] + user.lastName[0],
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontFamily: AppFonts.outfit,
              letterSpacing: 2,
              fontSize: 48,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(
        '${user.firstName} ${user.lastName}',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: theme.textTheme.titleLarge?.color,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        user is Teacher
            ? 'Département: ${user.department}'
            : 'L${(user as Student).level} ${user.department}',
        style: TextStyle(fontSize: 18, color: theme.textTheme.bodyLarge?.color),
      ),
    ],
  );
}

class ProfileMenuTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 26, color: theme.textTheme.bodyLarge?.color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.6,
                ),
              ),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            size: 28,
            color: theme.textTheme.bodyLarge?.color,
          ),
      onTap: onTap,
    );
  }
}

final class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  TextButton build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return TextButton.icon(
      onPressed: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: theme.scaffoldBackgroundColor,
            title: Text(
              'Déconnexion',
              style: TextStyle(color: theme.textTheme.titleLarge?.color),
            ),
            content: Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
              style: TextStyle(
                fontSize: 16,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        );
        if (shouldLogout!) {
          await ref.read(authProvider.notifier).logout();
        }
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
        side: BorderSide(color: theme.colorScheme.error, width: 1.5),
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      label: Text(
        'Se Déconnecter',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.error,
        ),
      ),
      icon: Icon(
        Icons.exit_to_app_rounded,
        color: theme.colorScheme.error,
        size: 24,
      ),
    );
  }
}

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ProfileMenuTile(
      title: 'Mode Sombre',
      icon: Icons.nightlight_outlined,
      trailing: Switch(
        value: theme.brightness == Brightness.dark,
        onChanged: (value) {
          ref.read(themeModeProvider.notifier).toggleTheme(theme.brightness);
        },
        activeTrackColor: theme.colorScheme.primary,
        activeThumbColor: Colors.white,
      ),
      onTap: () {
        ref.read(themeModeProvider.notifier).toggleTheme(theme.brightness);
      },
    );
  }
}
