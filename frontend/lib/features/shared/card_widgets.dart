import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/core/models/user.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/features/shared/profile_page.dart';
import 'package:pfa/features/shared/internship_details_page.dart';

Row welcomeWidget(BuildContext context, WidgetRef ref, User user) {
  final theme = Theme.of(context);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue,',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: theme.textTheme.displayMedium?.color,
              ),
            ),
            Text(
              '${user.firstName} ${user.lastName} !',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodyMedium?.color,
                letterSpacing: 0.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),

      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(user: user),
                ),
              );
            },
            child: CircleAvatar(
              radius: 26,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              child: Text(
                user.firstName[0] + user.lastName[0],
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontFamily: 'Outfit',
                  letterSpacing: 2,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Material intershipCard(BuildContext context, Internship? internship) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Material(
    color: theme.cardTheme.color,
    shadowColor: isDark ? Colors.transparent : AppColors.shadow,
    elevation: isDark ? 0 : 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
      side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if (internship != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  InternshipDetailsPage(internship: internship),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: (internship == null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Stage en cours',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  Text(
                    'Aucun stage en cours',
                    style: TextStyle(
                      fontSize: 15,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        alignment: Alignment.center,
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Postuler votre stage',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          internship.position,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleMedium?.color,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: internship.status.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          internship.status.displayName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: internship.status.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    internship.companyName,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    internship.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.textTheme.bodyMedium?.color,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Encadré par:',
                              style: TextStyle(
                                fontSize: 13,
                                color:
                                    theme.textTheme.bodySmall?.color ??
                                    (isDark
                                        ? AppColors.darkTextTertiary
                                        : AppColors.textTertiary),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${internship.supervisorTeacher?.firstName ?? 'Pas encore assigné'} ${internship.supervisorTeacher?.lastName ?? ''}',
                              style: TextStyle(
                                fontSize: 15,
                                color: theme.textTheme.bodyLarge?.color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: theme.colorScheme.primary,
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
