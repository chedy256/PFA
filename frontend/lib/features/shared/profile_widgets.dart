import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/teacher.dart';
import 'package:pfa/core/models/user.dart';
import 'package:pfa/core/providers/auth_provider.dart';
import 'package:pfa/core/theme/app_fonts.dart';

Column infosSection(User user) => Column(
  spacing: 12,
  children: [
    CircleAvatar(
      radius: 50,
      child: Text(
        user.firstName[0] + user.lastName[0],
        style: const TextStyle(
          color: Colors.black,
          fontFamily: AppFonts.outfit,
          letterSpacing: 2,
          fontSize: 46,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500,letterSpacing: 1.2),
        ),
    Text(user.email, style: TextStyle(fontSize: 16, color: Colors.black54)),
    Text(
      user is Teacher
          ? 'Département: ${user.department}'
          : 'L${(user as Student).level} en ${user.department}',
      style: TextStyle(fontSize: 16, color: Colors.black),
    ),
  ],
);
final class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  TextButton build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Déconnexion'),
            content: const Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Annuler',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.redAccent,
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      label: const Text(
        'Se déconnecter',
        style: TextStyle(fontSize: 18, color: Colors.redAccent),
      ),
      icon: const Icon(Icons.logout, color: Colors.red, size: 24),
    );
  }
}
