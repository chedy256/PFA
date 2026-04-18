import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/providers/auth_provider.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final String? allowedRole; // If null, any logged in user can access

  const AuthGuard({super.key, required this.child, this.allowedRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          // Redirect to login if not authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final normalizedRole = user.role.toLowerCase() == 'etudiant' ? 'student' : user.role.toLowerCase() == 'enseignant' ? 'teacher' : user.role.toLowerCase();
        final normalizedAllowed = allowedRole?.toLowerCase() == 'etudiant' ? 'student' : allowedRole?.toLowerCase() == 'enseignant' ? 'teacher' : allowedRole?.toLowerCase();

        // If a specific role is required and user doesn't have it
        if (normalizedAllowed != null && normalizedRole != normalizedAllowed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (normalizedRole == 'student') {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/student', (route) => false);
            } else if (normalizedRole == 'teacher') {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/teacher', (route) => false);
            } else {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return child;
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(
        body: Center(child: Text('Authentication error: ${e.toString()}')),
      ),
    );
  }
}
