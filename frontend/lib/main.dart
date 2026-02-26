import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_fonts.dart';
import 'firebase_options.dart';
import 'package:pfa/features/auth/auth_page.dart';
import 'package:pfa/features/auth/forgot_pass_screen.dart';
import 'package:pfa/features/student/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: AppFonts.outfit,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey,
            textStyle: const TextStyle(
              fontFamily: AppFonts.outfit,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          labelStyle: const TextStyle(
            fontFamily: AppFonts.outfit,
            fontSize: 16,
            color: Colors.black54,
          ),
          errorStyle: const TextStyle(
            fontFamily: AppFonts.outfit,
            fontSize: 14,
            color: Colors.red,
          ),
          suffixIconColor: Colors.black87,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'ISIMM Internship Management',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const AuthPage(),
        '/resetpass': (context) => const ForgotPassScreen(),
        '/student': (context) => const StudentHomePage(),
      },
    );
  }
}