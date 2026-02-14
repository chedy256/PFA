import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/features/auth/auth_page.dart';
import 'package:pfa/features/auth/forgot_pass_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ISIMM Internship Management',
      initialRoute: '/login',
      routes: {
        '/login': (context) => const AuthPage(),
        '/resetpass': (context) => const ForgotPassScreen(),
      },
    );
  }
}