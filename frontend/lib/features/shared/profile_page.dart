import 'package:flutter/material.dart';
import 'package:pfa/core/models/student.dart';
import 'package:pfa/core/models/user.dart';
import 'package:pfa/features/shared/profile_widgets.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 28,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
        centerTitle: true,
        leading: (user is Student)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 26,
                    color: theme.iconTheme.color,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _mainScaffold(context),
    );
  }

  Widget _mainScaffold(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: infosSection(context, user)),
            const SizedBox(height: 48),
            if (user is Student) ...[
              const ProfileMenuTile(
                title: 'Changer le sujet',
                subtitle: 'Ceci est limité à une durée limitée',
                icon: Icons.edit_outlined,
              ),
              const SizedBox(height: 32),
            ],

            Text(
              'Preferences',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 16),
            const ThemeToggleButton(),
            const ProfileMenuTile(
              title: 'Notifications',
              icon: Icons.notifications_none_rounded,
            ),
            const SizedBox(height: 48),
            const LogoutButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
