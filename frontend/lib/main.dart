import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pfa/features/splash_screen.dart';
import 'package:pfa/features/teacher/home_page.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'package:pfa/features/auth/auth_page.dart';
import 'package:pfa/features/auth/forgot_pass_screen.dart';
import 'package:pfa/features/student/home_page.dart';
import 'package:pfa/core/providers/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final savedTheme = prefs.getString('theme_mode');
  final initialTheme = ThemeMode.values.firstWhere(
    (e) => e.name == savedTheme,
    orElse: () => ThemeMode.system,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ProviderScope(
      overrides: [initialThemeModeProvider.overrideWithValue(initialTheme)],
      child: const MyApp(),
    ),
  );
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
      initialRoute: kIsWeb ? '/login' : '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const AuthPage(),
        '/resetpass': (context) => const ForgotPassScreen(),
        '/student': (context) => const StudentHomePage(),
        '/teacher': (context) => const TeacherHomePage(),
      },
    );
  }
}
