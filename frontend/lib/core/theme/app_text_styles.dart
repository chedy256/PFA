import 'package:flutter/material.dart';

import 'app_fonts.dart';

final class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle topBg = TextStyle(
    fontSize: 35,
    color: Color(0xFF152839),
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.chrisye,
  );
  static const TextStyle bottomBg = TextStyle(
    fontSize: 28,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: AppFonts.dreamOrphanage,
    letterSpacing: 1.1
  );
  static const TextStyle heading0 = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.bold,
    fontSize: 50,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const TextStyle planBtn = TextStyle(
    fontFamily: AppFonts.dreamOrphanage,
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: Colors.black87,
  );

  static const TextStyle navigation = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w800,
    fontSize: 24,
    color: Colors.black87,
  );

  static const TextStyle cardHeading = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: AppFonts.rethinkSans,
    fontSize: 22,
    letterSpacing: 1.1,
  );

  static const TextStyle cardBody = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle indicator = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.manrope,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: Colors.black38,
  );

  static const TextStyle settingsHeading = TextStyle(
    fontWeight: FontWeight.w800,
    fontFamily: AppFonts.rethinkSans,
    fontSize: 22,
    letterSpacing: 1.1,
  );

  static const TextStyle settingsBody = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: AppFonts.dreamOrphanage,
    fontWeight: FontWeight.bold,
    fontSize: 30,
    letterSpacing: 1.4
  );
  static const TextStyle version = TextStyle(
    fontFamily: AppFonts.manrope,
    fontWeight: FontWeight.w400,
    fontSize: 16, letterSpacing: 1.2
  );
}
