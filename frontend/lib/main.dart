import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pfa/features/teacher/home_page.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:pfa/features/auth/auth_page.dart';
import 'package:pfa/features/auth/forgot_pass_screen.dart';
import 'package:pfa/features/student/home_page.dart';
import 'package:pfa/core/providers/theme_provider.dart';

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
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      title: 'ISIMM Internship Management',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const AuthPage(),
        '/resetpass': (context) => const ForgotPassScreen(),
        '/student': (context) => const StudentHomePage(),
        '/teacher': (context) => const TeacherHomePage(),
      },
    );
  }
}
