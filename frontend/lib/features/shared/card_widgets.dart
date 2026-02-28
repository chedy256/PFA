import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/models/internship.dart';
import 'package:pfa/core/models/user.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/features/shared/profile_page.dart';
import 'package:pfa/features/shared/internship_details_page.dart';

Row welcomeWidget(BuildContext context, WidgetRef ref, User user) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenue,',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            '${user.firstName} ${user.lastName} !',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),

      InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
          );
        },
        child: CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.cardBackground,
          child: Text(
            user.firstName[0] + user.lastName[0],
            style: const TextStyle(
              color: Colors.black87,
              fontFamily: 'Outfit',
              letterSpacing: 2,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  );
}

Material intershipCard(BuildContext context, Internship? internship) {
  return Material(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (internship != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InternshipDetailsPage(internship: internship),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: (internship == null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Stage en cours',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Aucun stage en cours',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Center(
                    child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        alignment: Alignment.center,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Postuler votre stage',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        internship.position,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
                          border: Border.all(color: internship.status.color.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          internship.status.displayName.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: internship.status.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    internship.companyName,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    internship.description,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Encadré par:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${internship.supervisorTeacher?.firstName ?? 'Pas encore assigné'} ${internship.supervisorTeacher?.lastName ?? ''}',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
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
